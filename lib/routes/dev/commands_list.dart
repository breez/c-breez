import 'dart:convert';
import 'dart:io';

import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;

class CommandsList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CommandsList({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<CommandsList> createState() => _CommandsListState();
}

class _CommandsListState extends State<CommandsList> {
  final _cliInputController = TextEditingController();
  final FocusNode _cliEntryFocusNode = FocusNode();

  String _cliText = '';
  String _lastCommand = '';
  TextStyle _cliTextStyle = theme.smallTextStyle;
  bool _showDefaultCommands = true;
  bool isLoading = false;
  var _richCliText = <TextSpan>[];
  late final breez_sdk.NodeAPI nodeAPI;

  @override
  void initState() {
    super.initState();
    initializeNodeAPI();
  }

  void initializeNodeAPI() async {
    var lightningServices = await ServiceInjector().lightningServices;
    nodeAPI = lightningServices.getNodeAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                focusNode: _cliEntryFocusNode,
                controller: _cliInputController,
                decoration: const InputDecoration(
                  hintText: 'Enter a command or use the links below',
                ),
                onSubmitted: (command) {
                  _sendCommand(command);
                },
              )),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Run',
                onPressed: () {
                  _sendCommand(_cliInputController.text);
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear',
                onPressed: () {
                  setState(() {
                    _cliInputController.clear();
                    _showDefaultCommands = true;
                    _lastCommand = '';
                    _cliText = "";
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Container(
              padding: _showDefaultCommands
                  ? const EdgeInsets.all(0.0)
                  : const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                border: _showDefaultCommands
                    ? null
                    : Border.all(width: 1.0, color: const Color(0x80FFFFFF)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _showDefaultCommands
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              tooltip: 'Copy to Clipboard',
                              iconSize: 19.0,
                              onPressed: () {
                                ServiceInjector()
                                    .device
                                    .setClipboardText(_cliText);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Copied to clipboard.',
                                      style: theme.snackBarStyle,
                                    ),
                                    backgroundColor:
                                        theme.snackBarBackgroundColor,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              iconSize: 19.0,
                              tooltip: 'Share',
                              onPressed: () {
                                _shareFile(
                                  _lastCommand.split(" ")[0],
                                  _cliText,
                                );
                              },
                            )
                          ],
                        ),
                  Expanded(child: _renderBody())
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderBody() {
    if (isLoading) {
      return const Center(child: Loader());
    }
    if (_showDefaultCommands) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ListView(
          children: defaultCliCommandsText(
            (command) {
              _cliInputController.text = command;
              FocusScope.of(widget.scaffoldKey.currentState!.context)
                  .requestFocus(
                _cliEntryFocusNode,
              );
            },
          ),
        ),
      );
    }
    return ListView(
      children: [
        RichText(
          text: TextSpan(
            style: _cliTextStyle,
            children: _richCliText,
          ),
        )
      ],
    );
  }

  void _sendCommand(String command) async {
    if (command.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _lastCommand = command;
        isLoading = true;
      });
      const JsonEncoder encoder = JsonEncoder.withIndent('    ');
      try {
        var commandArgs = command.split(RegExp(r"\s"));
        if (commandArgs.isEmpty) {
          return;
        }
        late String reply;
        switch (commandArgs[0]) {
          case 'getNodeInfo':
            final nodeInfo = await nodeAPI.getNodeInfo();
            reply = encoder.convert(nodeInfo.toJson());
            break;
          case 'listFunds':
            final funds = await nodeAPI.listFunds();
            reply = encoder.convert(funds.toJson());
            break;
          case 'listPeers':
            final peers = await nodeAPI.listPeers();
            reply = encoder.convert(peers);
            break;
          case 'getPayments':
            final payments = await nodeAPI.getPayments();
            reply = encoder.convert(payments);
            break;
          case 'getInvoices':
            final invoices = await nodeAPI.getInvoices();
            reply = encoder.convert(invoices);
            break;
          case 'closeChannel':
            if (commandArgs.length < 2) {
              throw "Missing node id";
            }
            var nodeID = HEX.decode(commandArgs[1]);
            final closedResponse = await nodeAPI.closeChannel(nodeID);
            reply = encoder.convert(closedResponse);
            break;
          default:
            throw "This command is not supported yet.";
        }
        setState(() {
          _showDefaultCommands = false;
          _cliTextStyle = theme.smallTextStyle;
          _cliText = reply;
          _richCliText = <TextSpan>[TextSpan(text: _cliText)];
          isLoading = false;
        });
      } catch (error) {
        setState(() {
          _showDefaultCommands = false;
          _cliText = error.toString();
          _cliTextStyle = theme.warningStyle;
          _richCliText = <TextSpan>[TextSpan(text: _cliText)];
          isLoading = false;
        });
      }
      setState(() => isLoading = false);
    }
  }

  void _shareFile(String command, String text) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("command");
    String filePath = '${tempDir.path}/$command.json';
    File file = File(filePath);
    await file.writeAsString(text, flush: true);
    ShareExtend.share(filePath, "file");
  }
}

class Command extends StatelessWidget {
  final String command;
  final Function(String command) onTap;

  const Command(this.command, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(command);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Text(
          command,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String name;

  const Category(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name, style: Theme.of(context).textTheme.headline6);
  }
}

List<Widget> defaultCliCommandsText(Function(String command) onCommand) => [
      ExpansionTile(
        title: const Text("General"),
        children: <Widget>[
          Command("getNodeInfo", onCommand),
          Command("listFunds", onCommand),
          Command("listPeers", onCommand),
          Command("getPayments", onCommand),
          Command("getInvoices", onCommand),
          Command("closeChannel", onCommand),
        ],
      ),
    ];
