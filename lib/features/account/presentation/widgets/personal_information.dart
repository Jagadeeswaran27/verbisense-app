import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/utils/show_snackbar.dart';
import 'package:verbisense/features/account/presentation/providers/update_user_name_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  final User? user;
  final bool isGoogleUser;
  const PersonalInformation({
    super.key,
    required this.isGoogleUser,
    this.user,
  });

  @override
  ConsumerState<PersonalInformation> createState() =>
      _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  bool _isNameEditable = false;
  late TextEditingController _userNameController;

  void _toggleNameEdit() {
    setState(() {
      _isNameEditable = !_isNameEditable;
    });
  }

  void _handleSaveName() {
    final text = _userNameController.text;

    if (text.isEmpty) {
      showSnackBar(context, CommonStrings.nameCannotBeEmpty, error: true);
      return;
    }

    ref.read(updateUserNameProvider.notifier).updateName(text);

    _toggleNameEdit();
  }

  Widget _getSuffixIcon() {
    final updateUserNameState = ref.watch(updateUserNameProvider);

    if (updateUserNameState is UpdateUserNameLoading) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      );
    }

    if (_isNameEditable) {
      return GestureDetector(
        onTap: _handleSaveName,
        child: const Icon(Icons.check),
      );
    } else {
      return GestureDetector(
        onTap: _toggleNameEdit,
        child: const Icon(Icons.edit),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UpdateUserNameState>(
      updateUserNameProvider,
      (previous, next) async {
        if (next is UpdateUserNameSuccess) {
          showSnackBar(context, 'Name updated successfully');
        } else if (next is UpdateUserNameError) {
          showSnackBar(context, 'Failed to update name');
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline),
            const SizedBox(width: 8),
            Text(
              CommonStrings.personalInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(CommonStrings.name),
        const SizedBox(height: 8),
        FormInput(
          controller: _userNameController,
          readOnly: !_isNameEditable,
          suffixIcon: _getSuffixIcon(),
        ),
        const SizedBox(height: 16),
        const Text(CommonStrings.emailAddress),
        const SizedBox(height: 8),
        FormInput(
          readOnly: true,
          initialValue: widget.user!.email,
        ),
      ],
    );
  }
}
