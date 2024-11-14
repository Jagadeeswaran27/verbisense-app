import 'package:flutter/material.dart';
import 'package:verbisense/themes/colors.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      {super.key,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.hintText,
      this.onSaved,
      this.keyboardType,
      this.onChanged,
      this.obscureText = false,
      this.autofillHints});

  final String? label;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final Widget? suffixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeColors.gray200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.gray200,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.black100,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: ThemeColors.gray200,
        suffixIcon: suffixIcon,
        suffixIconColor: ThemeColors.black200,
        label: label != null
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(label!),
              )
            : null,
        labelStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: ThemeColors.black200,
            ),
        hintText: hintText,
      ),
      validator: validator,
      onSaved: onSaved,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
