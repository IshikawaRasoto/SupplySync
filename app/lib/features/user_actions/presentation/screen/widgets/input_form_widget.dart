import 'package:flutter/material.dart';

class InputFormField extends StatefulWidget {
  final bool isObscureText;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String)? validator;
  const InputFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscureText = false,
    this.validator,
  });
  @override
  InputFormFieldState createState() => InputFormFieldState();
}

class InputFormFieldState extends State<InputFormField> {
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
      cursorColor: Colors.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.hintText,
        suffixIcon: widget.isObscureText
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
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
