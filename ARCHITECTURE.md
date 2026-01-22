# Архитектурные решения

## Clean Architecture

Проект следует принципам Clean Architecture с разделением на три основных слоя:

### 1. Data Layer (Слой данных)
**Ответственность**: Получение и сохранение данных

#### Компоненты:
- **Models**: Модели данных с JSON serialization и Hive TypeAdapter
  - `CharacterModel` - модель персонажа с поддержкой Hive
  - `CharacterResponse` - обертка для ответа API с пагинацией

- **Data Sources**:
  - `CharacterRemoteDataSource` - работа с API через Dio
  - `CharacterLocalDataSource` - работа с Hive (кеш и избранное)

- **Repository Implementation**:
  - `CharacterRepositoryImpl` - реализация репозитория
  - Логика переключения между remote и local источниками
  - Проверка сети через `NetworkInfo`

### 2. Domain Layer (Бизнес-логика)
**Ответственность**: Бизнес-правила приложения

#### Компоненты:
- **Entities**: Чистые бизнес-объекты
  - `Character` - entity персонажа (независим от фреймворков)

- **Repository Interface**:
  - `CharacterRepository` - абстракция для работы с данными
  - Определяет контракт, реализация в Data Layer

- **Use Cases** (не реализованы, но можно добавить):
  - `GetCharactersUseCase`
  - `ToggleFavoriteUseCase`
  - И т.д.

### 3. Presentation Layer (UI)
**Ответственность**: Отображение и взаимодействие с пользователем

#### Компоненты:
- **BLoC (Business Logic Component)**:
  - `CharactersBloc` - управление списком персонажей и пагинацией
  - `FavoritesBloc` - управление избранными персонажами

- **Pages**: Экраны приложения
  - `HomePage` - главная страница с навигацией
  - `CharactersPage` - список персонажей
  - `FavoritesPage` - список избранных

- **Widgets**: Переиспользуемые UI компоненты
  - `CharacterCard` - карточка персонажа

## State Management: BLoC Pattern

### Почему BLoC?
- ✅ Разделение бизнес-логики и UI
- ✅ Тестируемость
- ✅ Reactive подход (Stream-based)
- ✅ Стандарт для тестовых заданий

### Characters BLoC

**Events**:
- `LoadCharacters` - загрузка первой страницы
- `LoadMoreCharacters` - загрузка следующей страницы (пагинация)
- `RefreshCharacters` - обновление списка (pull-to-refresh)
- `ToggleFavorite` - добавление/удаление из избранного

**States**:
- `CharactersInitial` - начальное состояние
- `CharactersLoading` - загрузка данных
- `CharactersLoaded` - данные загружены
  - `characters` - список персонажей
  - `currentPage` - текущая страница
  - `hasReachedMax` - достигнут конец списка
- `CharactersError` - ошибка загрузки

### Favorites BLoC

**Events**:
- `LoadFavorites` - загрузка избранных
- `RemoveFavorite` - удаление из избранного
- `SortFavorites` - сортировка (A-Z, Z-A)

**States**:
- `FavoritesInitial` - начальное состояние
- `FavoritesLoading` - загрузка
- `FavoritesLoaded` - данные загружены
  - `favorites` - список избранных
  - `sortOrder` - порядок сортировки
- `FavoritesError` - ошибка

## Пагинация (Infinite Scroll)

### Реализация:
1. **ScrollController** отслеживает позицию прокрутки
2. При достижении 90% от максимальной прокрутки вызывается `LoadMoreCharacters`
3. BLoC проверяет, не достигнут ли конец (`hasReachedMax`)
4. Загружается следующая страница и добавляется к существующему списку
5. Отображается индикатор загрузки внизу списка

### Преимущества:
- Быстрая начальная загрузка
- Плавная прокрутка
- Экономия памяти
- Хороший UX

## Кеширование и оффлайн-режим

### Стратегия:

