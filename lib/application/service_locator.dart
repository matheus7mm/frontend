import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../data/data.dart';

import '../domain/domain.dart';

import '../presentation/presentation.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator({bool useMocks = false}) {
  log("Registering Dio...");
  locator.registerSingleton<Dio>(DioProvider.createDio(useMocks: useMocks));

  log("Registering Data Sources...");
  locator.registerLazySingleton(() => RemoteUserDataSource(locator<Dio>()));
  locator.registerLazySingleton(() => RemoteCarDataSource(locator<Dio>()));

  log("Registering Repositories...");
  // Registering Repositories with explicit typing
  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(locator<RemoteUserDataSource>()));
  locator.registerLazySingleton<CarRepository>(
      () => CarRepositoryImpl(locator<RemoteCarDataSource>()));
  locator.registerLazySingleton<TokenRepository>(() => TokenRepositoryImpl());

  log("Registering Use Cases...");
  locator.registerLazySingleton(() => LoginUser(locator()));
  locator.registerLazySingleton(() => RegisterUser(locator()));
  locator.registerLazySingleton(() => GetCars(locator()));
  locator.registerLazySingleton(() => CreateCar(locator()));
  locator.registerLazySingleton(() => UpdateCar(locator()));
  locator.registerLazySingleton(() => DeleteCar(locator()));
  locator.registerLazySingleton(() => SaveToken(locator()));
  locator.registerLazySingleton(() => GetToken(locator()));
  locator.registerLazySingleton(() => ClearToken(locator()));

  log("Registering Presenters...");
  locator.registerFactory(() => AuthBloc(
        loginUser: locator(),
        getToken: locator(),
        saveToken: locator(),
      ));
  locator.registerFactory(() => CarBloc(
        getCars: locator(),
        createCar: locator(),
        updateCar: locator(),
        deleteCar: locator(),
        clearToken: locator(),
      ));
  locator.registerFactory(() => UserRegisterBloc(
        registerUser: locator(),
      ));

  log("Dependency registration completed.");
}
