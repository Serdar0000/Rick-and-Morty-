class AppConstants {
  // API
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String charactersEndpoint = '/character';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Pagination
  static const int itemsPerPage = 20;
  static const double scrollThreshold = 0.9;
  
  // Hive Boxes
  static const String charactersBox = 'characters';
  static const String favoritesBox = 'favorites';
  
  // Messages
  static const String errorLoadingCharacters = 'Failed to load characters';
  static const String errorLoadingFavorites = 'Failed to load favorites';
  static const String errorNetwork = 'No internet connection. Showing cached data.';
  static const String noFavoritesTitle = 'No favorites yet';
  static const String noFavoritesSubtitle = 'Add characters to your favorites\nby tapping the star icon';
}

class AppStrings {
  static const String appTitle = 'Rick and Morty';
  static const String charactersTab = 'Characters';
  static const String favoritesTab = 'Favorites';
  static const String sortAZ = 'Name (A-Z)';
  static const String sortZA = 'Name (Z-A)';
  static const String retry = 'Retry';
  static const String refresh = 'Refresh';
}
