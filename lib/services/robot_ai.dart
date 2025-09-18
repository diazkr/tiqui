import 'dart:math';
import '../widgets/game_dialogs.dart';

class RobotAI {
  static int getMove(List<String> board, GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return _getRandomMove(board);
      case GameDifficulty.medium:
        return _getMediumMove(board);
      case GameDifficulty.hard:
        return _getHardMove(board);
    }
  }

  static int _getRandomMove(List<String> board) {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }
    if (availableMoves.isEmpty) return -1;

    final random = Random();
    return availableMoves[random.nextInt(availableMoves.length)];
  }

  static int _getMediumMove(List<String> board) {
    // First, try to block player's winning move
    int blockingMove = _findBlockingMove(board);
    if (blockingMove != -1) return blockingMove;

    // Otherwise, make a random move
    return _getRandomMove(board);
  }

  static int _getHardMove(List<String> board) {
    // 1. Try to win
    int winningMove = _findWinningMove(board, 'X');
    if (winningMove != -1) return winningMove;

    // 2. Block player's winning move
    int blockingMove = _findBlockingMove(board);
    if (blockingMove != -1) return blockingMove;

    // 3. Take center if available
    if (board[4] == '') return 4;

    // 4. Take corners
    List<int> corners = [0, 2, 6, 8];
    for (int corner in corners) {
      if (board[corner] == '') return corner;
    }

    // 5. Take edges
    List<int> edges = [1, 3, 5, 7];
    for (int edge in edges) {
      if (board[edge] == '') return edge;
    }

    // Fallback to random
    return _getRandomMove(board);
  }

  static int _findWinningMove(List<String> board, String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6], // diagonals
    ];

    for (final pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];

      // Check if two positions have the player and one is empty
      if (board[a] == player && board[b] == player && board[c] == '') {
        return c;
      }
      if (board[a] == player && board[c] == player && board[b] == '') {
        return b;
      }
      if (board[b] == player && board[c] == player && board[a] == '') {
        return a;
      }
    }
    return -1;
  }

  static int _findBlockingMove(List<String> board) {
    // Find where the player (O) can win and block it
    return _findWinningMove(board, 'O');
  }

  static String getDifficultyDisplayName(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }
}