import 'package:bitcoin_ticker/coin_data.dart' as prefix0;
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  String displayCurrency = "USD";

  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var d_menu = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      dropDownItems.add(d_menu);
    }
    return dropDownItems;
  }

  Map<String, String> Coinvalue = {};
  bool isWaiting = false;

  void getData(selectedCurrency) async {
    isWaiting = true;
    try {
      var data = await prefix0.CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        Coinvalue = data;
        displayCurrency = selectedCurrency;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];

    for (String crypto in prefix0.cryptoList) {
      cryptoCards.add(CryptoCard(
        cryptoCurrency: crypto,
        selectedCurrency: selectedCurrency,
        value: isWaiting ? '  ' : Coinvalue[crypto],
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Coin Ticker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 1,
            ),
            makeCards(),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: DropdownButton<String>(
                iconEnabledColor: Colors.black54,
                isDense: false,
                value: selectedCurrency,
                items: getDropdownItems(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value;
                    getData(selectedCurrency);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
