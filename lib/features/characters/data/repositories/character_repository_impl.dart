import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_data_source.dart';
import '../datasources/character_remote_data_source.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Character>>> getCharacters(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getCharacters(page);
        
        // Cache characters for offline access
        if (page == 1) {
          await localDataSource.cacheCharacters(response.results);
        }
        
        // Mark favorites
        final characters = await _markFavorites(response.results);
        
        return Right(characters.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedCharacters = await localDataSource.getCachedCharacters();
        final characters = await _markFavorites(cachedCharacters);
        return Right(characters.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(Character character) async {
    try {
      await localDataSource.addToFavorites(
        CharacterModel.fromEntity(character),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(int characterId) async {
    try {
      await localDataSource.removeFromFavorites(characterId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    return await localDataSource.isFavorite(characterId);
  }

  Future<List<CharacterModel>> _markFavorites(
      List<CharacterModel> characters) async {
    final markedCharacters = <CharacterModel>[];
    for (var character in characters) {
      final isFav = await isFavorite(character.id);
      markedCharacters.add(character.copyWith(isFavorite: isFav));
    }
    return markedCharacters;
  }
}
