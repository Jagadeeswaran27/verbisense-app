import 'package:flutter/widgets.dart';

import 'package:go_router/go_router.dart';

void pushToScreen(BuildContext context, String screenPath) {
  context.push(screenPath);
}

void pushToScreenNamed(BuildContext context, String screenName) {
  context.pushNamed(screenName);
}

void goToScreen(BuildContext context, String screenPath) {
  context.go(screenPath);
}

void goToScreenNamed(BuildContext context, String screenName) {
  context.goNamed(screenName);
}
