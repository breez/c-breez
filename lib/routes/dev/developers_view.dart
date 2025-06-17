import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/configs/config.dart';
import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:c_breez/routes/dev/command_line_interface.dart';
import 'package:c_breez/routes/dev/widget/widgets.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:c_breez/services/services.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final Logger _logger = Logger("DevelopersView");

bool allowRebroadcastRefunds = false;
final AutoSizeGroup labelAutoSizeGroup = AutoSizeGroup();

class Choice {
  const Choice({required this.title, required this.icon, required this.function});

  final String title;
  final IconData icon;
  final Function(BuildContext context) function;
}

class DevelopersView extends StatefulWidget {
  const DevelopersView({super.key});

  @override
  State<DevelopersView> createState() => _DevelopersViewState();
}

class _DevelopersViewState extends State<DevelopersView> with SingleTickerProviderStateMixin {
  final BreezPreferences _preferences = const BreezPreferences();
  final OverlayManager _overlayManager = OverlayManager();

  BugReportBehavior _bugReportBehavior = BugReportBehavior.PROMPT;
  String _sdkVersion = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeViewData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _overlayManager.removeLoadingOverlay();
    super.dispose();
  }

  /// Initializes all data required by the view
  Future<void> _initializeViewData() async {
    await Future.wait(<Future<void>>[_loadSdkVersion(), _loadPreferences()]);
  }

  /// Loads the SDK version
  Future<void> _loadSdkVersion() async {
    try {
      final String version = await SdkVersionService.getSdkVersion();
      if (mounted) {
        setState(() => _sdkVersion = version);
      }
    } catch (e) {
      _logger.warning('Failed to load SDK version: $e');
      if (mounted) {
        setState(() => _sdkVersion = 'Error loading version');
      }
    }
  }

  /// Loads user preferences related to bug reporting
  Future<void> _loadPreferences() async {
    try {
      final BugReportBehavior behavior = await _preferences.getBugReportBehavior();
      if (mounted) {
        setState(() => _bugReportBehavior = behavior);
      }
    } catch (e) {
      _logger.warning('Failed to load preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final texts = getSystemAppLocalizations();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const back_button.BackButton(),
          title: Text(texts.home_drawer_item_title_developers),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'CLI'),
              Tab(text: 'Info'),
            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: [
            CommandLineInterface(scaffoldKey: scaffoldKey),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  /// Builds the information card showing wallet and SDK details
  Widget _buildInfoCard() {
    final ThemeData themeData = Theme.of(context);
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (AccountState previous, AccountState current) {
        return previous.id != current.id ||
            previous.balanceSat != current.balanceSat ||
            previous.maxInboundLiquiditySat != current.maxInboundLiquiditySat ||
            previous.blockheight != current.blockheight;
      },
      builder: (BuildContext context, AccountState accountState) {
        return Card(
          color: themeData.customData.surfaceBgColor,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  <Widget>[
                      StatusItem(label: 'SDK Version', value: _sdkVersion),
                      if (accountState.id != null) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ShareablePaymentRow(
                            tilePadding: EdgeInsets.zero,
                            dividerColor: Colors.transparent,
                            title: 'Node ID',
                            titleTextStyle: themeData.primaryTextTheme.headlineMedium?.copyWith(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            labelAutoSizeGroup: labelAutoSizeGroup,
                            valueAutoSizeGroup: labelAutoSizeGroup,
                            sharedValue: accountState.id!,
                            shouldPop: false,
                            trimTitle: false,
                          ),
                        ),
                      ],
                      if (accountState.balanceSat > 0) ...<Widget>[
                        StatusItem(label: 'Balance', value: '${accountState.balanceSat}'),
                      ],
                      if (accountState.maxInboundLiquiditySat > 0) ...<Widget>[
                        StatusItem(
                          label: 'Inbound Liquidity',
                          value: '${accountState.maxInboundLiquiditySat}',
                        ),
                      ],
                      if (accountState.blockheight > 0) ...<Widget>[
                        StatusItem(label: 'Node Blockheight', value: '${accountState.blockheight}'),
                      ],

                      _buildActionButtons(),
                    ].expand((Widget widget) sync* {
                      yield widget;
                      yield const Divider(
                        height: 8.0,
                        color: Color.fromRGBO(40, 59, 74, 0.5),
                        indent: 0.0,
                        endIndent: 0.0,
                      );
                    }).toList()
                    ..removeLast(),
            ),
          ),
        );
      },
    );
  }

  /// Builds the grid of action buttons
  Widget _buildActionButtons() {
    final BreezTranslations texts = context.texts();

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 32.0,
        childAspectRatio: 3,
        children: <Widget>[
          GridActionButton(
            icon: Icons.refresh,
            // TODO(erdemyerebasmaz): Add messages to Breez-Translations
            label: 'Sync',
            tooltip: 'Sync Wallet',
            onPressed: _syncWallet,
          ),
          GridActionButton(
            icon: Icons.key,
            // TODO(erdemyerebasmaz): Add message to Breez-Translations
            label: 'Keys',
            tooltip: texts.developers_page_menu_export_keys_title,
            onPressed: _exportKeys,
          ),
          GridActionButton(
            icon: Icons.share,
            // TODO(erdemyerebasmaz): Add message to Breez-Translations
            label: 'Logs',
            tooltip: texts.developers_page_menu_share_logs_title,
            onPressed: _shareLogs,
          ),
          GridActionButton(
            icon: Icons.radar,
            // TODO(erdemyerebasmaz): Add messages to Breez-Translations
            label: 'Rescan',
            tooltip: 'Rescan Swaps',
            onPressed: _rescanSwaps,
          ),
          GridActionButton(
            icon: Icons.charging_station,
            // TODO(erdemyerebasmaz): Add messages to Breez-Translations
            label: 'Backup',
            tooltip: 'Export Static Backup',
            onPressed: _exportStaticBackup,
          ),
          if (_bugReportBehavior != BugReportBehavior.PROMPT)
            GridActionButton(
              icon: Icons.bug_report,
              // TODO(erdemyerebasmaz): Add message to Breez-Translations
              label: 'Bug Report',
              tooltip: texts.developers_page_menu_prompt_bug_report_title,
              onPressed: _toggleBugReportBehavior,
            ),
        ],
      ),
    );
  }

  /// Syncs the wallet with the network
  Future<void> _syncWallet() async {
    _overlayManager.showLoadingOverlay(context);

    try {
      await ServiceInjector().breezSDK.sync();

      if (mounted) {
        showFlushbar(context, message: 'Wallet synced successfully.');
      }
    } catch (e) {
      _logger.warning('Failed to sync wallet: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to sync wallet.');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  /// Exports wallet keys and credentials to a zip file
  Future<void> _exportKeys() async {
    _overlayManager.showLoadingOverlay(context);

    try {
      if (kDebugMode) {
        final String keysZipPath = await WalletArchiveService.createKeysArchive();

        final ShareParams shareParams = ShareParams(title: 'Keys', files: <XFile>[XFile(keysZipPath)]);
        SharePlus.instance.share(shareParams);
      } else {
        final CredentialsManager credentialsManager = ServiceInjector().credentialsManager;
        final List<File> credentialFile = await credentialsManager.exportCredentials();

        final ShareParams shareParams = ShareParams(
          title: 'Keys',
          files: <XFile>[XFile(credentialFile.first.path)],
        );
        SharePlus.instance.share(shareParams);
      }
    } catch (e) {
      _logger.severe('Failed to export keys: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to export keys: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  void _exportStaticBackup() async {
    _overlayManager.showLoadingOverlay(context);

    final texts = getSystemAppLocalizations();

    try {
      const name = "scb.recover";
      final CredentialsManager credentialsManager = ServiceInjector().credentialsManager;
      final staticBackup = await credentialsManager.exportStaticChannelBackup();

      if (staticBackup.backup != null) {
        final backup = staticBackup.backup;

        final emergencyList = backup!.toString();

        Config config = await Config.instance();
        String workingDir = config.sdkConfig.workingDir;
        String filePath = '$workingDir/$name';
        File file = File(filePath);
        await file.writeAsString(emergencyList, flush: true);
        final ShareParams shareParams = ShareParams(title: 'Static Backup', files: <XFile>[XFile(filePath)]);
        SharePlus.instance.share(shareParams);
      } else {
        if (!mounted) return;
        showFlushbar(context, title: texts.backup_export_static_error_data_missing);
      }
    } catch (e) {
      _logger.severe('Failed to export static backup: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to export static backup: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  /// Rescans on-chain swaps for the user
  Future<void> _rescanSwaps() async {
    _overlayManager.showLoadingOverlay(context);

    final texts = getSystemAppLocalizations();
    final revSwapBloc = context.read<ReverseSwapBloc>();

    try {
      await revSwapBloc.rescanSwaps();

      if (mounted) {
        showFlushbar(context, message: 'Rescanned on-chain swaps successfully.');
      }
    } catch (e) {
      _logger.warning('Failed to rescan on-chain swaps: $e');

      if (mounted) {
        showFlushbar(context, message: ExceptionHandler.extractMessage(e, texts));
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  /// Share application logs
  Future<void> _shareLogs() async {
    _overlayManager.showLoadingOverlay(context);

    try {
      final String zipPath = await WalletArchiveService.createLogsArchive();
      final ShareParams shareParams = ShareParams(title: 'Logs', files: <XFile>[XFile(zipPath)]);
      SharePlus.instance.share(shareParams);
    } catch (e) {
      _logger.severe('Failed to share logs: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to share logs: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  /// Toggles the bug report behavior setting to prompt
  Future<void> _toggleBugReportBehavior() async {
    _overlayManager.showLoadingOverlay(context);
    try {
      await _preferences.setBugReportBehavior(BugReportBehavior.PROMPT);

      if (mounted) {
        setState(() => _bugReportBehavior = BugReportBehavior.PROMPT);
        showFlushbar(context, message: 'Successfully updated bug report setting.');
      }
    } catch (e) {
      _logger.warning('Failed to update bug report setting: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to update bug report settings');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }
}
