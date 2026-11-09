// Ажиллуулах: dart test
// Даалгавар бүрийг хийх тусам амжилттай (✓) тестийн тоо нэмэгдэнэ.
// Тестийг ӨӨРЧЛӨХГҮЙ байна уу.

import 'package:lab1_dart/lab1_dart.dart';
import 'package:test/test.dart';

const headphones = Product(
    id: 1, title: 'Headphones', price: 60, discountPercentage: 10, stock: 5);
const lamp = Product(id: 5, title: 'Lamp', price: 25, stock: 2);
const watch = Product(id: 2, title: 'Watch', price: 120, stock: 0);

void main() {
  group('1. Үндэс', () {
    test('1.1 describeStudent', () {
      expect(describeStudent('Бат'), 'Бат');
      expect(describeStudent('Бат', age: 21), 'Бат (21)');
      expect(describeStudent('Бат', major: 'ПХ'), 'Бат — ПХ');
      expect(describeStudent('Бат', age: 21, major: 'ПХ'), 'Бат (21) — ПХ');
    });

    test('1.2 letterGrade', () {
      expect(letterGrade(100), 'A');
      expect(letterGrade(90), 'A');
      expect(letterGrade(89), 'B');
      expect(letterGrade(70), 'C');
      expect(letterGrade(60), 'D');
      expect(letterGrade(59), 'F');
      expect(letterGrade(0), 'F');
      expect(() => letterGrade(101), throwsArgumentError);
      expect(() => letterGrade(-1), throwsArgumentError);
    });

    test('1.3 average', () {
      expect(average([]), 0.0);
      expect(average([80, 90]), 85.0);
      expect(average([1, 2]), 1.5);
    });

    test('1.4 passedStudents', () {
      final scores = {'Сараа': 91, 'Бат': 58, 'Анар': 60, 'Болд': 74};
      expect(passedStudents(scores), ['Анар', 'Болд', 'Сараа']);
      expect(passedStudents(scores, passMark: 80), ['Сараа']);
      expect(passedStudents({}), isEmpty);
    });

    test('1.5 makeIdGenerator', () {
      final a = makeIdGenerator();
      final b = makeIdGenerator(start: 100);
      expect([a(), a(), a()], [1, 2, 3]);
      expect(b(), 100);
      expect(a(), 4); // тус бүр өөрийн төлөвтэй
    });
  });

  group('2. Product', () {
    final json = {
      'id': 7,
      'title': 'Backpack',
      'description': 'Арьсан',
      'price': 50, // int ирсэн ч double болох ёстой
      'discountPercentage': 12.5,
      'rating': 4.8,
      'stock': 3,
      'category': 'fashion',
      'thumbnail': 'https://example.com/b.png',
    };

    test('2.1 fromJson — бүх талбар', () {
      final p = Product.fromJson(json);
      expect(p.id, 7);
      expect(p.title, 'Backpack');
      expect(p.description, 'Арьсан');
      expect(p.price, 50.0);
      expect(p.discountPercentage, 12.5);
      expect(p.rating, 4.8);
      expect(p.stock, 3);
      expect(p.category, 'fashion');
      expect(p.thumbnail, 'https://example.com/b.png');
    });

    test('2.1 fromJson — дутуу талбарт анхдагч утга', () {
      final p = Product.fromJson({'id': 1, 'title': 'X', 'price': 9.99});
      expect(p.description, '');
      expect(p.discountPercentage, 0);
      expect(p.rating, 0);
      expect(p.stock, 0);
      expect(p.category, '');
      expect(p.thumbnail, '');
    });

    test('2.2 toJson ↔ fromJson', () {
      final p = Product.fromJson(json);
      final back = Product.fromJson(p.toJson());
      expect(back.toJson(), p.toJson());
      expect(p.toJson()['price'], 50.0);
      expect(p.toJson().keys, containsAll(['id', 'title', 'price', 'stock']));
    });

    test('2.3 discountedPrice', () {
      expect(headphones.discountedPrice, 54.0);
      expect(Product.fromJson(json).discountedPrice, 43.75);
      expect(lamp.discountedPrice, 25.0);
      expect(
          const Product(id: 9, title: 'Y', price: 19.99, discountPercentage: 15)
              .discountedPrice,
          16.99);
    });

    test('2.4 inStock', () {
      expect(headphones.inStock, isTrue);
      expect(watch.inStock, isFalse);
    });

    test('2.5 copyWith', () {
      final cheaper = headphones.copyWith(price: 40);
      expect(cheaper.price, 40.0);
      expect(cheaper.stock, headphones.stock);
      expect(cheaper.title, headphones.title);
      expect(cheaper.discountPercentage, headphones.discountPercentage);
      expect(headphones.price, 60.0); // эх объект өөрчлөгдөхгүй
      expect(headphones.copyWith(stock: 0).inStock, isFalse);
    });

    test('2.6 asPrice', () {
      expect(12.5.asPrice, r'$12.50');
      expect(0.0.asPrice, r'$0.00');
      expect(1234.567.asPrice, r'$1234.57');
    });
  });

  group('3. Cart', () {
    late Cart cart;
    setUp(() => cart = Cart());

    test('3.1 CartItem.subtotal', () {
      expect(const CartItem(headphones, 2).subtotal, 108.0);
    });

    test('3.2–3.4 add, totalQuantity, totalPrice', () {
      expect(cart.isEmpty, isTrue);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0.0);
      cart.add(headphones);
      cart.add(headphones, quantity: 2);
      cart.add(lamp);
      expect(cart.items.length, 2);
      expect(cart.totalQuantity, 4);
      expect(cart.totalPrice, 187.0); // 54 × 3 + 25
    });

    test('3.4 нөөцөөс хэтрэхэд OutOfStockException, сагс өөрчлөгдөхгүй', () {
      cart.add(lamp, quantity: 2);
      expect(() => cart.add(lamp), throwsA(isA<OutOfStockException>()));
      expect(() => cart.add(watch), throwsA(isA<OutOfStockException>()));
      expect(cart.totalQuantity, 2);
    });

    test('3.4 буруу тоо ширхэг', () {
      expect(() => cart.add(lamp, quantity: 0), throwsArgumentError);
      expect(() => cart.add(lamp, quantity: -1), throwsArgumentError);
      expect(cart.isEmpty, isTrue);
    });

    test('3.5 decrease, remove, clear', () {
      cart.add(headphones, quantity: 2);
      cart.add(lamp);
      cart.decrease(headphones.id);
      expect(cart.totalQuantity, 2);
      cart.decrease(lamp.id);
      expect(cart.items.map((i) => i.product.id), [headphones.id]);
      cart.decrease(999); // байхгүй бараа — алдаагүй
      cart.remove(headphones.id);
      expect(cart.isEmpty, isTrue);
    });

    test('items-ийг гаднаас өөрчлөх боломжгүй', () {
      cart.add(lamp);
      expect(() => cart.items.add(const CartItem(watch, 1)),
          throwsUnsupportedError);
    });
  });

  group('4. OrderStatus', () {
    test('4.1 next', () {
      expect(OrderStatus.pending.next, OrderStatus.paid);
      expect(OrderStatus.paid.next, OrderStatus.shipped);
      expect(OrderStatus.shipped.next, OrderStatus.delivered);
      expect(OrderStatus.delivered.next, isNull);
      expect(OrderStatus.cancelled.next, isNull);
    });

    test('4.2 canCancel', () {
      expect(
        OrderStatus.values.where((s) => s.canCancel),
        [OrderStatus.pending, OrderStatus.paid],
      );
    });
  });

  group('5. Async', () {
    final fast = ProductService(delay: Duration.zero);

    test('5.1 fetchProducts', () async {
      final products = await fast.fetchProducts();
      expect(products.length, 5);
      expect(products.first.title, 'Wireless Headphones');
      expect(products[1].price, 120.0);
      expect(products[3].description, '');
    });

    test('5.1 fetchProducts нь delay-г хүлээдэг', () async {
      final sw = Stopwatch()..start();
      await ProductService(delay: const Duration(milliseconds: 200))
          .fetchProducts();
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(150));
    });

    test('5.1 shouldFail үед алдаа шиднэ', () {
      expect(
        ProductService(delay: Duration.zero, shouldFail: true).fetchProducts(),
        throwsException,
      );
    });

    test('5.2 searchProducts', () async {
      expect((await fast.searchProducts('WATCH')).map((p) => p.id), [2]);
      expect((await fast.searchProducts('s')).length, 4);
      expect((await fast.searchProducts('  ')).length, 5);
      expect(await fast.searchProducts('iphone'), isEmpty);
    });

    test('5.3 loadProductsMessage', () async {
      expect(await loadProductsMessage(fast), 'Ачааллаа: 5 бараа');
      expect(
        await loadProductsMessage(
            ProductService(delay: Duration.zero, shouldFail: true)),
        'Алдаа: Exception: Сүлжээний алдаа',
      );
    });
  });
}
