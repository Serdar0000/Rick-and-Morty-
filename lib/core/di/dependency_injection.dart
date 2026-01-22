import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/characters/data/datasources/character_local_data_source.dart';
import '../../features/characters/data/datasources/character_remote_data_source.dart';
import '../../features/characters/data/models/character_model.dart';
import '../../features/characters/data/repositories/character_repository_impl.dart';
import '../../features/characters/domain/repositories/character_repository.dart';
import '../network/network_info.dart';

class DependencyInjection {
  static late Dio dio;
  static late CharacterRemoteDataSource remoteDataSource;
  static late CharacterLocalDataSource localDataSource;
  static late NetworkInfo networkInfo;
  static late CharacterRepository characterRepository;

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register Hive adapters
    Hive.registerAdapter(CharacterModelAdapter());

    // Initialize Dio
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Initialize data sources
    remoteDataSource = CharacterRemoteDataSourceImpl(dio: dio);
    localDataSource = CharacterLocalDataSourceImpl();
    networkInfo = NetworkInfoImpl();

    // Initialize repository
    characterRepository = CharacterRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  }
}
