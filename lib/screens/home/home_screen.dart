import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_router.dart';
import '../../core/animations/widget_animations.dart';
import '../../core/animations/animation_constants.dart';
import '../../core/utils/responsive.dart';
import '../../providers/theme_provider.dart';
import 'widgets/qr_type_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/brand_constants.dart';


/// Home screen - Main landing page for the QR Code Generator
///
/// This is the entry point of the app where users can choose between
/// 7 different QR code types in a beautiful responsive grid.
/// 
/// Features:
/// - Beautiful app branding with logo
/// - 7 interactive cards for different QR types
/// - Dark mode toggle with rotation animation
/// - Smooth entrance animations (logo bounce, staggered cards)
/// - Fully responsive grid: 1 column (phone), 2 columns (tablet), 3 columns (desktop)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _themeToggleController;
  
  @override
  void initState() {
    super.initState();
    _themeToggleController = AnimationController(
      duration: AnimationDurations.normal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _themeToggleController.dispose();
    super.dispose();
  }

  void _toggleTheme(ThemeProvider provider) {
    provider.toggleTheme();
    if (provider.isDarkMode) {
      _themeToggleController.forward();
    } else {
      _themeToggleController.reverse();
    }
  }

  Future<void> _launchWebsite() async {
    final uri = Uri.parse(BrandConstants.websiteUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final responsive = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: CustomScrollView(
            slivers: [
              // App Bar with theme toggle
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: responsive.spacing),
                    child: IconButton(
                      icon: RotationTransition(
                        turns: Tween<double>(begin: 0.0, end: 0.5)
                            .animate(_themeToggleController),
                        child: Icon(
                          themeProvider.isDarkMode 
                            ? Icons.light_mode_rounded 
                            : Icons.dark_mode_rounded,
                          size: responsive.iconSize,
                        ),
                      ),
                      tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                      onPressed: () => _toggleTheme(themeProvider),
                    ),
                  ),
                ],
              ),

              // Main content
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: responsive.horizontalPadding,
                    child: Column(
                      children: [
                        SizedBox(height: responsive.spacing * 2.5),

                        // App Logo/Branding Section with bounce animation
                        _buildBranding(context, colorScheme, responsive),

                        SizedBox(height: responsive.cardSpacing * 1.5),

                        // QR Type Grid with responsive layout
                        _buildQRTypeGrid(context, colorScheme, responsive),

                        SizedBox(height: responsive.cardSpacing),

                        // Footer hint with fade-in
                        FadeSlideIn(
                          delay: AnimationDurations.staggerDelay * 8,
                          child: _buildFooter(context, colorScheme, responsive),
                        ),


                        // Digital Disconnections Footer
                        FadeSlideIn(
                          delay: AnimationDurations.staggerDelay * 9,
                          child: _buildCompanyFooter(context, colorScheme, responsive),
                        ),
                        SizedBox(height: responsive.spacing * 3),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app branding section with logo bounce animation and responsive sizing
  Widget _buildBranding(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    final logoSize = responsive.value(
      phone: 180.0,
      tablet: 220.0,
      desktop: 260.0,
    );
    
    return Column(
      children: [
        // QR Code Logo with bounce entrance
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: AnimationDurations.slow,
          curve: AnimationCurves.bounce,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(responsive.spacing * 1.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: BrandConstants.brandPrimary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Image.asset(
              BrandConstants.logoPath,
              width: logoSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: responsive.spacing * 2.5),
        
        // App Title with fade-in after logo - responsive sizing
        FadeSlideIn(
          delay: const Duration(milliseconds: 300),
          child: Text(
            'QR Code Generator',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontSize: responsive.value(
                phone: 28.0,
                tablet: 32.0,
                desktop: 36.0,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: responsive.spacing),
        
        // Tagline with fade-in - responsive sizing
        FadeSlideIn(
          delay: const Duration(milliseconds: 400),
          child: Text(
            'Create custom QR codes instantly',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: responsive.value(
                phone: 16.0,
                tablet: 18.0,
                desktop: 20.0,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Build QR type grid with responsive columns
  Widget _buildQRTypeGrid(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    final qrTypes = _getQRTypes(context, colorScheme);
    
    return ResponsiveGrid(
      spacing: responsive.cardSpacing,
      phoneColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      children: List.generate(
        qrTypes.length,
        (index) => StaggeredAnimation(
          index: index,
          baseDelay: const Duration(milliseconds: 500),
          child: qrTypes[index],
        ),
      ),
    );
  }

  /// Get list of all QR type cards
  List<Widget> _getQRTypes(BuildContext context, ColorScheme colorScheme) {
    return [
      // 1. URL/Website
      QRTypeCard(
        icon: Icons.link_rounded,
        title: 'URL/Website',
        subtitle: 'Create a QR code for any website link',
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.tertiary,
        onTap: () => context.goToUrlGenerator(),
      ),
      
      // 2. WiFi Network
      QRTypeCard(
        icon: Icons.wifi_rounded,
        title: 'WiFi Network',
        subtitle: 'Share WiFi credentials instantly',
        primaryColor: colorScheme.secondary,
        secondaryColor: colorScheme.primary,
        onTap: () => context.goToWifiGenerator(),
      ),
      
      // 3. Contact/vCard
      QRTypeCard(
        icon: Icons.contact_page_rounded,
        title: 'Contact/vCard',
        subtitle: 'Share contact information with a tap',
        primaryColor: colorScheme.tertiary,
        secondaryColor: colorScheme.secondary,
        onTap: () => _showComingSoon(context, 'Contact'),
      ),
      
      // 4. Email
      QRTypeCard(
        icon: Icons.email_rounded,
        title: 'Email',
        subtitle: 'Generate QR code with email address',
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
        onTap: () => _showComingSoon(context, 'Email'),
      ),
      
      // 5. Phone
      QRTypeCard(
        icon: Icons.phone_rounded,
        title: 'Phone',
        subtitle: 'Call a number with one scan',
        primaryColor: colorScheme.secondary,
        secondaryColor: colorScheme.tertiary,
        onTap: () => _showComingSoon(context, 'Phone'),
      ),
      
      // 6. SMS
      QRTypeCard(
        icon: Icons.message_rounded,
        title: 'SMS',
        subtitle: 'Send a text message instantly',
        primaryColor: const Color(0xFF2196F3), // Blue
        secondaryColor: const Color(0xFF00BCD4), // Cyan
        onTap: () => _showComingSoon(context, 'SMS'),
      ),
      
      // 7. Location
      QRTypeCard(
        icon: Icons.location_on_rounded,
        title: 'Location',
        subtitle: 'Share GPS coordinates or address',
        primaryColor: const Color(0xFF4CAF50), // Green
        secondaryColor: const Color(0xFF009688), // Teal
        onTap: () => _showComingSoon(context, 'Location'),
      ),
    ];
  }

  /// Show coming soon dialog for unimplemented QR types
  void _showComingSoon(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type QR Code'),
        content: Text('$type QR code generator is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Build footer with helpful hint - responsive sizing
  Widget _buildFooter(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    return Container(
      padding: responsive.padding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: responsive.iconSize * 0.83, // Slightly smaller
            color: colorScheme.primary,
          ),
          SizedBox(width: responsive.spacing * 1.5),
          Expanded(
            child: Text(
              'Choose a QR type to get started',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: responsive.value(
                  phone: 13.0,
                  tablet: 14.0,
                  desktop: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Digital Disconnections company footer with link
  Widget _buildCompanyFooter(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    return Column(
      children: [
        // Made by text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Made with ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: responsive.value(
                  phone: 13.0,
                  tablet: 14.0,
                  desktop: 15.0,
                ),
              ),
            ),
            Icon(
              Icons.favorite,
              size: responsive.value(
                phone: 14.0,
                tablet: 15.0,
                desktop: 16.0,
              ),
              color: Colors.red.shade400,
            ),
            Text(
              ' by ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: responsive.value(
                  phone: 13.0,
                  tablet: 14.0,
                  desktop: 15.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchWebsite,
              child: Text(
                BrandConstants.companyNameFull,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BrandConstants.brandPrimary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: BrandConstants.brandPrimary,
                  fontSize: responsive.value(
                    phone: 13.0,
                    tablet: 14.0,
                    desktop: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing * 0.5),
        // Website link
        GestureDetector(
          onTap: _launchWebsite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.language_rounded,
                size: responsive.value(
                  phone: 12.0,
                  tablet: 13.0,
                  desktop: 14.0,
                ),
                color: colorScheme.primary,
              ),
              SizedBox(width: responsive.spacing * 0.5),
              Text(
                BrandConstants.websiteUrl,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontSize: responsive.value(
                    phone: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
