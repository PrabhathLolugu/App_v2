import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_generation_service.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:myitihas/pages/map2/custom_site/map_coordinate_picker_page.dart';

class CustomSiteInputPage extends StatefulWidget {
  const CustomSiteInputPage({super.key});

  @override
  State<CustomSiteInputPage> createState() => _CustomSiteInputPageState();
}

class _CustomSiteInputPageState extends State<CustomSiteInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _templeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _templeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      _latController.text = pos.latitude.toStringAsFixed(6);
      _lonController.text = pos.longitude.toStringAsFixed(6);
      if (mounted) setState(() {});
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to fetch current location')),
      );
    }
  }

  double? _parseNumber(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final result = await CustomSiteGenerationService.generate(
        templeName: _templeController.text.trim(),
        locationText: _locationController.text.trim(),
        latitude: _parseNumber(_latController.text),
        longitude: _parseNumber(_lonController.text),
        userContext: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop<CustomSiteGenerationResult>(result);
    } catch (e) {
      if (!mounted) return;
      if (e is SacredSitePolicyException) {
        _showPolicyViolationDialog(e);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to generate sacred site. Please try again.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showPolicyViolationDialog(SacredSitePolicyException e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.policy_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            const Text('Sacred Site Policy'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (e.reason != null) ...[
              const SizedBox(height: 12),
              Text(
                e.reason!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'MyItihas is dedicated to preserving and exploring Sanatan sacred geography. Please ensure your submission aligns with this focus.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Future<void> _pickOnMap() async {
    final selected = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => MapCoordinatePickerPage(
          initialCoordinate:
              _parseNumber(_latController.text) != null &&
                  _parseNumber(_lonController.text) != null
              ? LatLng(
                  _parseNumber(_latController.text)!,
                  _parseNumber(_lonController.text)!,
                )
              : null,
        ),
      ),
    );
    if (!mounted || selected == null) return;
    _latController.text = selected.latitude.toStringAsFixed(6);
    _lonController.text = selected.longitude.toStringAsFixed(6);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Sacred Site')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Add any Sanatan sites of Bharat like temples, dham, peeth, tirth, etc.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _templeController,
              decoration: const InputDecoration(
                labelText: 'Site Name',
                hintText: 'e.g. Tirupati Balaji or Kashi Vishwanath',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Site name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'City, district, state',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _parseNumber(_latController.text) != null
                      ? [
                          Colors.green.shade400.withOpacity(0.15),
                          Colors.green.shade600.withOpacity(0.05),
                        ]
                      : [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _parseNumber(_latController.text) != null
                      ? Colors.green.withOpacity(0.4)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _parseNumber(_latController.text) != null
                              ? Colors.green.withOpacity(0.15)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _parseNumber(_latController.text) != null
                              ? Icons.check_circle_rounded
                              : Icons.my_location_rounded,
                          color: _parseNumber(_latController.text) != null
                              ? Colors.green.shade700
                              : Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _parseNumber(_latController.text) != null
                                  ? 'Location Secured'
                                  : 'Pinpoint Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: _parseNumber(_latController.text) != null
                                    ? Colors.green.shade800
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _parseNumber(_latController.text) != null
                                  ? 'Coordinates saved for this sacred site.'
                                  : 'We need exact coordinates to guide pilgrims.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _useCurrentLocation,
                          icon: const Icon(Icons.gps_fixed, size: 18),
                          label: const Text('Use GPS'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _pickOnMap,
                          icon: const Icon(Icons.map_rounded, size: 18),
                          label: const Text('Open Map'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'What details you want (optional)',
                hintText: 'Mention deity, tradition, rituals, nearby places...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  _isSubmitting
                      ? 'Generating sacred site...'
                      : 'Generate Full Details',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
