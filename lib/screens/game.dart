import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

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

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'You',
                          style: GoogleFonts.coiny(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text('$oScore', style: customFontWhite),
                      ],
                    ),
                    SizedBox(width: 60),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Robot',
                          style: GoogleFonts.coiny(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text('$xScore', style: customFontWhite),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
                          width: 5,
                          color: MainColor.primaryColor,
                        ),
                        color: MainColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: 64,
                              color: MainColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(resultDeclaration, style: customFontWhite),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColor.accentColor,
                        foregroundColor: MainColor.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: GoogleFonts.coiny(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _clearBoard();
                      },
                      child: Text('Play Again!'),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    
    List<int> availableMoves = [];
    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == '') {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isNotEmpty) {
      final random = Random();
      int robotChoice = availableMoves[random.nextInt(availableMoves.length)];
      
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
}
