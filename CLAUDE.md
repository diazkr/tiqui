# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application implementing a Tic-Tac-Toe game where the player (O) competes against a robot opponent (X). The game features score tracking, automatic robot moves with random AI, and a clean Material Design interface.

## Architecture

The app follows a simple Flutter architecture:

- **Entry Point**: `lib/main.dart` - Sets up the MaterialApp and launches directly into the game
- **Game Logic**: `lib/screens/game.dart` - Contains the main GameScreen widget with all game state and logic
- **Styling**: `lib/constants/colors.dart` - Centralized color scheme with purple/cyan theme
- **External Dependencies**: Uses `google_fonts` for typography (Coiny font family)

The GameScreen manages all game state including:
- Board state (9-cell grid)
- Turn management (player vs robot)
- Score tracking (persistent across games)
- Win/draw detection
- Robot AI (random move selection with 500ms delay)

## Common Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d android
flutter run -d ios

# Build for release
flutter build apk
flutter build ios

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade
```

## Development Setup

The project targets Flutter SDK ^3.9.2 and uses:
- Material Design components
- Google Fonts (Coiny family)
- Flutter lints for code quality

Android development is fully configured. iOS/macOS development requires Xcode installation and CocoaPods setup.

## Key Implementation Details

- Robot moves are implemented with `Future.delayed(Duration(milliseconds: 500))` to simulate thinking
- Game state is managed entirely within `_GameScreenState` using setState
- Win detection uses a predefined list of winning patterns (rows, columns, diagonals)
- Score persists across rounds but resets when the app restarts
- The UI uses a 3-column Flex layout with score display, game grid, and controls