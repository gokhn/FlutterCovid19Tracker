import 'package:covidnineteentracker/models/statsresponse.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:covidnineteentracker/models/countriesdataresponse.dart';

class CountryDetail extends StatefulWidget {
  //String country;
  final Covid19Stats countryResult;

  CountryDetail({Key key, @required this.countryResult}) : super(key: key);

  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  List<charts.Series<Task, String>> _seriesPieData;
  
  String titleMethod(Covid19Stats item)
  {
    String response = "";

    if(item != null)
    {
      if(item.province != null && item.province != "" && item.city != null && item.city != "")
      {
        response += item.province + " / " + item.city;
      }
      else if(item.province != null && item.province != "")
      {
        response += item.province;
      }
      
      else if(item.city != null && item.city != "")
      {
        response += item.city;
      }
    }

    return response + " Details";
  }

  double initvaluePercent( Covid19Stats response  ,int val)
  {
    double result =0;

    int allSumValue =  (response.confirmed) +   (response.deaths) +  (response.recovered);

      result =   (((val) / allSumValue) * 100).roundToDouble();

    return result;
  }

  _generateData()
   {
    var piedata = [
      new Task('Total Deaths : '+ widget.countryResult.deaths.toString() , initvaluePercent(widget.countryResult,widget.countryResult.deaths),
          Color(0xffdc3912)),
      new Task('Total Recovered : ' + widget.countryResult.recovered.toString(),
          initvaluePercent(widget.countryResult,widget.countryResult.recovered), Color(0xff109618)),


      new Task('Total Cases : '+ widget.countryResult.confirmed.toString(), initvaluePercent(widget.countryResult,widget.countryResult.confirmed),
          Color(0xffff9900)),
        
        
   //   new Task('New Deaths : ' + widget.countryResult.newDeaths, initvaluePercent(widget.countryResult,widget.countryResult.newDeaths),
   //       Color(0xff990099)),
    //  new Task('New Cases : ' +widget.countryResult.newCases, initvaluePercent(widget.countryResult,widget.countryResult.newCases),
      //    Color(0xff3366cc)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'TotalData',
        data: piedata,
        labelAccessorFn: (Task row, _) => '',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        title: Text(widget.countryResult.country),        
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
           
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(titleMethod(widget.countryResult),
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: charts.PieChart(_seriesPieData,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.middleDrawArea,
                            horizontalFirst: false,
                           // desiredMaxRows: 3,
                            cellPadding: new EdgeInsets.all(4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette.black,
                                fontFamily: 'Georgia',
                                fontSize: 15),
                          )
                        ],
                        
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 80,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ]
                            )
                            ),
                  ),
                ],
              ),
            
          ),
        ),
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
