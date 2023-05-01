import 'package:chess/chess.dart' as ch;
import 'package:fpdart/fpdart.dart';

import 'models/board.dart';
import 'models/board_color.dart';
import 'models/piece.dart';
import 'models/piece_type.dart';
import 'models/short_move.dart';
import 'models/square.dart';

List<Square> getSquares(Board board) {
  return ch.Chess.SQUARES.keys.map((squareName) {
    return Square(
      board: board,
      name: squareName,
      piece: Option.fromNullable(board.position.get(squareName)).map(
        (t) => Piece(
          t.color == ch.Color.WHITE ? BoardColor.WHITE : BoardColor.BLACK,
          PieceType.fromString(t.type.toString()),
        ),
      ),
    );
  }).toList(growable: false);
}

bool isPromoting(ch.Chess chess, ShortMove move) {
  final piece = chess.get(move.from);

  if (piece?.type != ch.PieceType.PAWN) {
    return false;
  }

  if (piece?.color != chess.turn) {
    return false;
  }

  if (!["1", "8"].any((it) => move.to.endsWith(it))) {
    return false;
  }

  return chess
      .moves({"square": move.from, "verbose": true})
      .map((it) => it["to"])
      .contains(move.to);
}

noop1(arg1) {}

Future<PieceType?> defaultPromoting() => Future.value(PieceType.QUEEN);
