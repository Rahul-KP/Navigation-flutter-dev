// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:AmbiNav/what3words_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:here_sdk/core.dart';

void main() {
  test('What3words API call should be sucessfull', () async {
    W3Words obj = W3Words();
    String received =
        await obj.convertToWords(GeoCoordinates(12.9246332, 77.5581978));
    expect(received, 'regal.graceful.defrost');
  });
}
