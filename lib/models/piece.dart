import 'board_color.dart';
import 'piece_type.dart';

class Piece {
  final BoardColor color;
  final PieceType type;

  const Piece(this.color, this.type);

  static const Piece WHITE_PAWN   = Piece(BoardColor.WHITE, PieceType.PAWN);
  static const Piece WHITE_KNIGHT = Piece(BoardColor.WHITE, PieceType.KNIGHT);
  static const Piece WHITE_BISHOP = Piece(BoardColor.WHITE, PieceType.BISHOP);
  static const Piece WHITE_ROOK   = Piece(BoardColor.WHITE, PieceType.ROOK);
  static const Piece WHITE_QUEEN  = Piece(BoardColor.WHITE, PieceType.QUEEN);
  static const Piece WHITE_KING   = Piece(BoardColor.WHITE, PieceType.KING);

  static const Piece BLACK_PAWN   = Piece(BoardColor.BLACK, PieceType.PAWN);
  static const Piece BLACK_KNIGHT = Piece(BoardColor.BLACK, PieceType.KNIGHT);
  static const Piece BLACK_BISHOP = Piece(BoardColor.BLACK, PieceType.BISHOP);
  static const Piece BLACK_ROOK   = Piece(BoardColor.BLACK, PieceType.ROOK);
  static const Piece BLACK_QUEEN  = Piece(BoardColor.BLACK, PieceType.QUEEN);
  static const Piece BLACK_KING   = Piece(BoardColor.BLACK, PieceType.KING);

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(color, type);

  @override
  String toString() => '$color$type';
}
