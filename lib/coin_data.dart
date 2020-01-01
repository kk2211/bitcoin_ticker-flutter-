import 'package:http/http.dart' as http;
import 'dart:convert';
import 'price_screen.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC', 'ZEC'];
const apiUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker";

//last
class CoinData {
  Future getCoinData(String currency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      var url = "$apiUrl/$crypto$currency";
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        cryptoPrices[crypto] = data["last"].toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
