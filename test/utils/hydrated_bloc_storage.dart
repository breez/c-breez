import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Future<void> setUpHydratedBloc() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: Directory("${Directory.current.path}/.dart_tool/hydrated_bloc_test_storage"),
  );
}

Future<void> tearDownHydratedBloc() async {
  await HydratedBloc.storage.clear();
}

