import 'package:flutter/material.dart';
import 'package:mrpos/features/authentication/presentation/widgets/login_background.dart';
import 'package:mrpos/features/authentication/presentation/widgets/login_logo.dart';
import 'package:mrpos/features/authentication/presentation/widgets/login_header.dart';
import 'package:mrpos/features/authentication/presentation/widgets/login_form.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop || isTablet) _buildLeftPanel(size, isDesktop),
          Expanded(child: _buildRightPanel(context, isDesktop, isTablet)),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(Size size, bool isDesktop) {
    return SizedBox(
      width: isDesktop ? size.width * 0.5 : size.width * 0.4,
      child: LoginBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: LoginLogo(size: isDesktop ? 400 : 300),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, bool isDesktop, bool isTablet) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : (isTablet ? 40 : 24),
            vertical: 40,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [const LoginHeader(), 40.h, const LoginForm()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
