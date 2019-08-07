import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, double> coinPrices = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getData();
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData();
      },
      children: pickerItems,
    );
  }

//  Widget getPicker() {
//    if (Platform.isIOS) {
//      return iOSPicker();
//    } else if (Platform.isAndroid) {
//      return androidDropdown();
//    }
//  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      for (int i = 0; i < cryptoList.length; ++i) {
        var coinData =
            await CoinData().getCoinData(cryptoList[i] + selectedCurrency);
        setState(() {
          coinPrices[cryptoList[i] + selectedCurrency] = coinData['last'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getConvertedValueBars() {
    List<Widget> convertedValueBars = [];

    for (int i = 0; i < cryptoList.length; ++i) {
      convertedValueBars.add(ConvertedValueBar(
          coinPrice: coinPrices[cryptoList[i] + selectedCurrency] != null
              ? coinPrices[cryptoList[i] + selectedCurrency].toString()
              : '?',
          targetCurrency: cryptoList[i],
          selectedCurrency: selectedCurrency));
    }
    return convertedValueBars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getConvertedValueBars(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          )
        ],
      ),
    );
  }
}

class ConvertedValueBar extends StatelessWidget {
  ConvertedValueBar(
      {@required this.coinPrice,
      @required this.targetCurrency,
      @required this.selectedCurrency});
  final String coinPrice;
  final String targetCurrency;
  final String selectedCurrency;

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
            '1 $targetCurrency = $coinPrice $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
