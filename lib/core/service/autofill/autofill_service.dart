import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutofillService {
  // Singleton pattern
  static final AutofillService _instance = AutofillService._internal();
  factory AutofillService() => _instance;
  AutofillService._internal();

  Future<void> setupAutofill(
      TextEditingController controller, List<String> autofillHints) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await ServicesBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'flutter/autofill',
        const StandardMethodCodec().encodeMethodCall(
          MethodCall(
            'TextInput.setAutofillHints',
            autofillHints,
          ),
        ),
        null,
      );
    }
  }
}
