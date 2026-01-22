import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'characters_event.dart';
import 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepository repository;

  CharactersBloc({required this.repository}) : super(CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<RefreshCharacters>(_onRefreshCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    emit(CharactersLoading());
    
    final result = await repository.getCharacters(1);
    
    result.fold(
      (failure) => emit(const CharactersError('Failed to load characters')),
      (characters) => emit(CharactersLoaded(
        characters: characters,
        currentPage: 1,
        hasReachedMax: false,
      )),
    );
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      
      if (currentState.hasReachedMax) return;

      final nextPage = currentState.currentPage + 1;
      final result = await repository.getCharacters(nextPage);

      result.fold(
        (failure) => emit(currentState.copyWith(hasReachedMax: true)),
        (newCharacters) {
          if (newCharacters.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(currentState.copyWith(
              characters: [...currentState.characters, ...newCharacters],
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    final result = await repository.getCharacters(1);
    
    result.fold(
      (failure) => emit(const CharactersError('Failed to refresh characters')),
      (characters) => emit(CharactersLoaded(
        characters: characters,
        currentPage: 1,
        hasReachedMax: false,
      )),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<CharactersState> emit,
  ) async {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      final character = event.character;

      if (character.isFavorite) {
        await repository.removeFromFavorites(character.id);
      } else {
        await repository.addToFavorites(character);
      }

      // Update the character in the list
      final updatedCharacters = currentState.characters.map((c) {
        if (c.id == character.id) {
          return c.copyWith(isFavorite: !c.isFavorite);
        }
        return c;
      }).toList();

      emit(currentState.copyWith(characters: updatedCharacters));
    }
  }
}
