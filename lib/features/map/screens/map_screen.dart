import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../docs/presentation/screens/docs_list_screen.dart';
import '../domain/entities/wilaya_entity.dart';
import '../widgets/wilaya_info_sheet.dart';
import '../widgets/wilaya_map_view.dart';

/// ─── Map Screen ───────────────────────────────────────────────────────────────
/// Interactive map of Algeria's 58 wilayas. Tapping a wilaya reveals its name,
/// then opens the Documentation page pre-filtered by that wilaya.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  WilayaEntity? _selected;

  void _explore(WilayaEntity wilaya) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DocsListScreen(initialWilaya: wilaya.nameFr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.mapTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text(
              'Touchez une wilaya pour explorer sa documentation.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: WilayaMapView(
              selected: _selected,
              onWilayaTap: (w) => setState(() => _selected = w),
            ),
          ),
          if (_selected != null)
            WilayaInfoSheet(
              wilaya: _selected!,
              onExplore: () => _explore(_selected!),
            ),
        ],
      ),
    );
  }
}
