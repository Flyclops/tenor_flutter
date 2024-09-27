import 'package:tenor_dart/tenor_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Tenor >', () {
    const tenorClient = Tenor(apiKey: '12345');

    test('Make sure it is the right type', () {
      expect(tenorClient, isA<Tenor>());
    });
  });
}
