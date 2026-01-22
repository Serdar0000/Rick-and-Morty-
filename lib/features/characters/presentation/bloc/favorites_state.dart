import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';
import 'favorites_event.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Character> favorites;
  final SortOrder sortOrder;

  const FavoritesLoaded({
    required this.favorites,
    this.sortOrder = SortOrder.nameAsc,
  });

  FavoritesLoaded copyWith({
    List<Character>? favorites,
    SortOrder? sortOrder,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object> get props => [favorites, sortOrder];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}
