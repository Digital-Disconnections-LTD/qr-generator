import 'package:flutter/material.dart';

/// Digital Disconnections brand constants
/// 
/// Contains all branding-related constants including:
/// - Company information
/// - Brand colors extracted from logo
/// - Asset paths
/// - URLs
class BrandConstants {
  BrandConstants._(); // Private constructor to prevent instantiation

  // Company Information
  static const String companyName = 'Digital Disconnections';
  static const String companyNameFull = 'Digital Disconnections Inc.';
  static const String websiteUrl = 'https://digitaldisconnections.com';
  
  // App Branding
  static const String appName = 'QR Code Generator';
  static const String appNameWithBranding = 'QR Code Generator by Digital Disconnections';
  static const String appTagline = 'Create custom QR codes instantly';
  
  // Brand Colors (extracted from logo)
  /// Primary brand color - Blue-grey from logo
  static const Color brandPrimary = Color(0xFF556270);
  
  /// Secondary brand color - Warm brown from logo
  static const Color brandSecondary = Color(0xFF8B6F47);
  
  /// Lighter variant of brand primary for backgrounds
  static const Color brandPrimaryLight = Color(0xFF7B8794);
  
  /// Darker variant of brand secondary for accents
  static const Color brandSecondaryDark = Color(0xFF6B5537);
  
  // Asset Paths
  static const String logoPath = 'assets/images/digital_disconnections_logo.png';
  
  // Footer Text
  static const String footerText = 'Made by Digital Disconnections Inc.';
  static const String footerWithLink = 'Made with ♥ by Digital Disconnections Inc.';
  
  // About Text
  static const String aboutDescription = 
      'QR Code Generator is a beautiful, easy-to-use tool for creating custom QR codes. '
      'Generate QR codes for URLs, WiFi networks, and more with stunning decorative borders.';
  
  static const String aboutCompany = 
      'Digital Disconnections Inc. creates thoughtful software that helps people '
      'disconnect from unnecessary digital noise and focus on what matters.';
}
