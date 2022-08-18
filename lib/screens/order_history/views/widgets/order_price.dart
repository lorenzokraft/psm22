import 'package:flutter/material.dart';
import '../../../../common/config.dart';
import '../../../../common/tools/price_tools.dart';
import '../../../../models/entities/index.dart';

class OrderPrice extends StatelessWidget {
  final currencyRate;
  final Order order;
  final bool isTax;
  const OrderPrice(
      {Key? key,
      required this.order,
      required this.currencyRate,
      this.isTax = false})
      : super(key: key);
  const OrderPrice.tax(
      {Key? key,
      required this.order,
      required this.currencyRate,
      this.isTax = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isTax) {
      if (serverConfig['type'] == 'wcfm') {
        return Text(
          PriceTools.getCurrencyFormatted(
              order.lineItems
                  .fold(0, (dynamic sum, e) => sum + double.parse(e.total!)),
              currencyRate)!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }
      return Text(
        PriceTools.getCurrencyFormatted(
            order.total! - 10, currencyRate)!, //****MINUS -10*/
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    if (serverConfig['type'] == 'wcfm') {
      return Text(
          PriceTools.getCurrencyFormatted(
              order.lineItems
                  .fold(0, (dynamic sum, e) => sum + double.parse(e.totalTax!)),
              currencyRate)!,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w700,
              ));
    }
    return Text(
      PriceTools.getCurrencyFormatted(order.totalTax, currencyRate)!,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}
