import 'package:flutter/material.dart';

/// A beautiful card widget for selecting QR code type
/// 
/// Features:
/// - Material 3 design with elevation and ripple effect
/// - Icon with gradient background
/// - Title and descriptive subtitle
/// - Tap animation for better UX
class QRTypeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color secondaryColor;

  const QRTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<QRTypeCard> createState() => _QRTypeCardState();
}

class _QRTypeCardState extends State<QRTypeCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scale = _isPressed ? 0.98 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        child: Card(
          elevation: _isPressed ? 1 : 3,
          shadowColor: widget.primaryColor.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.primaryColor.withValues(alpha: 0.05),
                  widget.secondaryColor.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with gradient background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.primaryColor,
                        widget.secondaryColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Title only - no subtitle
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
