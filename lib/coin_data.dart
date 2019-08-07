import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitcoinAverageURL =
    'http://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future<dynamic> getCoinData(symbol) async {
    var response = await http.get('$bitcoinAverageURL/$symbol');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('response failed, status ${response.statusCode}');
      return null;
    }
  }
}
