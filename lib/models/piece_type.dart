class PieceType {
  final String name;

  const PieceType._value(this.name);

  static const PieceType PAWN = PieceType._value('p');
  static const PieceType KNIGHT = PieceType._value('n');
  static const PieceType BISHOP = PieceType._value('b');
  static const PieceType ROOK = PieceType._value('r');
  static const PieceType QUEEN = PieceType._value('q');
  static const PieceType KING = PieceType._value('k');

  factory PieceType.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'p':
        return PieceType.PAWN;
      case 'n':
        return PieceType.KNIGHT;
      case 'b':
        return PieceType.BISHOP;
      case 'r':
        return PieceType.ROOK;
      case 'q':
        return PieceType.QUEEN;
      case 'k':
        return PieceType.KING;
      default:
        throw "Unknown piece type";
    }
  }

  String toLowerCase() => name;

  String toUpperCase() => name.toUpperCase();

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
