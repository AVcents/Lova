import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../metrics/gauge_provider.dart';
import 'widgets/gauge_widget.dart';
import 'widgets/indicator_chip.dart';
import 'widgets/next_action_card.dart';
import 'package:go_router/go_router.dart';

class RelationDashboardPage extends StatefulWidget {
  const RelationDashboardPage({super.key});

  @override
  State<RelationDashboardPage> createState() => _RelationDashboardPageState();
}

class _RelationDashboardPageState extends State<RelationDashboardPage>
    with TickerProviderStateMixin {
  bool isBreakupPressed = false;
  double breakupProgress = 0.0;
  late AnimationController _breakupController;
  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _breakupController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _breakupController.addListener(() {
      setState(() {
        breakupProgress = _breakupController.value;
      });

      if (_breakupController.value >= 1.0) {
        _showBreakupConfirmation();
      }
    });
  }

  @override
  void dispose() {
    _breakupController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _showBreakupConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fin de relation'),
          content: const Text('Êtes-vous sûr de vouloir mettre fin à cette relation ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetBreakup();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Logique pour mettre fin à la relation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Relation terminée')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void _resetBreakup() {
    setState(() {
      isBreakupPressed = false;
      breakupProgress = 0.0;
    });
    _breakupController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Fond noir comme l'image
      body: SafeArea(
        child: Column(
          children: [
            // Header avec profil, filtres et notifications
            _buildHeader(),

            // Corps principal avec les cartes relationnelles
            Expanded(
              child: _buildMainContent(),
            ),

            // Boutons d'action (croix, cœur, message)
            _buildActionButtons(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Bouton profil
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          const Spacer(),

          // Filtres centraux
          Row(
            children: [
              _buildFilterButton('TODAY', isActive: true),
              const SizedBox(width: 12),
              _buildFilterButton('FOR YOU', isActive: false),
            ],
          ),

          const Spacer(),

          // Bouton notifications
          GestureDetector(
            onTap: () {
              // Navigation vers notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8B4CB) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isActive ? const Color(0xFFE8B4CB) : Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer(
      builder: (context, ref, _) {
        final gauge = ref.watch(gaugeProvider);

        return Center(
          child: Container(
            width: 320,
            height: 480,
            child: Stack(
              children: [
                // Cartes empilées avec effet de profondeur
                Positioned(
                  top: 0,
                  child: Container(
                    width: 320,
                    height: 460,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8B7355), Color(0xFF6B5B47)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  child: Container(
                    width: 320,
                    height: 460,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF9D6B4F), Color(0xFF8B5A43)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                // Carte principale
                Positioned(
                  top: 16,
                  child: Container(
                    width: 320,
                    height: 460,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB85450), Color(0xFFA94744)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Indicateur de progression en haut
                          Row(
                            children: List.generate(3, (index) {
                              return Expanded(
                                child: Container(
                                  height: 3,
                                  margin: EdgeInsets.only(
                                    right: index < 2 ? 8 : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 40),

                          // Contenu principal - Relation info
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Jauge relationnelle
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: CircularProgressIndicator(
                                          value: gauge / 100,
                                          strokeWidth: 8,
                                          backgroundColor: Colors.white.withOpacity(0.3),
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${gauge.toInt()}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Nom de la relation
                                const Text(
                                  'Ma Relation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Informations additionnelles
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ensemble depuis 2 ans',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton de rupture avec progress
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                isBreakupPressed = true;
              });
              _breakupController.forward();
            },
            onTapUp: (_) => _resetBreakup(),
            onTapCancel: () => _resetBreakup(),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: isBreakupPressed ? Colors.red : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isBreakupPressed)
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: breakupProgress,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  Icon(
                    Icons.close,
                    color: isBreakupPressed ? Colors.red : Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          // Bouton principal (like/love)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8E9B)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 32,
            ),
          ),

          // Bouton message
          GestureDetector(
            onTap: () => context.go('/chat-couple'),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Gardez votre classe SuggestionCard originale pour la compatibilité
class SuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}