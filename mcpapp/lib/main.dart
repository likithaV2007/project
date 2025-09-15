import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const TicTacToeGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;
  int xWins = 0;
  int oWins = 0;
  int draws = 0;
  
  late AnimationController _winController;
  late AnimationController _cellController;
  late AnimationController _pulseController;
  late Animation<double> _winAnimation;
  late Animation<double> _cellAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  List<int> winningLine = [];
  int _animatingCell = -1;

  @override
  void initState() {
    super.initState();
    _winController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cellController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _winAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _winController,
      curve: Curves.elasticOut,
    ));
    
    _cellAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cellController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _cellController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _winController.dispose();
    _cellController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _makeMove(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        _animatingCell = index;
      });
      
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
      
      _cellController.forward().then((_) {
        _cellController.reset();
        setState(() {
          _animatingCell = -1;
        });
      });
      
      _checkWinner();
      
      if (!gameOver) {
        setState(() {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        });
      }
    }
  }

  void _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (List<int> pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        setState(() {
          winner = board[pattern[0]];
          gameOver = true;
          winningLine = pattern;
          if (winner == 'X') {
            xWins++;
          } else {
            oWins++;
          }
        });
        _winController.forward();
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
        gameOver = true;
        draws++;
      });
      _winController.forward();
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
      winningLine = [];
    });
    _winController.reset();
  }

  void _resetStats() {
    setState(() {
      xWins = 0;
      oWins = 0;
      draws = 0;
    });
    _resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF4facfe),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? 32.0 : 20.0),
                child: Column(
                  children: [
                    // Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Text(
                            '🎮 TIC TAC TOE 🎮',
                            style: TextStyle(
                              fontSize: isWide ? 36 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Challenge Your Mind',
                            style: TextStyle(
                              fontSize: isWide ? 18 : 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Score Board
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 600 : double.infinity,
                      ),
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScoreCard('X', xWins, const Color(0xFF667eea)),
                          _buildScoreCard('DRAW', draws, Colors.grey[600]!),
                          _buildScoreCard('O', oWins, const Color(0xFF764ba2)),
                        ],
                      ),
                    ),

                    // Current Player Indicator
                    if (!gameOver)
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: currentPlayer == 'X' 
                                ? [const Color(0xFF667eea), const Color(0xFF4facfe)]
                                : [const Color(0xFF764ba2), const Color(0xFF667eea)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: (currentPlayer == 'X' 
                                  ? const Color(0xFF667eea) 
                                  : const Color(0xFF764ba2)).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          'Player $currentPlayer\'s Turn',
                          style: TextStyle(
                            fontSize: isWide ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    // Game Board
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 400 : 350,
                        maxHeight: isWide ? 400 : 350,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return _buildCell(index);
                        },
                      ),
                    ),

                    // Win Message
                    if (gameOver) ...[
                      const SizedBox(height: 30),
                      ScaleTransition(
                        scale: _winAnimation,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isWide ? 400 : double.infinity,
                          ),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: winner == 'X' 
                                  ? [const Color(0xFF667eea), const Color(0xFF4facfe)]
                                  : winner == 'O'
                                      ? [const Color(0xFF764ba2), const Color(0xFF667eea)]
                                      : [Colors.grey[600]!, Colors.grey[500]!],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (winner == 'X' 
                                    ? const Color(0xFF667eea) 
                                    : winner == 'O'
                                        ? const Color(0xFF764ba2)
                                        : Colors.grey[600]!).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                winner == 'Draw' ? '🤝' : '🎉',
                                style: const TextStyle(fontSize: 40),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                winner == 'Draw' 
                                    ? 'It\'s a Draw!' 
                                    : 'Player $winner Wins!',
                                style: TextStyle(
                                  fontSize: isWide ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Action Buttons
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          'New Game',
                          Icons.refresh,
                          const Color(0xFF667eea),
                          _resetGame,
                        ),
                        const SizedBox(width: 15),
                        _buildActionButton(
                          'Reset Stats',
                          Icons.clear_all,
                          Colors.grey[600]!,
                          _resetStats,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    bool isWinningCell = winningLine.contains(index);
    bool isAnimating = _animatingCell == index;
    bool isFilled = board[index] != '';
    
    // Define distinct colors for different states
    Color getBackgroundColor() {
      if (isWinningCell) {
        return winner == 'X' 
            ? const Color(0xFF00E676).withOpacity(0.4)  // Bright green for X wins
            : const Color(0xFFFF6D00).withOpacity(0.4); // Bright orange for O wins
      }
      if (isAnimating) {
        return currentPlayer == 'X'
            ? const Color(0xFF2196F3).withOpacity(0.6)  // Bright blue for X click
            : const Color(0xFFE91E63).withOpacity(0.6); // Bright pink for O click
      }
      if (isFilled) {
        return board[index] == 'X'
            ? const Color(0xFF2196F3).withOpacity(0.2)  // Light blue for X
            : const Color(0xFFE91E63).withOpacity(0.2); // Light pink for O
      }
      return const Color(0xFFF5F5F5); // Light gray for empty
    }
    
    Color getBorderColor() {
      if (isWinningCell) {
        return winner == 'X' 
            ? const Color(0xFF00E676)  // Green border for X wins
            : const Color(0xFFFF6D00); // Orange border for O wins
      }
      if (isAnimating) {
        return currentPlayer == 'X'
            ? const Color(0xFF2196F3)  // Blue border for X click
            : const Color(0xFFE91E63); // Pink border for O click
      }
      if (isFilled) {
        return board[index] == 'X'
            ? const Color(0xFF2196F3)  // Blue border for X
            : const Color(0xFFE91E63); // Pink border for O
      }
      return Colors.grey[300]!; // Gray border for empty
    }
    
    return GestureDetector(
      onTap: () => _makeMove(index),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _cellAnimation, _rotateAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: isAnimating ? _pulseAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: getBackgroundColor(),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: getBorderColor(),
                  width: isWinningCell ? 4 : (isAnimating ? 3 : (isFilled ? 2 : 1)),
                ),
                boxShadow: [
                  if (isFilled || isAnimating)
                    BoxShadow(
                      color: getBorderColor().withOpacity(isAnimating ? 0.8 : 0.4),
                      blurRadius: isAnimating ? 20 : 12,
                      offset: const Offset(0, 6),
                      spreadRadius: isAnimating ? 4 : 2,
                    ),
                ],
              ),
              child: Center(
                child: board[index] == ''
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isAnimating 
                              ? (currentPlayer == 'X' 
                                  ? const Color(0xFF2196F3).withOpacity(0.3)
                                  : const Color(0xFFE91E63).withOpacity(0.3))
                              : Colors.grey[400]?.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAnimating 
                                ? (currentPlayer == 'X' 
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFFE91E63))
                                : Colors.grey[400]!,
                            width: isAnimating ? 2 : 1,
                          ),
                        ),
                      )
                    : Transform.rotate(
                        angle: isAnimating ? _rotateAnimation.value * 3.14159 : 0,
                        child: ScaleTransition(
                          scale: _cellAnimation,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: board[index] == 'X'
                                    ? [const Color(0xFF2196F3), const Color(0xFF1976D2)]  // Blue gradient for X
                                    : [const Color(0xFFE91E63), const Color(0xFFC2185B)], // Pink gradient for O
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (board[index] == 'X' 
                                      ? const Color(0xFF2196F3) 
                                      : const Color(0xFFE91E63)).withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                board[index],
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}