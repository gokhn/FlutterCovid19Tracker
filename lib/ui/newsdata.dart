import 'package:covidnineteentracker/helpers/colors.dart';
import 'package:covidnineteentracker/models/newsdataresponse.dart';
import 'package:covidnineteentracker/ui/newsdetail.dart';
import 'package:flutter/material.dart';
// json decode etmek için gerekli olan kütüphane
import 'dart:convert';
// http istekleri yapmamızı sağlayan http kütüphanesini http adı ile al
import 'package:http/http.dart' as http;

//NewsData
class NewsData extends StatefulWidget {
  @override
  _NewsDataState createState() => _NewsDataState();
}

class _NewsDataState extends State<NewsData> {
  Future<List<NewsResult>> _gonderiGetir() async {
    var headers = {
      'authorization': 'YOUR_KEY',
      "content-type": "application/json"
    };

    final response = await http.get(
      Uri.encodeFull("https://api.collectapi.com/corona/coronaNews"),
      headers: headers,
    );

    List<NewsResult> rr = List<NewsResult>();

    rr = NewsDataResponse.fromJson(json.decode(response.body)).newsResult;

    return rr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Bgcolor,
        title: Text("News", style: TextStyle(color: Colors.blue)),
      ),
      body: FutureBuilder(
        future: _gonderiGetir(),
        builder:
            (BuildContext context, AsyncSnapshot<List<NewsResult>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(snapshot.data[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.0)),
                      subtitle: Text(snapshot.data[index].description),
                      leading: Container(
                        height: 90,
                        width: 100,
                        child: Image.network(
                          snapshot.data[index].image,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetail(
                                      selectedUrl: snapshot.data[index].url,
                                      title: snapshot.data[index].source,
                                    )));
                      },
                    ),
                  ));
                },
              ),
              onRefresh: _gonderiGetir,
            );
          } else if (snapshot.hasError) {
            return _buildErrorPage();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
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
