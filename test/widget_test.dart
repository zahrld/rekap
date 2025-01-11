// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_kominfo/main.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verifikasi bahwa aplikasi menampilkan 'Survei Lokasi'
    expect(find.text('Survei Lokasi'), findsOneWidget);

    // Verifikasi bahwa aplikasi menampilkan 'Halaman Survei'
    expect(find.text('Halaman Survei'), findsOneWidget);
  });
}
