import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final double _minimumPadding = 5.0;

  var _currentItemSelected = '';
  var formKey = GlobalKey<FormState>();
  String? _principleErrorText = null;
  String? _roiErrorText = null;
  String? _termErrorText = null;

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (String? value) {
                        setState(() {
                          if (value!.isEmpty) {
                            _principleErrorText =
                            'Please enter principle amount.';
                          }
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Principal',
                          hintText: 'Enter Principal e.g. 12000',
                          labelStyle: textStyle,
                          errorText: _principleErrorText,
                          errorStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: roiController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (String? value) {
                        setState(() {
                          if (value!.isEmpty) {
                            _roiErrorText =
                            'Please enter the rate of interest.';
                          }
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Rate of Interest',
                          hintText: 'In percent',
                          labelStyle: textStyle,
                          errorText: _roiErrorText,
                          errorStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              controller: termController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (String? value) {
                                setState(() {
                                  if (value!.isEmpty) {
                                    _termErrorText = 'Please enter the term.';
                                  }
                                });
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Term',
                                  hintText: 'Time in years',
                                  labelStyle: textStyle,
                                  errorText: _termErrorText,
                                  errorStyle: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0))),
                            )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                              items: _currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: _currentItemSelected,
                              onChanged: (String? newValueSelected) {
                                // Your code to execute, when a menu item is selected from dropdown
                                _onDropDownItemSelected(newValueSelected!);
                              },
                            ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: _minimumPadding, top: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Calculate',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          width: _minimumPadding * 3,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Reset',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 200.0,
      height: 200.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    if (principalController.text.isNotEmpty &&
        roiController.text.isNotEmpty &&
        termController.text.isNotEmpty) {
      double principal = double.parse(principalController.text);
      double roi = double.parse(roiController.text);
      double term = double.parse(termController.text);

      double totalAmountPayable = principal + (principal * roi * term) / 100;

      String result =
          'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
      return result;
    } else {
      return '';
    }
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
    _principleErrorText = null;
    _roiErrorText = null;
    _termErrorText = null;
  }
}
