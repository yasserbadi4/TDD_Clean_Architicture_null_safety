import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'core/utilities/input_converter.dart';
import 'features/number_trivia/data/data_sources/local_data_source/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/data_sources/local_data_source/number_trivia_local_data_source_impl.dart';
import 'features/number_trivia/data/data_sources/remote_data_source/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/data_sources/remote_data_source/number_trivia_remote_data_source_impl.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeServiceLocator() async {
  //! Features - NumberTrivia
  //* presentation logic holder
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  //* use cases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  //* repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInformation: serviceLocator(),
    ),
  );

  //* data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImplementation(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImplementation(
      sharedPreferences: serviceLocator(),
    ),
  );

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());

  serviceLocator.registerLazySingleton<NetworkInformation>(
      () => NetworkInformationImplementation(serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
