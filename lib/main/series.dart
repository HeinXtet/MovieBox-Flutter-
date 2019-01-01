import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Series extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SeriesState();
  }
}

class SeriesResult {
  List<SeriesModel> movie;
  final int totalResult;
  final int totalPage;
  SeriesResult._({this.totalPage, this.totalResult,this.movie});
  factory SeriesResult.fromJson(Map<String, dynamic> json) {
    var serisJsonList  = json['results'] as List;
    List<SeriesModel> data = serisJsonList.map((i) => SeriesModel.fromJson(i)).toList();
    return SeriesResult._(
      totalPage: json['total_pages'],
      totalResult: json['total_results'],
      movie: data);

  }
}
class SeriesModel{
    final String title;
    final String poster ;
  SeriesModel._({this.title, this.poster});
  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    return SeriesModel._(
      title: json['name'],
      poster: json['poster_path'],
    );
  }
}

class SeriesState extends State<Series> {

 SeriesResult result = null;
  bool isLoading = true;
  bool isError = false;

  Future getSeries() async {
    var response = await http.get("https://api.themoviedb.org/3/tv/popular?api_key=961277648f1e28c74788bade62b3b24c&language=en-US&page=1");
    if (response.statusCode == 200){
      result = SeriesResult.fromJson(json.decode(response.body));
      setState(() {
              isLoading = false;
              isError = false;
            });
       print("success series fetch data ${result.movie.length}");
    }else{
      setState(() {
              isLoading = false;
              isError = true;
            });
      print("error series fetch data");
    }
  }

@override
  void initState() {
    super.initState();
    getSeries();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return Center(child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),);
    }else if(isError){
      return Center(child: Text("Error Fetch Series"),);
    }
    else{
      var list = result.movie.cast<SeriesModel>();
      return ListView.builder(itemCount: result.movie.length,
      itemBuilder: (context,index){
        return Text("${list[index].title}");
      },);
    }
  }
}
