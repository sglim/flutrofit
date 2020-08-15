import 'package:test/test.dart';

import 'package:flutrofit/flutrofit.dart';

void main() {
  group('Get annotation', () {
    test('must have a non-null name', () {
      expect(() => Get(null), throwsA(TypeMatcher<AssertionError>()));
    });

    test('does not need to have a todoUrl', () {
      final api = Get('path', res: 'res');
      expect(api.path, 'path');
      expect(api.res, 'res');
    });
  });
}
