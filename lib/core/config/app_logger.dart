import 'package:flutter/foundation.dart';

import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    filter: kDebugMode
        ? DevelopmentFilter() // Log everything in debug mode
        : ProductionFilter(), // Only log warnings and errors in production
    printer: kDebugMode
        ? PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 2,
            lineLength: 120,
            colors: false, // Disable colors to prevent ANSI escape codes
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.dateAndTime,
          )
        : SimplePrinter(),
  );

  static void d(String message, {dynamic data}) => {
    _logger.d(message, error: data), // Error is an additional data object
  }; // Debug log

  static void i(String message, {dynamic data}) => {
    _logger.i(message, error: data), // Error is an additional data object
  }; // Info log

  static void w(String message, {dynamic data}) => {
    _logger.w(message, error: data), // Error is an additional data object
  };

  static void e(String message, {dynamic data, StackTrace? stackTrace}) => {
    _logger.e(
      message,
      error: data,
      stackTrace: stackTrace,
    ), // Error with stack trace and additional data object
  }; // Error log

  static void crashlytics(String message, {dynamic data}) => {
    _logger.e(
      message,
      error: data,
    ), // Error with stack trace and additional data object
    // You can integrate with Firebase Crashlytics here -> TODO:(Discuss with balaji)
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
  };
}
