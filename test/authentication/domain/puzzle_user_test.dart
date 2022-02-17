import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';

void main() {
  test('Puzzle User is Equatable', () {
    const user = PuzzleUser(id: 'id', username: 'username');
    expect(
      user.props,
      [
        'id',
        'username',
      ],
    );
  });
}
