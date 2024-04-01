import 'package:flutter/material.dart';

class IosButton extends StatelessWidget {
  final void Function()? onPressed;
  const IosButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed, icon: const Icon(Icons.arrow_back_ios));
  }
}
