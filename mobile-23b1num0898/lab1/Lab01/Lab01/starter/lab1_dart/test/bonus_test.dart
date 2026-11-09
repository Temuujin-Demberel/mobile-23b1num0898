// БОНУС даалгаврын тест: dart test test/bonus_test.dart

import 'package:lab1_dart/lab1_dart.dart';
import 'package:test/test.dart';

void main() {
  test('B1 trackOrder', () async {
    final steps =
        await trackOrder(OrderStatus.paid, step: Duration.zero).toList();
    expect(
        steps, [OrderStatus.paid, OrderStatus.shipped, OrderStatus.delivered]);
    expect(
        await trackOrder(OrderStatus.cancelled, step: Duration.zero).toList(),
        [OrderStatus.cancelled]);
  });
}
