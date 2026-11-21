import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/sede.dart';

/// Mapa de OpenStreetMap con las sedes y la ubicación del usuario.
class SedesMap extends StatefulWidget {
  const SedesMap({
    super.key,
    required this.sedes,
    this.user,
    this.focus,
    this.height = 240,
    this.onSedeTap,
  });
  final List<Sede> sedes;
  final LatLng? user;

  /// Si se indica, el mapa se centra aquí (por ejemplo, en una sede).
  final LatLng? focus;
  final double height;
  final void Function(Sede)? onSedeTap;

  @override
  State<SedesMap> createState() => _SedesMapState();
}

class _SedesMapState extends State<SedesMap> {
  static const _fallbackCenter = LatLng(-14.8305, -74.9393); // Nasca
  final _controller = MapController();
  bool _ready = false;
  bool _centered = false;

  LatLng get _initialCenter =>
      widget.focus ??
      widget.user ??
      (widget.sedes.isNotEmpty ? widget.sedes.first.position : _fallbackCenter);

  @override
  void didUpdateWidget(SedesMap old) {
    super.didUpdateWidget(old);
    // Centra el mapa en el usuario la primera vez que llega su ubicación.
    if (_ready &&
        !_centered &&
        widget.focus == null &&
        old.user == null &&
        widget.user != null) {
      _controller.move(widget.user!, 14);
      _centered = true;
    }
  }

  Widget _circle(Color color, Widget? child) => Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: widget.focus != null ? 15 : 14,
                onMapReady: () => _ready = true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'pe.edu.iestp.saludmovil_ies',
                ),
                MarkerLayer(
                  markers: [
                    for (final s in widget.sedes)
                      Marker(
                        point: s.position,
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => widget.onSedeTap?.call(s),
                          child: _circle(
                            AppColors.navy,
                            const Icon(Icons.local_hospital, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    if (widget.user != null)
                      Marker(
                        point: widget.user!,
                        width: 28,
                        height: 28,
                        child: _circle(AppColors.levelV, null),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(source: Text('© OpenStreetMap')),
              ],
            ),
            Positioned(
              right: 8,
              top: 8,
              child: FloatingActionButton.small(
                heroTag: null,
                tooltip: 'Mi ubicación',
                backgroundColor: Colors.white,
                foregroundColor: AppColors.navy,
                onPressed: widget.user == null
                    ? null
                    : () => _controller.move(widget.user!, 15),
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
