import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/contact_link.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/domain/entities/portfolio_project.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';

class ProfileRepository {
  const ProfileRepository();

  DeveloperProfile loadProfile() {
    return const DeveloperProfile(
      fullName: 'Arsen Latipov',
      age: 'уточняется',
      role: 'Flutter / Frontend Developer',
      location: 'Innopolis, Russia',
      avatarAssetPath: 'assets/images/arsen_latipov.jpg',
      summary:
          'Делаю Flutter-интерфейсы, web/mobile-приложения и люблю проекты, '
          'где UI связан с реальной архитектурой: REST, WebSocket, локальное '
          'хранение, CI и понятная feature-first структура.',
      about: [
        'Учусь и работаю вокруг Flutter, Dart и прикладной разработки. '
            'В командных проектах чаще всего беру frontend: экраны, состояние, '
            'интеграции с API и аккуратную сборку пользовательских сценариев.',
        'Мне близки проекты с инженерной начинкой: realtime chat, сервисы '
            'с backend-инфраструктурой, UI-kit и приложения, которые нужно '
            'поддерживать не только в демо, но и после первого релиза.',
        'Публичные данные на этой странице собраны из GitHub, Codeforces и '
            'LeetCode API. Поля возраста и почты оставлены явными, потому что '
            'они не опубликованы в проверяемых источниках.',
      ],
      heroMetrics: [
        ProfileMetric(label: 'GitHub repos', value: '6', caption: 'public'),
        ProfileMetric(label: 'Codeforces', value: '744', caption: 'rating'),
        ProfileMetric(label: 'LeetCode', value: '60', caption: 'solved'),
        ProfileMetric(label: 'City', value: 'Innopolis', caption: 'CF profile'),
      ],
      contacts: [
        ContactLink(
          label: 'Telegram',
          value: '@Ars5njo',
          icon: 'telegram',
          url: 'https://t.me/Ars5njo',
          note: 'указан по публичному handle',
        ),
        ContactLink(
          label: 'Email',
          value: 'добавить почту',
          icon: 'mail',
          note: 'не найдено в публичных профилях',
        ),
        ContactLink(
          label: 'GitHub',
          value: 'github.com/Ars5njo',
          icon: 'github',
          url: 'https://github.com/Ars5njo',
        ),
      ],
      codingProfiles: [
        CodingProfile(
          platform: 'GitHub',
          handle: 'Ars5njo',
          url: 'https://github.com/Ars5njo',
          headline: 'Arsen Latipov, public profile',
          accent: ProfileAccent.teal,
          metrics: [
            ProfileMetric(label: 'Public repos', value: '6'),
            ProfileMetric(label: 'Followers', value: '4'),
            ProfileMetric(label: 'Following', value: '5'),
            ProfileMetric(label: 'Updated', value: '10 May 2026'),
          ],
        ),
        CodingProfile(
          platform: 'Codeforces',
          handle: 'Ars5nj0',
          url: 'https://codeforces.com/profile/Ars5nj0',
          headline: 'newbie, Innopolis University',
          accent: ProfileAccent.coral,
          metrics: [
            ProfileMetric(label: 'Rating', value: '744'),
            ProfileMetric(label: 'Max rating', value: '873'),
            ProfileMetric(label: 'Rank', value: 'newbie'),
            ProfileMetric(label: 'Contribution', value: '0'),
          ],
        ),
        CodingProfile(
          platform: 'LeetCode',
          handle: 'Ars5njo',
          url: 'https://leetcode.com/u/Ars5njo/',
          headline: '60 accepted problems',
          accent: ProfileAccent.amber,
          metrics: [
            ProfileMetric(label: 'Solved', value: '60'),
            ProfileMetric(label: 'Easy', value: '38'),
            ProfileMetric(label: 'Medium', value: '22'),
            ProfileMetric(label: 'Ranking', value: '2,200,075'),
          ],
        ),
      ],
      projects: [
        PortfolioProject(
          name: 'tiktok-book',
          logoText: 'TB',
          url: 'https://github.com/Ars5njo/tiktok-book',
          description:
              'Offline reader for PDF/TXT books with RSVP mode, bionic text, '
              'local library and progress saving.',
          role:
              'Flutter feature work: reading flow, UI states, local data and '
              'project structure.',
          accent: ProfileAccent.teal,
          stack: [
            'Flutter',
            'Dart',
            'BLoC',
            'Drift',
            'SQLite',
            'file_picker',
            'Syncfusion PDF',
            'SharedPreferences',
            'Widgetbook',
            'Freezed',
          ],
          metrics: [
            ProfileMetric(label: 'Repo commits', value: '111'),
            ProfileMetric(label: 'My commits', value: '10'),
            ProfileMetric(label: 'Topics', value: 'RSVP / bionic reading'),
          ],
          sourceNote: 'GitHub README and contributors API',
        ),
        PortfolioProject(
          name: 'load-balancer',
          logoText: 'LB',
          description:
              'Проект про распределение входящего трафика между backend-узлами: '
              'алгоритмы балансировки, health checks и устойчивость сервиса.',
          role:
              'Публичный репозиторий не найден; стек и вклад требуют ручного '
              'уточнения.',
          accent: ProfileAccent.blue,
          stack: [
            'HTTP',
            'Routing',
            'Health checks',
            'Concurrency',
            'Docker',
            'Observability',
          ],
          metrics: [
            ProfileMetric(label: 'Public repo', value: 'not found'),
            ProfileMetric(label: 'Stats', value: 'manual'),
          ],
          sourceNote:
              'GitHub search did not find Ars5njo/load-balancer or Messenger-DNP/load-balancer',
        ),
        PortfolioProject(
          name: 'VRATA',
          logoText: 'VR',
          url: 'https://github.com/Messenger-DNP/VRATA',
          description:
              'Distributed room-based messenger with isolated Kafka topics, '
              'persistent history and WebSocket/STOMP realtime delivery.',
          role:
              'Frontend role: Flutter Web client, feature-first layers, '
              'room/chat UI and API integration.',
          accent: ProfileAccent.violet,
          stack: [
            'Flutter Web',
            'Dart',
            'Riverpod',
            'REST API',
            'WebSocket/STOMP',
            'Spring Boot',
            'Kafka',
            'MongoDB',
            'Docker Compose',
          ],
          metrics: [
            ProfileMetric(label: 'Repo commits', value: '33'),
            ProfileMetric(label: 'My commits', value: '7'),
            ProfileMetric(label: 'Role', value: 'frontend'),
          ],
          sourceNote: 'GitHub README and contributors API',
        ),
        PortfolioProject(
          name: 'md_ui_kit',
          logoText: 'MD',
          url: 'https://github.com/Miracle-Development/md_ui_kit',
          description:
              'Miracle Development UI kit: reusable Flutter widgets, themed '
              'components, story scenarios and golden-testing workflow.',
          role:
              'Core contributor: components, stories, exports, theme support '
              'and package maintenance.',
          accent: ProfileAccent.coral,
          stack: [
            'Flutter',
            'Dart',
            'Design system',
            'flex_color_scheme',
            'Stories',
            'Knobs',
            'Golden tests',
            'iOS build',
          ],
          metrics: [
            ProfileMetric(label: 'Repo commits', value: '279'),
            ProfileMetric(label: 'My commits', value: '152'),
            ProfileMetric(label: 'Stars', value: '2'),
          ],
          sourceNote: 'GitHub README and contributors API',
        ),
        PortfolioProject(
          name: 'tatar-shower-app-flutter-go',
          logoText: 'TS',
          url: 'https://github.com/Ars5njo/tatar-shower-app-flutter-go',
          description:
              'Cold shower habit app with Flutter frontend, Go backend, '
              'PostgreSQL schema and DevOps automation.',
          role:
              'Frontend Developer: auth flow, schedule editor, timer, '
              'dashboard states and adaptive Flutter screens.',
          accent: ProfileAccent.amber,
          stack: [
            'Flutter',
            'Dart',
            'JWT auth',
            'Go',
            'Gorilla Mux',
            'PostgreSQL',
            'Docker',
            'GitHub Actions',
          ],
          metrics: [
            ProfileMetric(label: 'Repo commits', value: '73'),
            ProfileMetric(label: 'My commits', value: '11'),
            ProfileMetric(label: 'Role', value: 'frontend'),
          ],
          sourceNote: 'GitHub README and contributors API',
        ),
      ],
      updatedAtLabel: 'Public snapshot: 10 May 2026',
    );
  }
}
