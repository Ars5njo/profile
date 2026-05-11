// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Арсен Латипов';

  @override
  String get navHome => 'Главная';

  @override
  String get navProfiles => 'Профили';

  @override
  String get navProjects => 'Проекты';

  @override
  String get navContacts => 'Контакты';

  @override
  String get contactButton => 'Связаться';

  @override
  String get languageRu => 'RU';

  @override
  String get languageEn => 'EN';

  @override
  String get loadingProfile => 'Загружаю live-метрики профиля';

  @override
  String get loadingHint =>
      'Запрашиваю GitHub, Codeforces, LeetCode и коммиты репозиториев.';

  @override
  String get retry => 'Повторить';

  @override
  String get loadErrorTitle => 'Не получилось загрузить профиль';

  @override
  String get loadErrorBody =>
      'Страница готова, но один из сетевых источников упал до сборки профиля.';

  @override
  String get fullName => 'Arsen Latipov';

  @override
  String get role => 'Flutter Developer';

  @override
  String get location => 'Innopolis, Russia';

  @override
  String get ageValue => '19';

  @override
  String ageChip(Object age) {
    return 'Возраст: $age';
  }

  @override
  String get summary =>
      'Делаю Flutter-интерфейсы, web/mobile-приложения и люблю проекты, где UI связан с реальной архитектурой: REST, WebSocket, локальное хранение, CI и понятная feature-first структура.';

  @override
  String publicSnapshot(Object date) {
    return 'Live-срез: $date';
  }

  @override
  String get aboutTitle => 'Обо мне';

  @override
  String get aboutSubtitle =>
      'Короткий профиль без лишней витрины: чем занимаюсь, какие задачи беру и как обычно встраиваюсь в проект.';

  @override
  String get aboutParagraph1 =>
      'Учусь и работаю вокруг Flutter, Dart и прикладной разработки. В командных проектах чаще всего беру frontend: экраны, состояние, интеграции с API и аккуратную сборку пользовательских сценариев.';

  @override
  String get aboutParagraph2 =>
      'Мне близки проекты с инженерной начинкой: realtime chat, сервисы с backend-инфраструктурой, UI-kit и приложения, которые нужно поддерживать не только в демо, но и после первого релиза.';

  @override
  String get aboutParagraph3 =>
      'Все численные метрики на странице берутся из публичных сетевых API во время запуска. Если источник недоступен, интерфейс показывает это состояние вместо устаревшего хардкода.';

  @override
  String get codingProfilesTitle => 'Coding profiles';

  @override
  String get codingProfilesSubtitle =>
      'Live-метрики из GitHub, Codeforces и LeetCode. Каждая карточка ведет на исходный профиль.';

  @override
  String get projectsTitle => 'Проекты';

  @override
  String get projectsSubtitle =>
      'Карточки сфокусированы на роли, личном стеке, статистике репозитория и коммитах из GitHub API.';

  @override
  String get contactsTitle => 'Контакты';

  @override
  String get contactsSubtitle =>
      'Быстрые ссылки для связи и профилей с исходным кодом.';

  @override
  String get footer =>
      'Собрано на Flutter Web, l10n, live API и feature-first архитектуре.';

  @override
  String get telegramNote => 'Публичный handle';

  @override
  String get emailValue => 'добавить почту';

  @override
  String get emailNote => 'Не опубликовано в публичных профилях';

  @override
  String get githubContactValue => 'github.com/Ars5njo';

  @override
  String get githubHeadline => 'Arsen Latipov, публичный профиль';

  @override
  String codeforcesHeadline(Object rank, Object organization) {
    return '$rank, $organization';
  }

  @override
  String leetcodeHeadline(Object count) {
    return '$count принятых задач';
  }

  @override
  String openPlatform(Object platform) {
    return 'Открыть $platform';
  }

  @override
  String get repository => 'Репозиторий';

  @override
  String get notAvailable => 'н/д';

  @override
  String get notFound => 'не найден';

  @override
  String get manual => 'вручную';

  @override
  String get publicRepos => 'Публичные repo';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get updated => 'Обновлено';

  @override
  String get rating => 'Рейтинг';

  @override
  String get maxRating => 'Макс. рейтинг';

  @override
  String get rank => 'Rank';

  @override
  String get contribution => 'Contribution';

  @override
  String get solved => 'Решено';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get ranking => 'Ranking';

  @override
  String get githubRepos => 'GitHub repos';

  @override
  String get public => 'public';

  @override
  String get codeforces => 'Codeforces';

  @override
  String get leetcode => 'LeetCode';

  @override
  String get city => 'Город';

  @override
  String get cfProfile => 'CF profile';

  @override
  String get repoCommits => 'Коммиты repo';

  @override
  String get myCommits => 'Мои коммиты';

  @override
  String get languages => 'Языки';

  @override
  String get topics => 'Topics';

  @override
  String get stars => 'Stars';

  @override
  String get publicRepo => 'Public repo';

  @override
  String get stats => 'Stats';

  @override
  String get roleMetric => 'Роль';

  @override
  String get frontend => 'frontend';

  @override
  String get apiSource => 'GitHub API';

  @override
  String get githubSearchSource => 'GitHub Search API';

  @override
  String get repoNotFoundNote =>
      'GitHub Search API не нашел публичный load-balancer репозиторий для этого профиля.';

  @override
  String get tiktokDescription =>
      'Offline reader для PDF/TXT книг с RSVP-режимом, bionic text, локальной библиотекой и сохранением прогресса.';

  @override
  String get tiktokRole =>
      'Flutter feature work: reading flow, UI states, local data и структура проекта.';

  @override
  String get loadBalancerDescription =>
      'Проект про распределение входящего трафика между backend-узлами: алгоритмы балансировки, health checks и устойчивость сервиса.';

  @override
  String get loadBalancerRole =>
      'Публичный репозиторий не найден; стек и вклад требуют ручного уточнения.';

  @override
  String get vrataDescription =>
      'Distributed room-based messenger с изолированными Kafka topics, persistent history и WebSocket/STOMP realtime delivery.';

  @override
  String get vrataRole =>
      'Frontend role: Flutter Web client, feature-first layers, room/chat UI и API integration.';

  @override
  String get uiKitDescription =>
      'Miracle Development UI kit: reusable Flutter widgets, themed components, story scenarios и golden-testing workflow.';

  @override
  String get uiKitRole =>
      'Core contributor: components, stories, exports, theme support и package maintenance.';

  @override
  String get tatarDescription =>
      'Cold shower habit app с Flutter frontend, Go backend, PostgreSQL schema и DevOps automation.';

  @override
  String get tatarRole =>
      'Frontend Developer: auth flow, schedule editor, timer, dashboard states и adaptive Flutter screens.';
}
