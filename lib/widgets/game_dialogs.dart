import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

enum GameDifficulty { easy, medium, hard }

class GameDialogs {
  static Future<GameDifficulty?> showDifficultyDialog(
    BuildContext context,
    GameDifficulty currentDifficulty,
  ) async {
    return showDialog<GameDifficulty>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MainColor.secondaryColor,
          title: Text(
            'Select Difficulty',
            style: GoogleFonts.coiny(
              fontSize: 24,
              color: MainColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DifficultyOption(
                title: 'Easy',
                description: 'Random moves',
                difficulty: GameDifficulty.easy,
                isSelected: currentDifficulty == GameDifficulty.easy,
                onTap: () => Navigator.of(context).pop(GameDifficulty.easy),
              ),
              const SizedBox(height: 12),
              _DifficultyOption(
                title: 'Medium',
                description: 'Blocks winning moves',
                difficulty: GameDifficulty.medium,
                isSelected: currentDifficulty == GameDifficulty.medium,
                onTap: () => Navigator.of(context).pop(GameDifficulty.medium),
              ),
              const SizedBox(height: 12),
              _DifficultyOption(
                title: 'Hard',
                description: 'Strategic play',
                difficulty: GameDifficulty.hard,
                isSelected: currentDifficulty == GameDifficulty.hard,
                onTap: () => Navigator.of(context).pop(GameDifficulty.hard),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.coiny(
                  color: MainColor.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showQuitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MainColor.secondaryColor,
          title: Text(
            'Quit Game',
            style: GoogleFonts.coiny(
              fontSize: 24,
              color: MainColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to quit the game? Your current scores will be lost.',
            style: GoogleFonts.coiny(
              fontSize: 16,
              color: MainColor.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.coiny(
                  color: MainColor.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColor.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Quit',
                style: GoogleFonts.coiny(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}

class _DifficultyOption extends StatelessWidget {
  final String title;
  final String description;
  final GameDifficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? MainColor.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? MainColor.primaryColor
                : MainColor.primaryColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: MainColor.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.coiny(
                      fontSize: 18,
                      color: MainColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.coiny(
                      fontSize: 14,
                      color: MainColor.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}