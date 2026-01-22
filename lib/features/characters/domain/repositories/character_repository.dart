import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<Character>>> getCharacters(int page);
  Future<Either<Failure, List<Character>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(Character character);
  Future<Either<Failure, void>> removeFromFavorites(int characterId);
  Future<bool> isFavorite(int characterId);
}
