class BoardColor {
  final int value;

  const BoardColor._value(this.value);

  static const BoardColor WHITE = BoardColor._value(0);
  static const BoardColor BLACK = BoardColor._value(1);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => (this == WHITE) ? 'w' : 'b';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }
}
