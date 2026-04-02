import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbisense/features/account/presentation/providers/change_password_provider.dart';
import 'package:verbisense/features/account/presentation/providers/provider_info_provider.dart';
import 'package:verbisense/features/account/presentation/providers/update_user_name_provider.dart';

final appStateResetProvider = Provider<void Function(Ref)>((ref) {
  return (ref) {
    ref.invalidate(changePasswordProvider);
    ref.invalidate(providerInfoProvider);
    ref.invalidate(updateUserNameProvider);
  };
});
