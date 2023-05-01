import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:chess/chess.dart' show Chess, Move;
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/board_arrow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chess Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String? makeMove(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);
  if (chess.move(move)) {
    return chess.fen;
  }
  return null;
}

Move? getRandomMove(String fen) {
  final chess = Chess.fromFEN(fen);
  final moves = chess.moves({ 'asObjects': true });
  if (moves.isEmpty) return null;
  moves.shuffle();
  return moves.first;
}

class _HomePageState extends State<HomePage> {
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  List<String> _lastMove = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chess Demo"),
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) => Chessboard(
          fen: _fen,
          lastMove: _lastMove,
          size: min(constraints.maxWidth, constraints.maxHeight),
          orientation: BoardColor.WHITE,
          arrows: const [
              BoardArrow(from: 'g1', to: 'f3', color: Color.fromRGBO(60, 60, 255, .4),),
              BoardArrow(from: 'b2', to: 'b4', color: Color.fromRGBO(20, 180, 20, .4),),
              BoardArrow(from: 'd8', to: 'h4', color: Color.fromRGBO(60, 60, 255, .4),),
          ],
          onMove: (move) {
            final nextFen = makeMove(_fen, {
              'from': move.from,
              'to': move.to,
              'promotion': move.promotion.toNullable()?.name,
            });
            if (nextFen == null) return;

            setState(() {
              _fen = nextFen;
              _lastMove = [move.from, move.to];
            });

            Future.delayed(const Duration(milliseconds: 500)).then((_) {
              final nextMove = getRandomMove(_fen);
              if (nextMove == null) return;
              setState(() {
                _fen = makeMove(_fen, nextMove) ?? _fen;
                _lastMove = [nextMove.fromAlgebraic, nextMove.toAlgebraic];
              });
            });
          },
        ),
      ),
      )
    );
  }
}

