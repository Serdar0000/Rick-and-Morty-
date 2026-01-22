# Инструкция по запуску приложения Rick and Morty

## Предварительные требования

- Flutter SDK (версия 3.9.2 или выше)
- Dart SDK
- Android Studio / Xcode (для запуска на эмуляторах)
- Git

## Шаги для запуска

### 1. Установка зависимостей

```bash
flutter pub get
```

### 2. Генерация Hive адаптеров

Приложение использует Hive для локального хранения данных. Необходимо сгенерировать адаптеры:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Запуск приложения

#### На эмуляторе/устройстве:
```bash
flutter run
```

#### На конкретном устройстве:
```bash
flutter devices  # Посмотреть список устройств
flutter run -d <device-id>
```

#### В режиме релиза:
```bash
flutter run --release
```

### 4. Сборка APK (Android)

```bash
flutter build apk --release
```

APK будет находиться в: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Сборка для iOS

```bash
flutter build ios --release
```

## Проверка работоспособности

После запуска приложения вы должны увидеть:

1. **Экран "Characters"**:
   - Список персонажей из Rick and Morty
   - Возможность прокрутки с автоматической подгрузкой
   - Звездочки для добавления в избранное

2. **Экран "Favorites"**:
   - Пустой экран с подсказкой (если нет избранных)
   - Список избранных персонажей
   - Кнопка сортировки в AppBar

## Тестирование оффлайн-режима

1. Запустите приложение с интернетом
2. Дождитесь загрузки персонажей
3. Отключите интернет на устройстве
4. Закройте и снова откройте приложение
5. Персонажи должны загрузиться из кеша

## Структура проекта

```
lib/
├── core/                      # Общие компоненты
│   ├── constants/            # Константы приложения
│   ├── di/                   # Dependency Injection
│   ├── error/                # Обработка ошибок
│   ├── network/              # Проверка сети
│   └── widgets/              # Общие виджеты
│
└── features/
    └── characters/           # Фича персонажей
        ├── data/            # Слой данных (API, DB, Repository)
        ├── domain/          # Бизнес-логика (Entities, Repository interface)
        └── presentation/    # UI (BLoC, Pages, Widgets)
```

## Используемые пакеты

- `flutter_bloc` - State management
- `dio` - HTTP клиент
- `hive` & `hive_flutter` - Локальная база данных
- `cached_network_image` - Кеширование изображений
- `dartz` - Functional programming (Either)
- `equatable` - Упрощение сравнения объектов

## Возможные проблемы

### Ошибка при генерации адаптеров
Если возникает ошибка при запуске `build_runner`, попробуйте:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ошибка подключения к API
- Проверьте интернет-соединение
- API: https://rickandmortyapi.com/api/character
- Приложение автоматически переключится на кеш при отсутствии сети

### Проблемы с Hive
Если возникают проблемы с Hive, очистите данные приложения:
```bash
flutter clean
```

## Дополнительные команды

```bash
# Анализ кода
flutter analyze

# Форматирование кода
flutter format lib/

# Запуск тестов
flutter test

# Проверка устаревших пакетов
flutter pub outdated
```

## API Documentation

Rick and Morty API: https://rickandmortyapi.com/documentation

Эндпоинты:
- GET `/character` - Список всех персонажей
- GET `/character?page=2` - Пагинация
- GET `/character/:id` - Конкретный персонаж

## Поддержка

При возникновении проблем:
1. Проверьте версию Flutter: `flutter --version`
2. Обновите Flutter: `flutter upgrade`
3. Очистите проект: `flutter clean`
4. Переустановите зависимости: `flutter pub get`
