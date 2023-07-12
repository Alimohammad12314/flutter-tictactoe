import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  String _currentPlayer = 'X';
  bool _gameOver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
        toolbarHeight: 80.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _makeMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 9,
            ),
          ],
        ),
      ),
    );
  }

  void _makeMove(int row, int col) {
    if (!_gameOver && _board[row][col].isEmpty) {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkGameOver(row, col);
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      });
    }
  }

  void _checkGameOver(int row, int col) {
    if (_checkRow(row) || _checkColumn(col) || _checkDiagonal() || _checkAntiDiagonal()) {
      _showGameOverDialog('Player $_currentPlayer wins!');
    } else if (_checkDraw()) {
      _showGameOverDialog('It\'s a draw!');
    }
  }

  bool _checkRow(int row) {
    return _board[row][0] == _currentPlayer &&
        _board[row][1] == _currentPlayer &&
        _board[row][2] == _currentPlayer;
  }

  bool _checkColumn(int col) {
    return _board[0][col] == _currentPlayer &&
        _board[1][col] == _currentPlayer &&
        _board[2][col] == _currentPlayer;
  }

  bool _checkDiagonal() {
    return _board[0][0] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][2] == _currentPlayer;
  }

  bool _checkAntiDiagonal() {
    return _board[0][2] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][0] == _currentPlayer;
  }

  bool _checkDraw() {
    for (var row in _board) {
      if (row.contains('')) {
        return false;
      }
    }
    return true;
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                setState(() {
                  _board = List.generate(3, (_) => List.filled(3, ''));
                  _currentPlayer = 'X';
                  _gameOver = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    _gameOver = true;
  }
}