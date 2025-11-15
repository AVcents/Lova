// lib/features/settings/pages/edit_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/features/settings/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs de texte
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  // États locaux
  DateTime? _birthDate;
  String? _gender;
  String? _selectedLanguage;
  String? _selectedTimezone = 'Europe/Paris';
  bool _notificationEmail = true;
  bool _notificationPush = true;
  bool _marketingConsent = false;
  bool _analyticsConsent = false;

  String? _avatarUrl;
  File? _avatarFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Listes de données
  final Map<String, String> _genders = {
    'male': 'Homme',
    'female': 'Femme',
    'non_binary': 'Non-binaire',
    'prefer_not_to_say': 'Préfère ne pas dire',
  };  final Map<String, String> _languages = {
    'fr': 'Français',
    'en': 'English',
    'es': 'Español',
    'de': 'Deutsch',
  };

  final List<String> _timezones = [
    'Europe/Paris',
    'Europe/London',
    'America/New_York',
    'America/Los_Angeles',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(profileServiceProvider);
      final profile = await service.getCurrentProfile();

      if (profile != null && mounted) {
        // Générer l'URL signée AVANT setState
        String? avatarUrl;
        if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
          if (profile.avatarUrl!.startsWith('http')) {
            avatarUrl = profile.avatarUrl;
          } else {
            avatarUrl = await Supabase.instance.client.storage
                .from('avatars')
                .createSignedUrl(profile.avatarUrl!, 3600);
          }
        }

        setState(() {
          _firstNameController.text = profile.firstName ?? '';
          _lastNameController.text = profile.lastName ?? '';
          _nicknameController.text = profile.prenom ?? '';
          _phoneController.text = profile.phone ?? '';
          _cityController.text = profile.city ?? '';
          _countryController.text = profile.country ?? '';

          _birthDate = profile.dateOfBirth;
          _gender = profile.gender;
          _selectedLanguage = profile.preferredLanguage ?? 'fr';
          _selectedTimezone = profile.timezone ?? 'Europe/Paris';
          _notificationEmail = profile.notificationEmail ?? true;
          _notificationPush = profile.notificationPush ?? true;
          _marketingConsent = profile.marketingConsent ?? false;
          _analyticsConsent = profile.analyticsConsent ?? false;
          _avatarUrl = avatarUrl;  // URL signée
        });
      }
    } catch (e) {
      // ... votre gestion d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _avatarFile = File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final service = ref.read(profileServiceProvider);

      // Upload avatar si modifié
      if (_avatarFile != null) {
        await service.uploadAvatar(_avatarFile!);
      }

      // Mettre à jour le profil avec paramètres nommés 👈 CORRIGÉ
      await service.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        prenom: _nicknameController.text.trim(),
        phone: _phoneController.text.trim(),
        dateOfBirth: _birthDate,
        gender: _gender,
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        preferredLanguage: _selectedLanguage,
        timezone: _selectedTimezone,
        notificationEmail: _notificationEmail,
        notificationPush: _notificationPush,
        marketingConsent: _marketingConsent,
        analyticsConsent: _analyticsConsent,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profil mis à jour')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        actions: [
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ))
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Sauvegarder'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: context.spacing.screenPadding,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!)
                        : (_avatarUrl != null
                        ? NetworkImage(_avatarUrl!)
                        : null) as ImageProvider?,
                    child: _avatarFile == null && _avatarUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton<ImageSource>(
                      icon: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: const Icon(Icons.edit, size: 20),
                      ),
                      onSelected: _pickImage,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: ImageSource.camera,
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt),
                              SizedBox(width: context.spacing.xs),
                              const Text('Prendre une photo'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: ImageSource.gallery,
                          child: Row(
                            children: [
                              const Icon(Icons.photo_library),
                              SizedBox(width: context.spacing.xs),
                              const Text('Choisir une photo'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.spacing.xxl),

            _buildSectionTitle('Informations personnelles'),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val?.isEmpty ?? true ? 'Requis' : null,
            ),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Nom de famille',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Surnom',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: context.spacing.md),

            // Date de naissance
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _birthDate ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _birthDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date de naissance',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _birthDate != null
                      ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                      : 'Sélectionner une date',
                ),
              ),
            ),
            SizedBox(height: context.spacing.md),

            // Genre
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Genre',
                prefixIcon: Icon(Icons.wc),
                border: OutlineInputBorder(),
              ),
              items: _genders.entries.map((e) => DropdownMenuItem(
                value: e.key,        // Clé anglaise stockée en BDD
                child: Text(e.value), // Label français affiché
              )).toList(),
              onChanged: (value) => setState(() => _gender = value),
            ),

            SizedBox(height: context.spacing.xxl),

            _buildSectionTitle('Localisation'),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ville',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: context.spacing.md),

            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Pays',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: context.spacing.md),

            DropdownButtonFormField<String>(
              value: _selectedTimezone,
              decoration: const InputDecoration(
                labelText: 'Fuseau horaire',
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
              ),
              items: _timezones.map((tz) => DropdownMenuItem(
                value: tz,
                child: Text(tz),
              )).toList(),
              onChanged: (value) => setState(() => _selectedTimezone = value),
            ),

            SizedBox(height: context.spacing.xxl),

            _buildSectionTitle('Préférences'),
            SizedBox(height: context.spacing.md),

            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Langue',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
              items: _languages.entries.map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              )).toList(),
              onChanged: (value) => setState(() => _selectedLanguage = value),
            ),
            SizedBox(height: context.spacing.md),

            SwitchListTile(
              title: const Text('Notifications par email'),
              value: _notificationEmail,
              onChanged: (val) => setState(() => _notificationEmail = val),
            ),
            SwitchListTile(
              title: const Text('Notifications push'),
              value: _notificationPush,
              onChanged: (val) => setState(() => _notificationPush = val),
            ),

            SizedBox(height: context.spacing.xxl),

            _buildSectionTitle('Consentements (RGPD)'),
            SizedBox(height: context.spacing.md),

            SwitchListTile(
              title: const Text('Marketing'),
              subtitle: const Text('Recevoir des offres et nouveautés'),
              value: _marketingConsent,
              onChanged: (val) => setState(() => _marketingConsent = val),
            ),
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Améliorer nos services via vos données anonymisées'),
              value: _analyticsConsent,
              onChanged: (val) => setState(() => _analyticsConsent = val),
            ),

            SizedBox(height: context.spacing.xxl * 2.5),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}