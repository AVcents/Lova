import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentIndex = _getIndex(currentLocation);

    return Scaffold(
      backgroundColor: Colors.black, // ✅ Scaffold reste noir
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A), // ✅ CHANGEMENT: anthracite au lieu de noir
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_filled,
              label: 'Discover',
              index: 0,
              currentIndex: currentIndex,
              onTap: () => context.go('/dashboard'),
            ),
            _buildNavItem(
              icon: Icons.favorite,
              label: 'Relation',
              index: 1,
              currentIndex: currentIndex,
              onTap: () => context.go('/link-relation'),
            ),
            _buildNavItem(
              icon: Icons.chat_bubble,
              label: 'Lova',
              index: 2,
              currentIndex: currentIndex,
              onTap: () => context.go('/chat-lova'),
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              index: 3,
              currentIndex: currentIndex,
              onTap: () => context.go('/chat-couple'),
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profil',
              index: 4,
              currentIndex: currentIndex,
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getIndex(String location) {
    if (location.contains('/link-relation')) return 1;
    if (location.contains('/chat-lova')) return 2;
    if (location.contains('/chat-couple')) return 3;
    if (location.contains('/profile')) return 4;
    return 0;
  }
}