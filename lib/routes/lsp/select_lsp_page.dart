import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class SelectLSPPage extends StatefulWidget {
  final LSPBloc lstBloc;

  const SelectLSPPage({Key? key, required this.lstBloc}) : super(key: key);

  @override
  SelectLSPPageState createState() {
    return SelectLSPPageState();
  }
}

class SelectLSPPageState extends State<SelectLSPPage> {
  LspInformation? _selectedLSP;
  dynamic _error;
  List<LspInformation>? _lspList;

  @override
  void initState() {
    super.initState();
    _fetchLSPS();
  }

  Future _fetchLSPS() async {
    var lspList = await widget.lstBloc.lspList;
    setState(() {
      _lspList = lspList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select a Lightning Provider"),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              // Color needs to be changed
              icon: Icon(Icons.close,
                  color: Theme.of(context).appBarTheme.iconTheme!.color))
        ],
      ),
      body: StreamBuilder<LspInformation?>(
          stream: widget.lstBloc.stream,
          builder: (context, lsp) {
            if (_error != null) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const <Widget>[
                    Text(
                        "There was an error fetching lightning providers. Please check your internet connection and try again.",
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            if (_lspList == null) {
              return const Center(child: Loader());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Flexible(
                      child: Text(
                    "Please select one of the following providers in order to activate Breez and connect to the Lightning network.",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                  )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: _lspList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            selected: _selectedLSP?.id == _lspList![index].id,
                            trailing: _selectedLSP?.id == _lspList![index].id
                                ? const Icon(Icons.check)
                                : null,
                            title: Text(_lspList![index].name),
                            onTap: () {
                              setState(() {
                                _selectedLSP = _lspList![index];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget? _buildBottomButton() {
    if (_error != null) {
      return SingleButtonBottomBar(
        text: "RETRY",
        onPressed: () {
          setState(() {
            _error = null;
            _fetchLSPS();
          });
        },
      );
    }
    if (_selectedLSP != null) {
      return SingleButtonBottomBar(
          text: "SELECT",
          onPressed: () async {
            widget.lstBloc.connectLSP(_selectedLSP!.id);
            Navigator.pop(context);
          });
    }
    return null;
  }
}
