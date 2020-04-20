import 'package:covidnineteentracker/ui/countriesdata.dart';
import 'package:covidnineteentracker/ui/home.dart';
import 'package:covidnineteentracker/ui/newsdata.dart';
import 'package:covidnineteentracker/ui/totaldata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'helpers/colors.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
     runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Bgcolor, fontFamily: 'Staatliches'),
      home: StartScreen()));
    });

  
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int selectedIndex = 3;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
   
    TotalData(),       
    CountriesData(),
     NewsData(),   
     Home()
    

  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(body: Center(child: _widgetOptions.elementAt(selectedIndex),
    ),
    bottomNavigationBar: Container(
      decoration: BoxDecoration(color: Bgcolor,boxShadow: [
        BoxShadow(blurRadius: 20,color: Colors.white.withOpacity(.1))
      ]),
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: GNav(
                gap: 3,
                activeColor: Colors.white,
                color: Colors.white,
                iconSize: 23,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.blue[800],
                tabs: [
                  GButton(
                    icon: LineIcons.bar_chart,
                    text: 'Total',
                  ),
                  GButton(
                    icon: LineIcons.globe,
                    text: 'World',
                  ),
                 
                  GButton(
                    icon: LineIcons.pie_chart,
                    text: 'News',
                  ),
                   GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  )
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                }),
          ),
        ),
    ),
    );
  }
}
