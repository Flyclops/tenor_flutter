import 'package:flutter_test/flutter_test.dart';
import 'package:tenor_flutter/src/tools/url_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('addQueryParameters >', () {
    test('Adds query parameters to a URL with no existing parameters', () {
      const url = 'https://example.com/path';
      final result = addQueryParameters(
        url: url,
        parameters: {'key1': 'value1', 'key2': 'value2'},
      );

      expect(result, 'https://example.com/path?key1=value1&key2=value2');
    });

    test('Merges new parameters with existing parameters', () {
      const url = 'https://example.com/path?existing=param';
      final result = addQueryParameters(
        url: url,
        parameters: {'new': 'value'},
      );

      expect(result, 'https://example.com/path?existing=param&new=value');
    });

    test('Overwrites existing parameter with same key', () {
      const url = 'https://example.com/path?key=oldValue';
      final result = addQueryParameters(
        url: url,
        parameters: {'key': 'newValue'},
      );

      expect(result, 'https://example.com/path?key=newValue');
    });

    test('Handles empty parameters map', () {
      const url = 'https://example.com/path?existing=param';
      final result = addQueryParameters(
        url: url,
        parameters: {},
      );

      expect(result, 'https://example.com/path?existing=param');
    });

    test('Preserves URL structure (scheme, host, path)', () {
      const url = 'https://tenor.com/view/item/12345';
      final result = addQueryParameters(
        url: url,
        parameters: {'selectedTab': 'gif'},
      );

      expect(
        result,
        'https://tenor.com/view/item/12345?selectedTab=gif',
      );
    });

    test('Handles URLs with fragments', () {
      const url = 'https://example.com/path#fragment';
      final result = addQueryParameters(
        url: url,
        parameters: {'key': 'value'},
      );

      expect(result, 'https://example.com/path?key=value#fragment');
    });

    test('Handles multiple existing parameters and adds multiple new ones', () {
      const url = 'https://example.com/path?param1=a&param2=b';
      final result = addQueryParameters(
        url: url,
        parameters: {'param3': 'c', 'param4': 'd'},
      );

      expect(
        result,
        'https://example.com/path?param1=a&param2=b&param3=c&param4=d',
      );
    });

    test('Handles special characters in parameter values', () {
      const url = 'https://example.com/path';
      final result = addQueryParameters(
        url: url,
        parameters: {'key': 'value with spaces'},
      );

      expect(result, 'https://example.com/path?key=value+with+spaces');
    });

    test('Handles URL with port number', () {
      const url = 'https://example.com:8080/path';
      final result = addQueryParameters(
        url: url,
        parameters: {'key': 'value'},
      );

      expect(result, 'https://example.com:8080/path?key=value');
    });
  });
}
