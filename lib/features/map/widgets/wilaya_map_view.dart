import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/entities/wilaya_entity.dart';

/// Algeria map (OpenStreetMap tiles) with one tappable marker per wilaya.
/// Each wilaya is individually tappable — the tap-per-region contract the brief
/// asks for. (Basemap tiles need network; markers work offline regardless.)
class WilayaMapView extends StatelessWidget {
  const WilayaMapView({
    super.key,
    required this.selected,
    required this.onWilayaTap,
  });

  final WilayaEntity? selected;
  final ValueChanged<WilayaEntity> onWilayaTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(28.0, 3.0),
        initialZoom: 4.6,
        minZoom: 4.0,
        maxZoom: 10.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.cultini.app',
        ),
        MarkerLayer(
          markers: kAlgeriaWilayas.map((w) {
            final isSelected = selected?.code == w.code;
            final size = isSelected ? 30.0 : 14.0;
            return Marker(
              point: LatLng(w.lat, w.lng),
              width: size,
              height: size,
              child: GestureDetector(
                onTap: () => onWilayaTap(w),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: isSelected ? 3 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected ? AppColors.accent : AppColors.primary)
                            .withValues(alpha: 0.5),
                        blurRadius: isSelected ? 12 : 3,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.place, size: 16, color: AppColors.primary)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
