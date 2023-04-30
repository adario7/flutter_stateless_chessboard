import 'package:chess/chess.dart' show Chess;
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/piece.dart';
import 'package:flutter_stateless_chessboard/models/piece_type.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:provider/provider.dart';

import '../models/square.dart';

class UISquareLayer extends StatefulWidget {
  const UISquareLayer({Key? key}) : super(key: key);

  @override
  State<UISquareLayer> createState() => _UISquareLayerState();
}

class _UISquareLayerState extends State<UISquareLayer> {
  Option<HalfMove> clickMove = Option.none();

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);

    return Stack(
      children: board.squares
        .map((it) => UISquare(
          square: it,
          onClick: (m) => handleClick(board, m),
          onDrop: (hf) => handleDrop(board, hf),
          setClickMove: setClickMove,
          highlight: getHighlight(board, it)
        ))
        .toList(growable: false),
    );
  }

  Color? getHighlight(Board board, Square square) {
    List<Option<Color>> queue = [
      clickMove.filterMap((click) => Option.fromPredicate(
        board.selectionHighlightColor,
        (_) => click.square == square.name
      )),
      clickMove.filterMap((click) => Option.fromPredicate(
        board.selectionDestColor,
        (_) => (board.dests[click.square] ?? []).contains(square.name)
      )),
      Option.fromPredicate(
        board.lastMoveHighlightColor,
        (_) => board.lastMove.contains(square.name),
      ),
      Option.fromPredicate(
        board.checkColor,
        (_)  {
          final pc = square.piece.toNullable();
          if (pc?.type != PieceType.KING) return false; // don't calculate fromFEN when not needed
          final chess = Chess.fromFEN(board.fen);
          return pc?.color.value == chess.turn.index && chess.in_check;
        }
      )
    ];
    return queue.reduce((a, b) => a.alt(() => b)).toNullable();
  }

  void handleDrop(Board board, ShortMove move) {
    board.makeMove(move).then((_) {
      clearClickMove();
    });
  }

  void handleClick(Board board, HalfMove halfMove) {
    clickMove.match(
      () => setClickMove(Option.of(halfMove)),
      (t) {
        final sameSquare = t.square == halfMove.square;
        final sameColorPiece = t.piece
            .map2<Piece, bool>(halfMove.piece, (t, r) => t.color == r.color)
            .getOrElse(() => false);

        if (sameSquare) {
          clearClickMove();
        } else if (sameColorPiece) {
          setClickMove(Option.of(halfMove));
        } else {
          board.makeMove(ShortMove(
            from: t.square,
            to: halfMove.square,
          ));
          clearClickMove();
        }
      },
    );
  }

  void setClickMove(Option<HalfMove> halfMove) {
    setState(() {
      clickMove = halfMove.filter((t) => t.piece.isSome());
    });
  }

  void clearClickMove() => setClickMove(Option.none());
}
