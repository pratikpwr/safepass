import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';

class LabelledTextFieldItem extends StatelessWidget {
  const LabelledTextFieldItem({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.focusNode,
    this.validator,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.textAlignment = TextAlign.start,
    this.suffix,
    this.enabled,
  });

  final String? title;
  final String? hintText;
  final TextEditingController? controller;

  final int maxLines;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;

  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted, onChanged;

  final TextAlign textAlignment;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      return _buildTextField(context);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: context.theme.textTheme.titleMedium,
          ),
          padding4,
          _buildTextField(context),
        ],
      );
    }
  }

  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: context.theme.textTheme.bodyLarge,
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffix,
      ),
      maxLines: maxLines,
      validator: validator,
      textAlignVertical: TextAlignVertical.center,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textAlign: textAlignment,
    );
  }
}
