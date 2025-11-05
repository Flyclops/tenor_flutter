import 'package:tenor_flutter/src/utilities/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Debouncer >', () {
    test('Make sure the callback is called after the right amount of time',
        () async {
      final debouncer = TenorDebouncer(
        delay: const Duration(
          seconds: 1,
        ),
      );

      bool callbackCalled = false;

      debouncer.call(() {
        callbackCalled = true;
      });

      expect(callbackCalled, false);

      await Future.delayed(const Duration(seconds: 1), () {});

      expect(callbackCalled, true);
    });
  });

  test('Make sure that dispose ends the timer and does not run the callback',
      () async {
    final debouncer = TenorDebouncer(
      delay: const Duration(
        seconds: 1,
      ),
    );

    bool callbackCalled = false;

    debouncer.call(() {
      callbackCalled = true;
    });

    expect(callbackCalled, false);

    debouncer.dispose();

    await Future.delayed(const Duration(seconds: 1), () {});

    expect(callbackCalled, false);
  });
}