```
1. Проверка интернета (NetworkInfo)
   ├── Есть интернет:
   │   ├── Загрузка с API
   │   ├── Сохранение в Hive (только 1-я страница)
   │   └── Отображение данных
   │
   └── Нет интернета:
       ├── Загрузка из Hive
       └── Отображение кешированных данных
```

### Два типа хранилищ:
1. **Characters Cache** (`charactersBox`):
   - Временное хранилище
   - Обновляется при каждой загрузке
   - Только первая страница

2. **Favorites** (`favoritesBox`):
   - Постоянное хранилище
   - Управляется пользователем
   - Доступно всегда (даже оффлайн)

## Dependency Injection

Простая реализация через синглтон `DependencyInjection`:

```dart
DependencyInjection
  ├── Dio (HTTP client)
  ├── CharacterRemoteDataSource
  ├── CharacterLocalDataSource
  ├── NetworkInfo
  └── CharacterRepository
```

Инициализация в `main()`:
```dart
await DependencyInjection.init();
```

Использование в BLoC:
```dart
CharactersBloc(
  repository: DependencyInjection.characterRepository,
)
```

## Обработка ошибок

### Failure Pattern (Either от dartz):
```dart
Future<Either<Failure, List<Character>>> getCharacters(int page);
```

**Типы Failure**:
- `ServerFailure` - ошибка сервера
- `CacheFailure` - ошибка локальной БД
- `NetworkFailure` - нет интернета

**Преимущества**:
- Явная обработка ошибок
- Функциональный подход
- Типобезопасность

## Дизайн-решения

### Material 3
- Современный дизайн-язык Google
- Динамическая цветовая схема
- Плавные анимации

### UI Компоненты:
- **Card** - для карточек персонажей
- **CachedNetworkImage** - для изображений с кешированием
- **Hero** - для анимации переходов (готово к детальной странице)
- **RefreshIndicator** - pull-to-refresh
- **BottomNavigationBar** - навигация между вкладками

### UX Features:
- Loading indicators (индикаторы загрузки)
- Error states (состояния ошибок)
- Empty states (пустые состояния)
- Pull-to-refresh
- Плавная прокрутка
- Визуальная обратная связь (звездочка для избранного)

## Производительность

### Оптимизации:
1. **Ленивая загрузка** - данные загружаются по мере необходимости
2. **Кеширование изображений** - CachedNetworkImage
3. **ListView.builder** - эффективная отрисовка списков
4. **IndexedStack** - сохранение состояния вкладок
5. **Hive** - быстрая NoSQL БД (быстрее SharedPreferences)

## Масштабируемость

### Возможные улучшения:

1. **Поиск персонажей**:
   ```dart
   class SearchCharacters extends CharactersEvent {
     final String query;
   }
   ```

2. **Фильтрация**:
   ```dart
   class FilterCharacters extends CharactersEvent {
     final String status; // alive, dead, unknown
   }
   ```

3. **Детальная страница**:
   - Использование Hero animation
   - Больше информации о персонаже

4. **Use Cases**:
   - Добавить слой Use Cases между Repository и BLoC
   - Инкапсуляция бизнес-логики

5. **Testing**:
   - Unit tests для BLoC
   - Widget tests для UI
   - Integration tests

## Тестирование

### Структура тестов (рекомендуемая):

```
test/
├── unit/
│   ├── bloc/
│   │   ├── characters_bloc_test.dart
│   │   └── favorites_bloc_test.dart
│   └── repositories/
│       └── character_repository_test.dart
│
├── widget/
│   └── character_card_test.dart
│
└── integration/
    └── app_test.dart
```

## Best Practices

✅ Clean Architecture с четким разделением слоев
✅ SOLID принципы
✅ Dependency Injection
✅ Immutable состояния (Equatable)
✅ Reactive подход (BLoC/Streams)
✅ Обработка ошибок (Either)
✅ Оффлайн-first подход
✅ Material 3 дизайн
✅ Комментарии в коде
✅ Документация (README, SETUP)
