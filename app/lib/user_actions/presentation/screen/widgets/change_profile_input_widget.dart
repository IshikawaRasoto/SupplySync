import 'package:flutter/material.dart';

class ChangeProfileInputWidget extends StatefulWidget {
  final bool isObscureText;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String)? validator;
  const ChangeProfileInputWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscureText = false,
    this.validator,
  });
  @override
  ChangeProfileInputWidgetState createState() =>
      ChangeProfileInputWidgetState();
}

class ChangeProfileInputWidgetState extends State<ChangeProfileInputWidget> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.hintText,
        suffixIcon: widget.isObscureText
            ? null
            : IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return widget.validator?.call(value);
      },
    );
  }
}
