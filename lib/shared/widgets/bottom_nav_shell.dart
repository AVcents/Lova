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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
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
              label: 'Dashboard',
              index: 0,
              currentIndex: currentIndex,
              onTap: () => context.go('/dashboard'),
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
              icon: Icons.storage,
              label: 'Test',
              index: 4,
              currentIndex: currentIndex,
              onTap: () => context.go('/test-storage'),
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

    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).iconTheme.color,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  int _getIndex(String location) {
    if (location.contains('/chat-lova')) return 2;
    if (location.contains('/chat-couple')) return 3;
    if (location.contains('/test-storage')) return 4;
    if (location.contains('/profile')) return 4;
    return 0;
  }
}
