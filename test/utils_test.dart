import 'package:chess/chess.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("isPromoting", () {
    const fen = "rnbqkbnr/pP2pppp/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 1 5";
    final chess = Chess.fromFEN(fen);

    test("isPromoting returns true if promoting", () {
      expect(
        isPromoting(chess, ShortMove(from: "b7", to: "a8")),
        isTrue,
      );
    });

    test("isPromoting returns false not if promoting", () {
      expect(
        isPromoting(chess, ShortMove(from: "a2", to: "a3")),
        isFalse,
      );
    });

    test("piece destinations are correct", () {
      expect(
        generateDestinations(Chess()).entries
          .fold<int>(0, (x, entry) => x + entry.value.length),
        equals(20)
      );
    });
  });
}
