import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GameBottomNav extends StatelessWidget {
  final VoidCallback onNewGame;
  final VoidCallback onChangeDifficulty;
  final VoidCallback onQuitGame;

  const GameBottomNav({
    super.key,
    required this.onNewGame,
    required this.onChangeDifficulty,
    required this.onQuitGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: MainColor.primaryColor.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.refresh,
            label: 'New Game',
            onTap: onNewGame,
          ),
          _NavItem(
            icon: Icons.tune,
            label: 'Difficulty',
            onTap: onChangeDifficulty,
          ),
          _NavItem(
            icon: Icons.exit_to_app,
            label: 'Quit',
            onTap: onQuitGame,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}