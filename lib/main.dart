import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MaterialApp(home: RazorpayTestApp()));

class RazorpayTestApp extends StatefulWidget {
  @override
  _RazorpayTestAppState createState() => _RazorpayTestAppState();
}

class _RazorpayTestAppState extends State<RazorpayTestApp> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_RXEfPSF821beBuRTR', //added riggedd key for github
      'amount': 50000, // in paise = ₹500
      'name': 'Demo App',
      'description': 'Trial Payment',
      'prefill': {'contact': '7507600113', 'email': 'demo@example.com'},
      'external': {
        'wallets': ['paytm', 'googlepay', 'cred'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Selected: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Razorpay Test Payment")),
      body: Center(
        child: ElevatedButton(onPressed: openCheckout, child: Text("Pay ₹500")),
      ),
    );
  }
}
