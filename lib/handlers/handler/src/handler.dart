import 'package:c_breez/handlers/handlers.dart';
import 'package:flutter/cupertino.dart';

abstract class Handler {
  HandlerContextProvider<StatefulWidget>? contextProvider;

  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    this.contextProvider = contextProvider;
  }

  void dispose() {
    contextProvider = null;
  }
}
