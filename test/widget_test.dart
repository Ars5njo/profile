import 'package:flutter_test/flutter_test.dart';
import 'package:profile/app/profile_app.dart';

void main() {
  testWidgets('renders profile landing content', (tester) async {
    await tester.pumpWidget(const ProfileApp());

    expect(find.text('Arsen Latipov'), findsWidgets);
    expect(find.text('Обо мне'), findsOneWidget);
    expect(find.text('Codeforces'), findsWidgets);
    expect(find.text('tiktok-book'), findsOneWidget);
    expect(find.text('tatar-shower-app-flutter-go'), findsOneWidget);
  });
}
