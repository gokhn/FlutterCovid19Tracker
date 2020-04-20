import 'package:covidnineteentracker/helpers/colors.dart';
import 'package:covidnineteentracker/models/statsresponse.dart';
import 'package:covidnineteentracker/ui/countrydetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CountriesData extends StatefulWidget {
  @override
  _CountriesDataState createState() => _CountriesDataState();
}

class _CountriesDataState extends State<CountriesData> {
  TextEditingController controller = new TextEditingController();

  List<Covid19Stats> _searchResult = [];

  List<Covid19Stats> _countryResult = [];

  Future<List<Covid19Stats>> _gonderiGetir() async {
    var headers = {
      'x-rapidapi-host': 'YOUR_HOST_NAME',
      "x-rapidapi-key": "YOUR_API_KEY"
    };

    final response = await http.get(
      Uri.encodeFull(
          "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats"),
      headers: headers,
    );

    ResData resData = new ResData();
    List<Covid19Stats> responseStatus = new List<Covid19Stats>();

    resData = StatsResponse.fromJson(json.decode(response.body)).data;

    if (resData != null) {
      responseStatus = resData.covid19Stats;
    }

    if (this.mounted) {
      setState(() {
        _countryResult = responseStatus;
      });
    }
    
    return responseStatus;
  }

  @override
  void initState() {
    super.initState();

    _gonderiGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Bgcolor,
        title: Text(
          "World",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Bgcolor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search Country', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? _searchDesign()
                : FutureBuilder(
                    future: _gonderiGetir(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Covid19Stats>> snapshot) {
                      if (snapshot.hasData) {
                        return RefreshIndicator(
                          onRefresh: _gonderiGetir,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white, //new Color(0xFF333366),
                                  shape: BoxShape.rectangle,
                                  borderRadius: new BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      offset: new Offset(0.0, 10.0),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  title: Text(snapshot.data[index].country,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.0)),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        snapshot.data[index].province == ""
                                            ? SizedBox(
                                                height: 5.0,
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Icon(Icons.location_on,
                                                      color: Colors.red),
                                                  SizedBox(width: 5.0),
                                                  Text(
                                                      snapshot
                                                          .data[index].province,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                ],
                                              ),
                                        SizedBox(height: 10.0),
                                        snapshot.data[index].city == ""
                                            ? SizedBox(
                                                height: 5.0,
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Icon(Icons.location_city,
                                                      color: Colors.green),
                                                  SizedBox(width: 5.0),
                                                  Text(
                                                      snapshot.data[index].city,
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CountryDetail(
                                                countryResult:
                                                    snapshot.data[index])));
                                  },
                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.grey, size: 30.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text(snapshot
                                                  .data[index].country.length >
                                              3
                                          ? snapshot.data[index].country
                                              .substring(0, 3)
                                          : snapshot.data[index].country),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return _buildErrorPage();
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _countryResult.forEach((country) {
      if (country.country.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(country);
    });

    setState(() {});
  }

  Widget _searchDesign() {
    return ListView.builder(
      itemCount: _searchResult.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white, //new Color(0xFF333366),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(_searchResult[i].country,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0)),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Column(
                children: <Widget>[
                  _searchResult[i].province == ""
                      ? SizedBox(
                          height: 5.0,
                        )
                      : Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 5.0),
                            Text(_searchResult[i].province,
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                  SizedBox(height: 10.0),
                  _searchResult[i].city == ""
                      ? SizedBox(
                          height: 5.0,
                        )
                      : Row(
                          children: <Widget>[
                            Icon(Icons.location_city, color: Colors.green),
                            SizedBox(width: 5.0),
                            Text(_searchResult[i].city,
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CountryDetail(countryResult: _searchResult[i])));
            },
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(_searchResult[i].country.length > 3
                    ? _searchResult[i].country.substring(0, 3)
                    : _searchResult[i].country),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorPage() {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/img/coronahome.png',
            width: 200,
            height: 150,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            'Could Not Load This Page',
            style: TextStyle(
              fontSize: 28,
              color: Theme.of(context).primaryColor,
              fontFamily: 'Bebas',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
