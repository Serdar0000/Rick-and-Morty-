import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CharacterRepository repository;

  FavoritesBloc({required this.repository}) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<SortFavorites>(_onSortFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    
    final result = await repository.getFavorites();
    
    result.fold(
      (failure) => emit(const FavoritesError('Failed to load favorites')),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      
      await repository.removeFromFavorites(event.characterId);
      
      final updatedFavorites = currentState.favorites
          .where((character) => character.id != event.characterId)
          .toList();
      
      emit(currentState.copyWith(favorites: updatedFavorites));
    }
  }

  Future<void> _onSortFavorites(
    SortFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final sortedFavorites = List.of(currentState.favorites);

      if (event.sortOrder == SortOrder.nameAsc) {
        sortedFavorites.sort((a, b) => a.name.compareTo(b.name));
      } else {
        sortedFavorites.sort((a, b) => b.name.compareTo(a.name));
      }

      emit(currentState.copyWith(
        favorites: sortedFavorites,
        sortOrder: event.sortOrder,
      ));
    }
  }
}
