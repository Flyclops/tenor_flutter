import 'dart:async';

class TenorDebouncer {
  final Duration _delay;
  Timer? _timer;

  TenorDebouncer({
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
