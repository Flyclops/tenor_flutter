import 'dart:async';

class Debouncer {
  final Duration _delay;
  Timer? _timer;

  Debouncer({
    Duration delay = const Duration(milliseconds: 300),
  }) : _delay = delay;

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(_delay, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
