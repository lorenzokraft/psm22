import 'dart:async';

import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel;
import '../../../models/order/order.dart';
import '../../../services/index.dart';
import '../../../widgets/common/box_comment.dart';
import '../../../widgets/common/webview.dart';
import '../../../widgets/html/index.dart';
import '../../base_screen.dart';
import '../models/order_history_detail_model.dart';
import 'widgets/order_price.dart';
import 'widgets/product_order_item.dart';

const bool enableOrderNoteHtml = false;

class OrderHistoryDetailScreen extends StatefulWidget {
  const OrderHistoryDetailScreen();

  @override
  _OrderHistoryDetailScreenState createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState
    extends BaseScreen<OrderHistoryDetailScreen> {
  OrderHistoryDetailModel get orderHistoryModel =>
      Provider.of<OrderHistoryDetailModel>(context, listen: false);

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);
    // orderHistoryModel.getTracking();
    orderHistoryModel.getOrderNote();
  }

  void cancelOrder() {
    orderHistoryModel.cancelOrder();
  }

  void _onNavigate(context, OrderHistoryDetailModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebView(
          url:
              "${afterShip['tracking_url']}/${model.order.aftershipTracking!.slug}/${model.order.aftershipTracking!.trackingNumber}",
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            title: Text(S.of(context).trackingPage),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyRate = Provider.of<AppModel>(context).currencyRate;

    return Consumer<OrderHistoryDetailModel>(builder: (context, model, child) {
      final order = model.order;

      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: [
            Center(child: Services().widget.reOrderButton(order)),
          ],
          title: Text(
            S.of(context).orderNo + ' #${order.number}',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...List.generate(
                order.lineItems.length - 1,
                (index) {
                  final _item = order.lineItems[index];
                  return ProductOrderItem(
                    orderId: order.id!,
                    orderStatus: order.status!,
                    product: _item,
                    index: index,
                    storeDeliveryDates: order.storeDeliveryDates,
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    if (order.deliveryDate != null &&
                        order.storeDeliveryDates == null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Text(S.of(context).expectedDeliveryDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    )),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.deliveryDate!,
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    if (order.paymentMethodTitle != null &&
                        order.paymentMethodTitle!.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(S.of(context).paymentMethod,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.paymentMethodTitle!,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          )
                        ],
                      ),
                    if (order.paymentMethodTitle != null &&
                        order.paymentMethodTitle!.isNotEmpty)
                      const SizedBox(height: 10),
                    (order.shippingMethodTitle != null &&
                            kPaymentConfig['EnableShipping'] &&
                            order.shippingMethodTitle!.isNotEmpty)
                        ? Row(
                            children: <Widget>[
                              Text(S.of(context).shippingMethod,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                      )),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order.shippingMethodTitle!,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    if (order.totalShipping != null) const SizedBox(height: 10),
                    if (order.totalShipping != null)
                      Row(
                        children: <Widget>[
                          Text(S.of(context).shipping,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              PriceTools.getCurrencyFormatted(
                                  order.totalShipping, currencyRate)!,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          )
                        ],
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          S.of(context).subtotal,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        Text(
                          PriceTools.getCurrencyFormatted(
                              order.lineItems.fold(
                                  0,
                                  (dynamic sum, e) =>
                                      sum + double.parse(e.total ?? '0')),
                              currencyRate)!,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        )
                      ],
                    ),
                    if (order.lineItems.last.taxReason != null &&
                        order.lineItems.last.taxReason!.isNotEmpty)
                      const SizedBox(height: 10),
                    if (order.lineItems.last.taxReason != null &&
                        order.lineItems.last.taxReason!.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(order.lineItems.last.taxReason!,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              PriceTools.getCurrencyFormatted(
                                  order.lineItems.last.taxTotal!,
                                  currencyRate)!,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          )
                        ],
                      ),
                    if (order.paymentMethodTitle != null &&
                        order.paymentMethodTitle!.isNotEmpty)
                      const SizedBox(height: 10),
                    if (order.paymentMethodTitle != null &&
                        order.paymentMethodTitle!.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(S.of(context).paymentMethod,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.paymentMethodTitle!,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          )
                        ],
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          S.of(context).totalTax,
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        OrderPrice.tax(
                            order: order, currencyRate: currencyRate),
                      ],
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          S.of(context).total,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        OrderPrice(
                          order: order,
                          currencyRate: currencyRate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (model.order.aftershipTracking != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () => _onNavigate(context, model),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          Text('${S.of(context).trackingNumberIs} '),
                          Text(
                            model.order.aftershipTracking!.trackingNumber!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              Services().widget.renderOrderTimelineTracking(context, order),
              const SizedBox(height: 20),

              /// Render the Cancel and Refund
              if (kPaymentConfig['EnableRefundCancel'])
                Services()
                    .widget
                    .renderButtons(context, order, cancelOrder, refundOrder),

              const SizedBox(height: 20),

              if (order.billing != null) ...[
                Text(S.of(context).shippingAddress,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  ((order.billing!.apartment?.isEmpty ?? true)
                          ? ''
                          : '${order.billing!.apartment} ') +
                      ((order.billing!.block?.isEmpty ?? true)
                          ? ''
                          : '${(order.billing!.apartment?.isEmpty ?? true) ? '' : '- '} ${order.billing!.block}, ') +
                      order.billing!.street! +
                      ', ' +
                      order.billing!.city! +
                      ', ' +
                      getCountryName(order.billing!.country),
                ),
              ],
              if (order.status == OrderStatus.processing &&
                  kPaymentConfig['EnableRefundCancel'])
                Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonTheme(
                            height: 45,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: HexColor('#056C99'),
                                ),
                                onPressed: refundOrder,
                                child: Text(
                                    S.of(context).refundRequest.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700))),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              if (kPaymentConfig['ShowOrderNotes'] ?? true)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Builder(
                    builder: (context) {
                      final listOrderNote = model.listOrderNote;
                      if (listOrderNote?.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.of(context).orderNotes,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                listOrderNote!.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CustomPaint(
                                          painter: BoxComment(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 15,
                                                  bottom: 25),
                                              child: enableOrderNoteHtml
                                                  ? HtmlWidget(
                                                      listOrderNote[index]
                                                          .note!,
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              height: 1.2),
                                                    )
                                                  : Linkify(
                                                      text: listOrderNote[index]
                                                          .note!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          height: 1.2),
                                                      onOpen: (link) async {
                                                        await Tools.launchURL(
                                                            link.url);
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          formatTime(DateTime.parse(
                                              listOrderNote[index]
                                                  .dateCreated!)),
                                          style: const TextStyle(fontSize: 13),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

              const SizedBox(height: 50)
            ],
          ),
        ),
      );
    });
  }

  String getCountryName(country) {
    try {
      return CountryPickerUtils.getCountryByIsoCode(country).name;
    } catch (err) {
      return country;
    }
  }

  Future<void> refundOrder() async {
    _showLoading();
    try {
      await orderHistoryModel.createRefund();
      _hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).refundOrderSuccess)));
    } catch (err) {
      _hideLoading();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).refundOrderFailed)));
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                kLoadingWidget(context),
                // const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(S.of(context).cancel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }

  String formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy, HH:mm').format(time);
  }
}
