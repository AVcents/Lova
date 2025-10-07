// lib/features/settings/pages/objectives_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/settings/services/profile_service.dart';

class ObjectivesPage extends ConsumerStatefulWidget {
  const ObjectivesPage({super.key});

  @override
  ConsumerState<ObjectivesPage> createState() => _ObjectivesPageState();
}

class _ObjectivesPageState extends ConsumerState<ObjectivesPage> {
  // États locaux
  final Set<String> _selectedObjectives = {};
  final Set<String> _selectedInterests = {};
  bool _isLoading = false;

  // Listes de données
  final List<String> _availableObjectives = [
    'Améliorer la communication',
    'Gérer les conflits',
    'Raviver la flamme',
    'Renforcer la confiance',
    'Mieux se comprendre',
    'Équilibrer vie pro/perso',
    'Intimité et sexualité',
    'Projets communs',
  ];

  final List<String> _availableInterests = [
    'Voyages',
    'Cuisine',
    'Sport',
    'Lecture',
    'Cinéma',
    'Musique',
    'Art',
    'Nature',
    'Technologie',
    'Jeux vidéo',
    'Photographie',
    'Danse',
  ];

  @override
  void initState() {
    super.initState();
    _loadObjectives();
  }

  Future<void> _loadObjectives() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(profileServiceProvider);
      final profile = await service.getCurrentProfile(); // 👈 CORRIGÉ

      if (profile != null && mounted) {
        setState(() {
          // Charger les objectifs
          if (profile.objectives != null) {
            _selectedObjectives.addAll(profile.objectives!);
          }

          // Charger les centres d'intérêt
          if (profile.interests != null) {
            _selectedInterests.addAll(profile.interests!);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveObjectives() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(profileServiceProvider);

      // Mettre à jour avec paramètres nommés 👈 CORRIGÉ
      await service.updateProfile(
        objectives: _selectedObjectives.toList(),
        interests: _selectedInterests.toList(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Objectifs et centres d\'intérêt mis à jour'),
            duration: Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objectifs & Centres d\'intérêt'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveObjectives,
              child: const Text('Sauvegarder'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Objectifs
          _buildSectionHeader(
            icon: Icons.flag_rounded,
            title: 'Mes objectifs de couple',
            subtitle: 'Sélectionnez ce que vous souhaitez améliorer dans votre relation',
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            'Ces objectifs nous aideront à personnaliser votre expérience et à vous proposer du contenu adapté.',
            Icons.lightbulb_outline,
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableObjectives.map((objective) {
              final isSelected = _selectedObjectives.contains(objective);
              return FilterChip(
                label: Text(objective),
                selected: isSelected,
                showCheckmark: true,
                avatar: isSelected ? null : const Icon(Icons.add_circle_outline, size: 18),
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedObjectives.add(objective);
                    } else {
                      _selectedObjectives.remove(objective);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),

          // Section Centres d'intérêt
          _buildSectionHeader(
            icon: Icons.favorite_rounded,
            title: 'Centres d\'intérêt communs',
            subtitle: 'Sélectionnez vos passions et hobbies',
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            'Trouvez des activités et contenus en lien avec vos passions communes.',
            Icons.explore_outlined,
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                showCheckmark: true,
                avatar: isSelected ? null : const Icon(Icons.add_circle_outline, size: 18),
                selectedColor: theme.colorScheme.secondaryContainer,
                checkmarkColor: theme.colorScheme.secondary,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Résumé
          if (_selectedObjectives.isNotEmpty || _selectedInterests.isNotEmpty)
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Votre sélection',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_selectedObjectives.isNotEmpty) ...[
                      Text(
                        '${_selectedObjectives.length} objectif${_selectedObjectives.length > 1 ? 's' : ''} sélectionné${_selectedObjectives.length > 1 ? 's' : ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (_selectedInterests.isNotEmpty) ...[
                      Text(
                        '${_selectedInterests.length} centre${_selectedInterests.length > 1 ? 's' : ''} d\'intérêt sélectionné${_selectedInterests.length > 1 ? 's' : ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String text, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}