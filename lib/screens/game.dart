import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/game_bottom_nav.dart';
import '../widgets/game_dialogs.dart';
import '../services/robot_ai.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  String resultDeclaration = '';
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];

  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  GameDifficulty currentDifficulty = GameDifficulty.easy;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tic Tac Toe',
                    style: GoogleFonts.coiny(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Difficulty: ${RobotAI.getDifficultyDisplayName(currentDifficulty)}',
                    style: GoogleFonts.coiny(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'You',
                          style: GoogleFonts.coiny(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$oScore',
                          style: GoogleFonts.coiny(
                            fontSize: 24,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        Text(
                          'Robot',
                          style: GoogleFonts.coiny(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$xScore',
                          style: GoogleFonts.coiny(
                            fontSize: 24,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 350,
                  ),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 3,
                              color: MainColor.primaryColor,
                            ),
                            color: MainColor.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              displayXO[index],
                              style: GoogleFonts.coiny(
                                fontSize: 48,
                                color: MainColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultDeclaration,
                      style: GoogleFonts.coiny(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (resultDeclaration.isNotEmpty)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColor.accentColor,
                          foregroundColor: MainColor.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: GoogleFonts.coiny(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _clearBoard();
                        },
                        child: const Text('Play Again!'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GameBottomNav(
          onNewGame: _newGame,
          onChangeDifficulty: _changeDifficulty,
          onQuitGame: _quitGame,
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (!oTurn || displayXO[index] != '' || resultDeclaration.isNotEmpty) {
      return;
    }

    setState(() {
      displayXO[index] = 'O';
      oTurn = false;
      _checkWinner();
    });

    if (resultDeclaration.isEmpty && displayXO.contains('')) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _robotMove();
      });
    }
  }

  void _robotMove() {
    if (resultDeclaration.isNotEmpty) return;

    int robotChoice = RobotAI.getMove(displayXO, currentDifficulty);

    if (robotChoice != -1) {
      setState(() {
        displayXO[robotChoice] = 'X';
        oTurn = true;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    final winPatterns = const [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (displayXO[a].isNotEmpty &&
          displayXO[a] == displayXO[b] &&
          displayXO[a] == displayXO[c]) {
        setState(() {
          String winner = displayXO[a] == 'O' ? 'You' : 'Robot';
          resultDeclaration = '$winner Win!';
          _updatedScore(displayXO[a]);
        });
        return;
      }
    }

    // Draw if board is full and no winner
    if (!displayXO.contains('')) {
      setState(() {
        resultDeclaration = "It's a Draw!";
      });
    }
  }

  void _updatedScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      filledBoxes = 0;
      oTurn = true;
    });
  }

  void _newGame() {
    _clearBoard();
    setState(() {
      oScore = 0;
      xScore = 0;
    });
  }

  void _changeDifficulty() async {
    final newDifficulty = await GameDialogs.showDifficultyDialog(
      context,
      currentDifficulty,
    );
    if (newDifficulty != null) {
      setState(() {
        currentDifficulty = newDifficulty;
      });
      _clearBoard();
    }
  }

  void _quitGame() async {
    final shouldQuit = await GameDialogs.showQuitDialog(context);
    if (shouldQuit) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
    }
  }
}
