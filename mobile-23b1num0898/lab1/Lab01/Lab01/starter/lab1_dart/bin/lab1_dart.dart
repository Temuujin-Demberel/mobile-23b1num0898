// Ажиллуулах: dart run
// Даалгавруудаа хийсний дараа үр дүнг энд харж болно.

import 'package:lab1_dart/lab1_dart.dart';

Future<void> main() async {
  print('--- Даалгавар 1 ---');
  print(describeStudent('Бат', age: 21, major: 'Програм хангамж'));
  print('85 оноо → ${letterGrade(85)}');
  print('Дундаж: ${average([95, 72, 48, 88])}');
  print('Тэнцсэн: ${passedStudents({'Сараа': 91, 'Бат': 58, 'Анар': 74})}');
  final nextId = makeIdGenerator(start: 100);
  print('ID: ${nextId()}, ${nextId()}');

  print('\n--- Даалгавар 2, 5 ---');
  print(await loadProductsMessage(ProductService()));
  final products = await ProductService().fetchProducts();
  for (final p in products) {
    final stock = p.inStock ? 'нөөцөд ${p.stock}' : 'дууссан';
    print(
        '${p.title.padRight(20)} ${p.discountedPrice.asPrice.padLeft(8)}  $stock');
  }

  print('\n--- Даалгавар 3 ---');
  final cart = Cart()
    ..add(products[0], quantity: 2)
    ..add(products[2]);
  print('Сагсанд ${cart.totalQuantity} бараа, нийт ${cart.totalPrice.asPrice}');
  try {
    cart.add(products[1]); // нөөц 0
  } on OutOfStockException catch (e) {
    print('Анхааруулга: $e');
  }

  print('\n--- Даалгавар 4 ---');
  for (final s in OrderStatus.values) {
    final next = s.next?.label ?? '—';
    print(
        '${s.label.padRight(18)} → $next  (цуцлах боломжтой: ${s.canCancel})');
  }

  print('\n--- Хайлт: "wat" ---');
  print(await ProductService().searchProducts('wat'));
}
