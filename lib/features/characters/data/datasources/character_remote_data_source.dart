import 'package:dio/dio.dart';
import '../models/character_response.dart';

abstract class CharacterRemoteDataSource {
  Future<CharacterResponse> getCharacters(int page);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<CharacterResponse> getCharacters(int page) async {
    try {
      final response = await dio.get(
        '$baseUrl/character',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        return CharacterResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }
}
