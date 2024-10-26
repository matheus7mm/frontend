import 'package:flutter/material.dart';

import 'application/application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator(useMocks: true);

  runApp(const App());
}
