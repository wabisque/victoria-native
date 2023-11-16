import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;

  const PasswordFieldWidget({
    super.key,
    this.controller,
    this.decoration
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    decoration: (widget.decoration ?? const InputDecoration()).copyWith(
      suffixIcon: GestureDetector(
        onTap: () => setState(
          () {
            _isVisible = !_isVisible;
          }
        ),
        child: Icon(_isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
      )
    ),
    key: widget.key,
    obscureText: !_isVisible,
    obscuringCharacter: '●'
  );
}
