import 'package:go_router/go_router.dart';

import '../presentation/screens/screens.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/car_list',
      builder: (context, state) => CarListScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => UserRegisterScreen(),
    ),
  ],
);
