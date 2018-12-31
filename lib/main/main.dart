import 'package:flutter/material.dart';
import 'package:movie_box/constant/BaseConfig.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MovieBox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MovieBox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  void bottomNavTap(int index){
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: bottomNavTap,
            currentIndex: currentIndex,
            items: main_bottom_menu),
        body: Center(
            child: bottom_nav_widget[currentIndex]
        )
    );
  }
}

