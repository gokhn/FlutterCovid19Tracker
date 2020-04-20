import 'package:covidnineteentracker/helpers/colors.dart';
import 'package:covidnineteentracker/models/totaldataresponse.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<TotalDataResponse> fetchPost() async {
  var headers = {
    'authorization': 'apikey 7dau37bauz5buj92OO2xw9:2FQmS51oVIy0Sh25tgEkCD',
    "content-type": "application/json"
  };

  final response = await http.get(
    Uri.encodeFull("https://api.collectapi.com/corona/totalData"),
    // Bu özellik ile ise sadece json verileri kabul et diyoruz
    headers: headers,
  );

  TotalDataResponse res = TotalDataResponse();
  final Map<String, dynamic> jsonResponse = json.decode(response.body);

  res = TotalDataResponse.fromJson(jsonResponse['result']);

  res.success = jsonResponse['success'];

  return res;
}

class TotalData extends StatefulWidget {
  @override
  _TotalDataState createState() => _TotalDataState();
}

class _TotalDataState extends State<TotalData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Bgcolor,
        title: Text("Total", style: TextStyle(color: Colors.blue)),
      ),
        body: FutureBuilder(
            future: fetchPost(),
            builder: (BuildContext context,
                AsyncSnapshot<TotalDataResponse> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/img/coronavirus.png',
                                width: 100,
                                height: 150,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Text(
                                'Total Information',
                                style: TextStyle(
                                  color: Colors.blue[
                                      800], //Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Material(
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(18.0),
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Deaths',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        Text(snapshot.data.totalDeaths,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 28.0))
                                      ],
                                    ),
                                    Material(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Icon(Icons.timeline,
                                              color: Colors.white, size: 30.0),
                                        )))
                                  ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 35.0, bottom: 35.0, top: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                    elevation: 14.0,
                                    borderRadius: BorderRadius.circular(18.0),
                                    shadowColor: Colors.black,
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Material(
                                              color: Colors.orange,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Icon(Icons.healing,
                                                    color: Colors.white,
                                                    size: 30.0),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 16.0)),
                                          Text(snapshot.data.totalCases,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 28.0)),
                                          Text('Cases',
                                              style: TextStyle(
                                                  color: Colors.orange))
                                        ],
                                      ),
                                    )),
                                Material(
                                    elevation: 14.0,
                                    borderRadius: BorderRadius.circular(18.0),
                                    shadowColor: Colors.black,
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Material(
                                              color: Colors.green,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Icon(Icons.dashboard,
                                                    color: Colors.white,
                                                    size: 30.0),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 16.0)),
                                          Text(snapshot.data.totalRecovered,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 28.0)),
                                          Text('Recovered',
                                              style: TextStyle(
                                                  color: Colors.green))
                                        ],
                                      ),
                                    )),
                              ]),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return _buildErrorPage();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
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
