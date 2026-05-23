import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/azetta_motif.dart';
import '../../../../core/extensions/snackbar_extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../di/injection_container.dart';
import '../../../docs/domain/entities/doc_entry_entity.dart';
import '../../../map/domain/entities/wilaya_entity.dart';
import '../../domain/entities/contribution_entity.dart';
import '../bloc/contribution_cubit.dart';

/// ─── Contribution Screen ──────────────────────────────────────────────────────
/// Form for users to suggest a new documentation entry. Submits to the
/// (mock) ContributionRepository and confirms on success.
class ContributionScreen extends StatelessWidget {
  const ContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContributionCubit>(
      create: (_) => sl<ContributionCubit>(),
      child: const _ContributionView(),
    );
  }
}

class _ContributionView extends StatefulWidget {
  const _ContributionView();

  @override
  State<_ContributionView> createState() => _ContributionViewState();
}

class _ContributionViewState extends State<_ContributionView> {
  final _formKey = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _contenuCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _contributorCtrl = TextEditingController();

  DocCategory? _categorie;
  String? _wilaya;

  @override
  void dispose() {
    _titreCtrl.dispose();
    _contenuCtrl.dispose();
    _sourceCtrl.dispose();
    _contributorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ContributionCubit>().submit(
          ContributionEntity(
            titre: _titreCtrl.text.trim(),
            categorie: _categorie!,
            wilaya: _wilaya!,
            contenu: _contenuCtrl.text.trim(),
            source: _sourceCtrl.text.trim(),
            contributorName: _contributorCtrl.text.trim().isEmpty
                ? null
                : _contributorCtrl.text.trim(),
          ),
        );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titreCtrl.clear();
    _contenuCtrl.clear();
    _sourceCtrl.clear();
    _contributorCtrl.clear();
    setState(() {
      _categorie = null;
      _wilaya = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contribuer')),
      body: BlocConsumer<ContributionCubit, ContributionState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == ContributionStatus.success) {
            final result = state.result;
            final message =
                result?.message ?? 'Merci ! Votre contribution a été enregistrée.';
            if (result == null || result.accepted) {
              // Cleared the auto-filter → in the moderation queue.
              context.showSuccessSnackBar(message);
              _resetForm();
            } else {
              // Auto-rejected (spam / doublon): keep the form so the user can edit.
              context.showErrorSnackBar(message);
            }
            context.read<ContributionCubit>().reset();
          } else if (state.status == ContributionStatus.failure) {
            context.showErrorSnackBar(state.error ?? "Échec de l'envoi");
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == ContributionStatus.submitting;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AzettaDivider(height: 12, opacity: 0.2, cell: 14),
                        const SizedBox(height: 10),
                        Text(
                          'Proposez une fiche pour enrichir le corpus. Elle sera revue avant publication.',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  AppTextField(
                    label: 'Titre',
                    hint: 'Ex. La fibule kabyle',
                    controller: _titreCtrl,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Champ requis';
                      if (v.trim().length < 3) return 'Min. 3 caractères';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _DropdownField<DocCategory>(
                    label: 'Catégorie',
                    value: _categorie,
                    hint: 'Choisir une catégorie',
                    items: DocCategory.values
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.label),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _categorie = v),
                    validator: (v) => v == null ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),

                  _DropdownField<String>(
                    label: 'Wilaya',
                    value: _wilaya,
                    hint: 'Choisir une wilaya',
                    items: kAlgeriaWilayas
                        .map((w) => DropdownMenuItem(
                              value: w.nameFr,
                              child: Text(
                                  '${w.code.toString().padLeft(2, '0')} · ${w.nameFr}'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _wilaya = v),
                    validator: (v) => v == null ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),

                  _MultilineField(
                    label: 'Contenu',
                    hint: 'Décrivez le motif, le bijou, la technique…',
                    controller: _contenuCtrl,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Champ requis';
                      if (v.trim().length < 20) return 'Min. 20 caractères';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Source',
                    hint: 'Référence, ouvrage, témoignage…',
                    controller: _sourceCtrl,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Votre nom (optionnel)',
                    hint: 'Anonyme par défaut',
                    controller: _contributorCtrl,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Envoyer la contribution',
                    onPressed: _submit,
                    isLoading: isSubmitting,
                    icon: Icons.send_rounded,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          hint: Text(hint, style: GoogleFonts.hankenGrotesk(fontSize: 14)),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

class _MultilineField extends StatelessWidget {
  const _MultilineField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: 5,
          style: GoogleFonts.hankenGrotesk(
              fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
