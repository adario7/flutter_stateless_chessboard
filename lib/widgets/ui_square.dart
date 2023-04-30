import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/models/square.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_tile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

class UISquare extends StatelessWidget {
  final Square square;
  final Color? highlight;
  final void Function(ShortMove move) onDrop;
  final void Function(HalfMove move) onClick;
  final void Function(Option<HalfMove> move) setClickMove;

  const UISquare({Key? key, 
    required this.square,
    required this.onClick,
    required this.onDrop,
    required this.setClickMove,
    this.highlight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: square.x,
      top: square.y,
      width: square.size,
      height: square.size,
      child: _buildSquare(context),
    );
  }

  Widget _buildSquare(BuildContext context) {
    final board = Provider.of<Board>(context);
    return DragTarget<HalfMove>(
      onWillAccept: (data) {
        return data?.square != square.name;
      },
      onAccept: (data) {
        onDrop(ShortMove(
          from: data.square,
          to: square.name,
        ));
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTapUp: (TapUpDetails details) => onClick(HalfMove(square.name, square.piece)),
          child: InkWell(
            onTapDown: (TapDownDetails details) => onClick(HalfMove(square.name, square.piece)),
            child: Stack(
              children: [
                UITile(
                  color: square.color,
                  size: square.size,
                ),
                if (highlight != null)
                  Container(
                    color: highlight,
                    height: square.size,
                    width: square.size,
                  ),
                board.buildCustomPiece
                  .flatMap((t) => Option.fromNullable(t(square)))
                  .alt(() => square.piece.map((t) => UIPiece(
                    squareName: square.name,
                    squareColor: square.color,
                    piece: t,
                    size: square.size,
                    setClickMove: setClickMove,
                  )))
                  .getOrElse(() => const SizedBox())
              ],
            ),
          ),
        );
      },
    );
  }
}
