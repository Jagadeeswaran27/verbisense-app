import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

class DeepLinkHandler {
  static Future<void> initUniLinks() async {
    try {
      // Handle initial link
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        handleLink(initialUri);
      }

      // Handle incoming links while app is running
      uriLinkStream.listen(
        (Uri? uri) {
          if (uri != null) {
            handleLink(uri);
          }
        },
        onError: (err) {
          print('Error handling deep link: $err');
        },
      );
    } on PlatformException {
      print('Failed to get initial deep link');
    }
  }

  static void handleLink(Uri uri) {
    if (uri.host == 'verbisense.vercel.app') {
      // Handle the deep link
      print('Deep link handled: ${uri.toString()}');
      // You can trigger autofill here
    }
  }
}
