import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:payment_gateway/services/payment_services.dart';
import 'package:stripe_payment/stripe_payment.dart';

class existingCard extends StatelessWidget {
  static const route= '.\existing_card';

  void payViaExistingCard(BuildContext context,var card) async{
    var expiryData = card['expiryDate'].split('/');
    CreditCard stripecard=CreditCard(
      number: card['cardNumber'],
      expMonth: expiryData[0],
      expYear: expiryData[1]
    );
    await showDialog()
    var response =await StripeService.payViaExistingCard(amount: '150',currency: 'USD',card: stripecard);
    if(response.success == true){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Payment done'),duration: new Duration(milliseconds: 1200),)).closed.then((_)=>Navigator.pop(context));
    }

  }
  @override
  Widget build(BuildContext context) {
    List card = [{
      'cardNumber': '4000056655665556',
      'expiryDate': '04/23',
      'cardHolderName': 'Divij',
      'cvvCode': '123',
      'showBackView': false,
    },
      {
        'cardNumber': '6011000990139424',
        'expiryDate': '02/21',
        'cardHolderName': 'Raghav',
        'cvvCode': '321',
        'showBackView': false,
      }];
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Existing Card'),

      ),
      body:ListView.builder(
        itemCount: 2,
        itemBuilder: (context,index){
          var currentCard = card[index];
            return InkWell(
              onTap:()=> payViaExistingCard(context,card),
              child: CreditCardWidget(
                cardNumber: currentCard['cardNumber'],
                expiryDate: currentCard['expiryDate'],
                cardHolderName: currentCard['cardHolderName'],
                cvvCode: currentCard['cvvCode'],
                showBackView: currentCard['showBackView'], //true when you want to show cvv(back) view
              ),
            );}
      ) ,
    );
  }
}
