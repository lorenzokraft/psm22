class PaymentConfig {
  String? defaultCountryISOCode;
  String? defaultStateISOCode;
  bool enableShipping = false;
  bool enableAddress = false;
  bool enableCustomerNote = false;
  bool enableAddressLocationNote = false;
  bool enableAlphanumericZipCode = false;
  bool enableReview = false;
  bool allowSearchingAddress = false;
  String googleApiKey = '';
  bool guestCheckout = false;
  bool enableOnePageCheckout = false;
  bool nativeOnePageCheckout = false;
  Map checkoutPageSlug = {'en': 'checkout'};
  bool enableCreditCard = false;
  bool updateOrderStatus = false;
  bool showOrderNotes = false;
  bool enableRefundCancel = false;
  num? refundPeriod;

  PaymentConfig.fromJson(dynamic json) {
    defaultCountryISOCode = json['DefaultCountryISOCode'];
    defaultStateISOCode = json['DefaultStateISOCode'];
    enableShipping = json['EnableShipping'] ?? false;
    enableAddress = json['EnableAddress'] ?? false;
    enableCustomerNote = json['EnableCustomerNote'] ?? false;
    enableAddressLocationNote = json['EnableAddressLocationNote'] ?? false;
    enableAlphanumericZipCode = json['EnableAlphanumericZipCode'] ?? false;
    enableReview = json['EnableReview'] ?? false;
    allowSearchingAddress = json['allowSearchingAddress'] ?? false;
    googleApiKey = json['GoogleApiKey'] ?? '';
    guestCheckout = json['GuestCheckout'] ?? false;
    enableOnePageCheckout = json['EnableOnePageCheckout'] ?? false;
    nativeOnePageCheckout = json['NativeOnePageCheckout'] ?? false;
    checkoutPageSlug = json['CheckoutPageSlug'] ?? {'en': 'checkout'};
    enableCreditCard = json['EnableCreditCard'] ?? false;
    updateOrderStatus = json['UpdateOrderStatus'] ?? false;
    showOrderNotes = json['ShowOrderNotes'] ?? false;
    enableRefundCancel = json['EnableRefundCancel'] ?? false;
    refundPeriod = json['RefundPeriod'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['DefaultCountryISOCode'] = defaultCountryISOCode;
    map['DefaultStateISOCode'] = defaultStateISOCode;
    map['EnableShipping'] = enableShipping;
    map['EnableAddress'] = enableAddress;
    map['EnableCustomerNote'] = enableCustomerNote;
    map['EnableAddressLocationNote'] = enableAddressLocationNote;
    map['EnableAlphanumericZipCode'] = enableAlphanumericZipCode;
    map['EnableReview'] = enableReview;
    map['allowSearchingAddress'] = allowSearchingAddress;
    map['GoogleApiKey'] = googleApiKey;
    map['GuestCheckout'] = guestCheckout;
    map['EnableOnePageCheckout'] = enableOnePageCheckout;
    map['NativeOnePageCheckout'] = nativeOnePageCheckout;
    map['CheckoutPageSlug'] = checkoutPageSlug;
    map['EnableCreditCard'] = enableCreditCard;
    map['UpdateOrderStatus'] = updateOrderStatus;
    map['ShowOrderNotes'] = showOrderNotes;
    map['EnableRefundCancel'] = enableRefundCancel;
    map['RefundPeriod'] = refundPeriod;
    return map;
  }
}
