import 'package:flutter/foundation.dart';

/// Prints to the console in debug/profile only (not release).
void appLog(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  if (kReleaseMode) return;
  debugPrint('[FinTrack] $message');
  if (error != null) {
    debugPrint('[FinTrack] error: $error');
  }
  if (stackTrace != null) {
    debugPrint('[FinTrack] $stackTrace');
  }
}