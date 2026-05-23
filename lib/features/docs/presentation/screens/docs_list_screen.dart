import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection_container.dart';
import '../../../map/domain/entities/wilaya_entity.dart';
import '../bloc/docs_cubit.dart';
import '../widgets/doc_card.dart';
import '../widgets/doc_category_filter_bar.dart';
import 'doc_detail_screen.dart';

/// Searchable, filterable documentation list. [initialWilaya] (passed from the
/// Map page) pre-filters by region.
class DocsListScreen extends StatelessWidget {
  const DocsListScreen({super.key, this.initialWilaya});

  final String? initialWilaya;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocsCubit>(
      create: (_) => sl<DocsCubit>()..load(initialWilaya: initialWilaya),
      child: const _DocsView(),
    );
  }
}

class _DocsView extends StatefulWidget {
  const _DocsView();

  @override
  State<_DocsView> createState() => _DocsViewState();
}

class _DocsViewState extends State<_DocsView> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openWilayaPicker() {
    final cubit = context.read<DocsCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            ListTile(
              leading: const Icon(Icons.public, color: AppColors.primary),
              title: Text(
                'Toutes les wilayas',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                cubit.setWilaya(null);
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            ...kAlgeriaWilayas.map(
              (w) => ListTile(
                dense: true,
                leading: Text(
                  w.code.toString().padLeft(2, '0'),
                  style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                title: Text(w.nameFr, style: GoogleFonts.poppins(fontSize: 14)),
                onTap: () {
                  cubit.setWilaya(w.nameFr);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation'),
        actions: [
          IconButton(
            tooltip: 'Filtrer par wilaya',
            icon: const Icon(Icons.place_outlined),
            onPressed: _openWilayaPicker,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => context.read<DocsCubit>().setQuery(v),
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher (titre, terme amazigh…)',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
              ),
            ),
          ),

          // Category chips
          BlocBuilder<DocsCubit, DocsState>(
            buildWhen: (p, c) => p.category != c.category,
            builder: (context, state) => DocCategoryFilterBar(
              selected: state.category,
              onSelect: (c) => context.read<DocsCubit>().setCategory(c),
            ),
          ),

          // Active wilaya chip
          BlocBuilder<DocsCubit, DocsState>(
            buildWhen: (p, c) => p.wilaya != c.wilaya,
            builder: (context, state) {
              if (state.wilaya == null || state.wilaya!.isEmpty) {
                return const SizedBox(height: 8);
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InputChip(
                    label: Text('Wilaya : ${state.wilaya}'),
                    onDeleted: () => context.read<DocsCubit>().setWilaya(null),
                    backgroundColor: AppColors.primarySurface,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    deleteIconColor: AppColors.primary,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: BlocBuilder<DocsCubit, DocsState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }
                final items = state.filtered;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Aucune entrée ne correspond à ces filtres.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final entry = items[index];
                    return DocCard(
                      entry: entry,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DocDetailScreen(entry: entry),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
