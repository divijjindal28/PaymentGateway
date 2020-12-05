import 'package:flutter/material.dart';
import 'package:payment_gateway/existingCard.dart';
import 'package:payment_gateway/services/payment_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'HomePage'),
      routes: {
        existingCard.route: (context)=> existingCard()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    StripeService.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    void cardOptionChoose(BuildContext c, int index)async{
      switch(index){
        case 0:

          var response = await StripeService.payViaNewCard(amount: '150',currency: 'INR');
          if(response.success == true){
            Scaffold.of(c).showSnackBar(SnackBar(content: Text('Payment done'),duration: new Duration(milliseconds: 1200),));
          }else{
            Scaffold.of(c).showSnackBar(SnackBar(content: Text('Payment Error'),duration: new Duration(milliseconds: 1200),));

          }
          break;
        case 1:

          Navigator.of(context).pushNamed(existingCard.route);

          break;

      }
    }
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.separated(
            itemCount: 2,
            separatorBuilder: (context,index)=> Divider(),
            itemBuilder: (context,index){
              Text title;
              Icon icon;
              switch(index){
                case 0:
                  title = Text('New Card');
                  icon = Icon(Icons.add);
                  break;
                case 1:
                  title = Text('Choose Existing Card');
                  icon = Icon(Icons.credit_card_sharp);
                  break;

              }
              return ListTile(
                title: title,
                leading: icon,
                onTap:()=> cardOptionChoose(context,index),
              );
            },
          ),
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
