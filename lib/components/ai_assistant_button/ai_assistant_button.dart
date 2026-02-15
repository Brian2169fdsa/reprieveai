import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AiAssistantButton extends StatefulWidget {
  const AiAssistantButton({super.key});

  @override
  State<AiAssistantButton> createState() => _AiAssistantButtonState();
}

class _AiAssistantButtonState extends State<AiAssistantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToAssistant() {
    // Navigate to AI assistant tab (index 3 in the TabBar)
    // This will be handled by changing the tab in the parent HomeWidget
    // For now, we'll use a simple navigation or callback
    // The user can tap on the AI tab at the bottom to access the assistant
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tap the AI tab below to access your assistant'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final size = isTablet ? 48.0 : 42.0;

    return Tooltip(
      message: 'AI Assistant',
      child: GestureDetector(
        onTap: () {
          _animationController.forward().then((_) {
            _animationController.reverse();
            _navigateToAssistant();
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.psychology_rounded,
              size: size * 0.55,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
