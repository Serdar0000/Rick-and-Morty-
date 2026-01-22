import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';

abstract class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object> get props => [];
}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasReachedMax;
  final int currentPage;

  const CharactersLoaded({
    required this.characters,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  CharactersLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [characters, hasReachedMax, currentPage];
}

class CharactersError extends CharactersState {
  final String message;

  const CharactersError(this.message);

  @override
  List<Object> get props => [message];
}
