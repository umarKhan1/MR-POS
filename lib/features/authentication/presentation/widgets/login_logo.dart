import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';

class LoginLogo extends StatelessWidget {
  final double size;

  const LoginLogo({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
