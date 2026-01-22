import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class RemoveFavorite extends FavoritesEvent {
  final int characterId;

  const RemoveFavorite(this.characterId);

  @override
  List<Object> get props => [characterId];
}

class SortFavorites extends FavoritesEvent {
  final SortOrder sortOrder;

  const SortFavorites(this.sortOrder);

  @override
  List<Object> get props => [sortOrder];
}

enum SortOrder { nameAsc, nameDesc }
