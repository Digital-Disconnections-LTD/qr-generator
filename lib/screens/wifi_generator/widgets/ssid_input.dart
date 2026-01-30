import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// SSID (Network Name) Input Widget for WiFi QR Code Generator
/// 
/// Features:
/// - Required field validation
/// - Max length enforcement (32 characters - WiFi SSID standard)
/// - Real-time character counter
/// - Material 3 design compliance
/// - Theme-aware styling
class SsidInput extends StatefulWidget {
  /// Controller for the SSID text field
  final TextEditingController controller;
  
  /// Callback when the SSID value changes
  final ValueChanged<String>? onChanged;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Optional initial value
  final String? initialValue;

  const SsidInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
  });

  @override
  State<SsidInput> createState() => _SsidInputState();
}

class _SsidInputState extends State<SsidInput> {
  static const int _maxLength = 32; // WiFi SSID max length
  String? _errorText;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    // Set initial value if provided
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      widget.controller.text = widget.initialValue!;
      _currentLength = widget.initialValue!.length;
    }
    
    // Listen to controller changes for character count
    widget.controller.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentLength = widget.controller.text.length;
      _validateField();
    });
  }

  void _validateField() {
    final value = widget.controller.text;
    
    if (value.isEmpty) {
      _errorText = 'Network name is required';
    } else if (value.length > _maxLength) {
      _errorText = 'Network name is too long (max $_maxLength characters)';
    } else {
      _errorText = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.wifi,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Network Name (SSID)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),

        // Text Field
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          maxLength: _maxLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(_maxLength),
          ],
          decoration: InputDecoration(
            hintText: 'Enter WiFi network name',
            prefixIcon: Icon(
              Icons.network_wifi,
              color: widget.enabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            suffixIcon: widget.controller.text.isNotEmpty && widget.enabled
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged?.call('');
                    },
                  )
                : null,
            errorText: _errorText,
            counterText: '', // Hide default counter, we'll use custom
            helperText: 'This is the name others will see when connecting',
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _validateField();
            });
            widget.onChanged?.call(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Network name is required';
            }
            if (value.length > _maxLength) {
              return 'Network name is too long (max $_maxLength characters)';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          style: theme.textTheme.bodyLarge,
        ),

        // Character Counter
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Info text
              Expanded(
                child: Text(
                  'Use letters, numbers, and special characters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
              
              // Character count
              Text(
                '$_currentLength/$_maxLength',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _currentLength >= _maxLength * 0.9
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                  fontWeight: _currentLength >= _maxLength * 0.9
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
