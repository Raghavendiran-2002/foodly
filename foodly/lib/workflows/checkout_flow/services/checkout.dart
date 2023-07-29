import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout {
  final num amount;

  final Function(PaymentResult, {String? paymentID}) paymentResultCallback;

  Checkout({required this.amount, required this.paymentResultCallback});

  bool pay({required PaymentPlatform paymentPlatform}) {
    //returns null if platform doesn't exist, otherwise void
    switch (paymentPlatform) {
      // case PaymentPlatform.RAZORPAY:
      //   checkoutRazorPay();
      //   return true;
      case PaymentPlatform.PAYTM:
        checkoutPaytm();
        return true;
      default:
        return false;
    }
  }

  void checkoutPaytm() {}

  void checkoutRazorPay() {
    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      paymentResultCallback(PaymentResult.SUCCESS,
          paymentID: response.paymentId);
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      paymentResultCallback(PaymentResult.FAILED);
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      //todo: handle external wallet
    }
    Razorpay _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Map<String, dynamic> options = {
      'key': 'rzp_test_SdKUDG33PC8rqV',
      'currency': 'INR',
      'amount': amount * 100, //amount in smallest unit (paise)
      'name': 'Foodly',
      'description': 'Krishna Canteen',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    _razorpay.open(options);
  }
}

enum PaymentResult { SUCCESS, FAILED }

enum PaymentPlatform {
  // RAZORPAY,
  // GOOGLE_PAY,
  PAYTM
}
