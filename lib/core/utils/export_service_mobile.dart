import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../../models/export_options.dart';

/// Mobile-specific implementation for saving images.
///
/// This file is imported when running on mobile platforms (iOS/Android).
/// It saves images to the app's documents directory.
Future<String?> saveImagePlatform(
  Uint8List imageBytes,
  String filename,
  ExportFormat format,
) async {
  try {
    // Get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();
    
    // Create the full file path
    final filePath = '${directory.path}/$filename';
    
    // Write the bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    
    return filePath;
  } catch (e) {
    throw Exception('Failed to save image on mobile: $e');
  }
}
