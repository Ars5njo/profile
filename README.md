# Arsen Latipov Profile

Flutter Web сайт-визитка с dark glass дизайном, фото, контактами, публичными
coding-профилями и карточками проектов. Метрики GitHub, Codeforces, LeetCode и
коммиты репозиториев загружаются из сети во время работы приложения.

## Localization

Поддерживаются русский и английский языки через Flutter `l10n`.

## Run

```sh
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 55123
```

## Check

```sh
dart format lib test
flutter analyze
flutter test
```
