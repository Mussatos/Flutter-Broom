@JS()
library stripe;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:js/js.dart';

String apiKey =
    'pk_test_51Plexm08Kz6lXWDqBKmn4sBXxiQkiH85DuU3BDV4Zi8Zib7qRKMHviqMn9wwTNiDimlf5TBJ3X2MhXVxQoN1itlm009JR1umMA';

String nikesPriceId = '12';

void redirectToCheckout(BuildContext _) async {
  final stripe = Stripe(apiKey);
  stripe.redirectToCheckout(CheckoutOptions(
      lineIntems: [
        LineItem(price: nikesPriceId, quantity: 1),
      ],
      mode: 'payment',
      successUrl: 'http://localhost:51118/#/List',
      cancelUrl: 'http://localhost:51118/#/account/settings'));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;
  external String get successUrl;
  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineIntems,
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
