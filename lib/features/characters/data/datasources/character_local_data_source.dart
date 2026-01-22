import 'package:hive/hive.dart';
import '../models/character_model.dart';

abstract class CharacterLocalDataSource {
  Future<List<CharacterModel>> getCachedCharacters();
  Future<void> cacheCharacters(List<CharacterModel> characters);
  Future<List<CharacterModel>> getFavorites();
  Future<void> addToFavorites(CharacterModel character);
  Future<void> removeFromFavorites(int characterId);
  Future<bool> isFavorite(int characterId);
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  static const String charactersBox = 'characters';
  static const String favoritesBox = 'favorites';

  @override
  Future<List<CharacterModel>> getCachedCharacters() async {
    final box = await Hive.openBox<CharacterModel>(charactersBox);
    return box.values.toList();
  }

  @override
  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    final box = await Hive.openBox<CharacterModel>(charactersBox);
    
    // Clear old cache and add new
    await box.clear();
    for (var character in characters) {
      await box.put(character.id, character);
    }
  }

  @override
  Future<List<CharacterModel>> getFavorites() async {
    final box = await Hive.openBox<CharacterModel>(favoritesBox);
    return box.values.toList();
  }

  @override
  Future<void> addToFavorites(CharacterModel character) async {
    final box = await Hive.openBox<CharacterModel>(favoritesBox);
    await box.put(character.id, character.copyWith(isFavorite: true));
  }

  @override
  Future<void> removeFromFavorites(int characterId) async {
    final box = await Hive.openBox<CharacterModel>(favoritesBox);
    await box.delete(characterId);
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    final box = await Hive.openBox<CharacterModel>(favoritesBox);
    return box.containsKey(characterId);
  }
}
