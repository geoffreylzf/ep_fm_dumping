import 'package:flutter/material.dart';

class FormItemTitle extends StatelessWidget {
  final String title;

  const FormItemTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
