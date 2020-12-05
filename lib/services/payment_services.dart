import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
class StripeTransactionResponse{
  String messege;
  bool success;
  StripeTransactionResponse({this.messege,this.success});
}

class StripeService{
  static String apiBase = 'https://api.stripe.com//v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51HuvG6AcgZpDPvGNZsy8GaJC39jfWYIIWlQtqp1Vz0iwjefweDv8fyuwHnf6SGb94KSFG1KePR9Jtn6BbkMmFb0P00ICvSxoJK';
  static Map<String,String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type':'application/x-www-form-urlencoded'
  };
  static init(){
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_test_51HuvG6AcgZpDPvGN5gz6kaeAE60RbwyXIhB4FsFwRzQIdzt3nyNR28LaIBAu1Pmz3u3wxKQtxjji33Or2xPctvbk00KRxdnQKO",
            merchantId: "Test",
            androidPayMode: 'test'));

  }

  static Future<StripeTransactionResponse> payViaExistingCard({String amount,String currency,CreditCard card})async{
    try {
      var paymentMethod =  await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
      var paymentIntent =  await StripeService.createPaymentIntent(amount,currency);
      print('PAYMENT'+paymentIntent.toString());
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(clientSecret: paymentIntent['client_secret'],paymentMethodId: paymentMethod.id));

      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
            messege: 'Transaction Successfull',
            success: true
        );
      }else{
        return new StripeTransactionResponse(
            messege: 'Transaction Failed',
            success: false
        );
      }
    }on PlatformException catch(error){
      return new StripeTransactionResponse(

          messege: error.code == 'cancelled'? 'Transaction Canceled' :'Transaction Failed',
          success: false
      );
    } catch(error){
      print('ERROR'+error.toString());
      return new StripeTransactionResponse(

          messege: 'Transaction Failed',
          success: false
      );
    }
  }

  static Future<StripeTransactionResponse> payViaNewCard({String amount,String currency})async{
    try {
      var paymentMethod =  await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var paymentIntent =  await StripeService.createPaymentIntent(amount,currency);
      print('PAYMENT'+paymentIntent.toString());
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(clientSecret: paymentIntent['client_secret'],paymentMethodId: paymentMethod.id));

      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
            messege: 'Transaction Successfull',
            success: true
        );
      }else{
        return new StripeTransactionResponse(
            messege: 'Transaction Failed',
            success: false
        );
      }
      }on PlatformException catch(error){
      return new StripeTransactionResponse(

          messege: error.code == 'cancelled'? 'Transaction Canceled' :'Transaction Failed',
          success: false
      );
    } catch(error){
      print('ERROR'+error.toString());
      return new StripeTransactionResponse(

          messege: 'Transaction Failed',
          success: false
      );
    }
  }

  static Future<Map<String,dynamic>> createPaymentIntent(String amount, String currency)async{
    try{
      Map<String,dynamic> body = {
        'amount': amount,
        'currency':currency,
        'payment_method_types[]':'card'
      };
      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: StripeService.headers
      );
      return jsonDecode(response.body);
    }
    catch(error){}
  }



}