import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/application/router.dart';

import '../presentation/presenters/presenters.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.instance<AuthBloc>()..add(AutoLoginEvent()),
        ),
        BlocProvider<CarBloc>(
          create: (_) => GetIt.instance<CarBloc>(),
        ),
        BlocProvider<UserRegisterBloc>(
          create: (_) => GetIt.instance<UserRegisterBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Car Management App',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: router,
      ),
    );
  }
}
