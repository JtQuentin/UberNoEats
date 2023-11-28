@JS()
library stripe;

import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:js/js.dart';

void redirectToCheckout(BuildContext _) async {
  final apiKey = "pk_test_51LZtRSGbza2wD72v0Oo0O0GA1wV0jEwMybrNQhXFhoWhA5rsJvI0ulizFUrLt8SnqT9BOjzUbgSl1G391RuCCJtp00bn1l7qOX";
  final stripe = Stripe(apiKey);
  stripe.redirectToCheckout(
    CheckoutOptions(
        lineItems: [
          LineItem(price: "price_1OHOZRGbza2wD72vLl6asAU6", quantity: 1),
        ],
        mode: 'payment',
        successUrl: window.location.origin,
        cancelUrl: window.location.origin),
  );
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions checkoutOptions);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;
  external String get successUrl;
  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;
  external int get quantity;
  external factory LineItem({String price, int quantity});
}