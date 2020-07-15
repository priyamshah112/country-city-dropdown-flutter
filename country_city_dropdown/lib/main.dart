import 'package:country_city_dropdown/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyHomePage());
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _initForm;
  final _countryList = <Country>[];
  final _cityList = <City>[];
  var form1 = 0xffffaf4ff;
  var primary = 0xFF03A9F4;

  Country selectedCountry;
  City selectedCity;

  @override
  void initState() {
    super.initState();
    _initForm = _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    _countryList.clear();
    _countryList.addAll(await fetchCountryList());
  }

  void _onStateSelected(Country selectedCountry) async {
    try {

      final cityList = await fetchCityList(selectedCountry.id);
      setState(() {
        this.selectedCountry = selectedCountry;
        selectedCity = null;
        _cityList.clear();
        _cityList.addAll(cityList);
      });

    } catch (e) {
      print("Error while selecting Country");
      print(e);
    }
  }

  void _onCitySelected(City selectedCity) {
    setState(() {
      this.selectedCity = selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          title: Text("Country City Dropdown"),
        ),
        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:10),
              // City Country Dropdown
              FutureBuilder<void>(
                future: _initForm,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return _buildLoading();
                  else if (snapshot.hasError)
                    return _buildError(snapshot.error);
                  else
                    return _buildBody();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(animating: true),
          SizedBox(height: 10.0),
          Text("Loading Country and Cities"),
        ],
      ),
    );
  }

  Widget _buildError(dynamic error) {
    return Center(
      child: Text("Error occured while building: $error"),
    );
  }

  Widget _buildBody() {
    return Column(

      children: <Widget>[
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<Country>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(form1),
                labelStyle: TextStyle(color: Color(form1), fontSize: 10.0),
                errorStyle: TextStyle(color: Colors.red[600], fontSize: 12.0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                contentPadding: const EdgeInsets.only(
                    left: 30.0,
                    bottom: 18.0,
                    top: 18.0,
                    right: 0.0),
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(primary),
                ),
              ),
              hint: Text("Country",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              isDense: true,

              items: _countryList
                  .map((itm) => DropdownMenuItem(
                child: Text(itm.name),
                value: itm,
              ))
                  .toList(),
              value: selectedCountry,
              onChanged: _onStateSelected,
              validator: (value) {
                print("Country");
                print(value);
                if (value==null)
                  return "Please select your country";
                return null;
              },
              onSaved: (value) =>
                  print(value.id),
            ),
          ),
        ),

        SizedBox(height:20),
        Container(

          child: DropdownButtonHideUnderline(
            child:DropdownButtonFormField<City>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(form1),
                labelStyle: TextStyle(color: Color(form1), fontSize: 10.0),
                errorStyle: TextStyle(color: Colors.red[600], fontSize: 12.0),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                contentPadding: const EdgeInsets.only(
                    left: 30.0,
                    bottom: 18.0,
                    top: 18.0,
                    right: 0.0),
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(primary),
                ),
              ),
              hint: Text("City",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              isDense: true,
              items: _cityList
                  .map((itm) => DropdownMenuItem(
                child: Text(itm.name),
                value: itm,
              ))
                  .toList(),
              value: selectedCity,
              onChanged: _onCitySelected,
              validator: (value) {
                print("City");
                print(value);
                if (value==null)
                  return "Please select your city";
                return null;
              },
              onSaved: (value) =>
                  print(value.id),
            ),
          ),
        ),

      ],

    );
  }

}
