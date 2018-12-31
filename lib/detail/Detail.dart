import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_box/constant/BaseConfig.dart';
class Detail extends StatefulWidget{

  Detail({Key key, this.title,this.id}) : super(key: key);

  final String title;
  final int id;

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<Detail>{
  bool isLoading = true;
  bool isError = false;
  var detail;

  Future getDetail() async{
    var response = await http.get(getDetailUrl(widget.id));
    if (response.statusCode == 200){
      setState(() {
        isLoading = false;
        isError = false;
      });
      detail = json.decode(response.body);
      }else{
      debugPrint("error ${response.statusCode}");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  Widget DetailFrame(){
    if (isLoading){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ),
      );
    }else if (isError){
      return Center(
        child: Text("Error Fetch Detail"),
      );
    }else
     return DetailBody(detail);
  }

  Widget ScrollAbleFrame(){
    new LayoutBuilder(
      builder:
          (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Column(children: [

              // remaining stuffs
            ]),
          ),
        );
      },
    );
  }

  Widget DetailBody(dynamic detail) {
    return ListView(
      children: <Widget>[
        Container(
          height: 1000,
          color: Colors.white,
          child:  Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.network("$poster_base_url${detail["backdrop_path"]}"),
                ],
              ),
              Positioned(
                  top:120,
                  left:-20,
                  child:   Image.network("$poster_base_url${detail["poster_path"]}",width: 200,height :200,)
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DetailFrame(),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
