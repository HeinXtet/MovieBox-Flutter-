import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:movie_box/constant/BaseConfig.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget Banner(List popularMovie,double height){
  return Container(
    height: height / 3,
    color: Colors.white,
    child: new Swiper(
      itemBuilder: (BuildContext context,int index){
        return new Image.network("${poster_base_url}${popularMovie[index]["backdrop_path"]}",fit: BoxFit.fill);
      },
      itemCount: popularMovie.length,
      pagination: new SwiperPagination(),
      autoplay: true,
      control: null,
    ),
  );
}

Widget NowPlayingMovie(List nowplaying,double height,double width,String title){

  return Container(
    height: height / 2.6,
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(title,style : TextStyle(
                fontWeight: FontWeight.bold,fontSize: 18
            )),
          ),
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nowplaying.length,
              itemBuilder: (context, index){
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: (){
                    debugPrint("");
                  },
                  child: Column(
                    textDirection: TextDirection.ltr,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.network("${poster_base_url}${nowplaying[index]["poster_path"]}",
                        width:width/2.5,height: height/3.7 - 10,fit: BoxFit.fill,),
                      Container(
                         color: Colors.blue,
                          width: width/2.5,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(nowplaying[index]["title"],maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white)),
                              )
                          )
                      )
                    ],
                  ),
                )
              );
          }),
        )
      ],
    ),
  );

}

class Movie extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MovieState();
  }
}

class MovieState extends State<Movie>{

  bool isError = false;
  bool isLoading = true;
  List popularMovie;
  List latestMovie;

  void ErrorState(){
    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  void SuccessState(){
    setState(() {
      isError = false;
      isLoading = false;
    });
  }

  Future getMovie() async {
    var response = await http.get(
        "$top_rated_movie");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      popularMovie = data["results"];
      debugPrint("popular movie fetch result ${response.body}");
      var latestResponse = await http.get(now_playing_movie);
      if (latestResponse.statusCode == 200){
        debugPrint("latest movie fetch result ${response.body}");
      SuccessState();
        var data2 = json.decode(latestResponse.body);
        latestMovie = data2["results"];
      }else{
        ErrorState();
        throw Exception('Failed to load post');
      }
    } else {
      ErrorState();
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    getMovie();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width  = queryData.size.width;
    var height = queryData.size.height;
    if(isLoading){
      return Center(
        child: Container(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        ),
      );
    }else if (isError){
      return Center(
        child: Container(
          child: Text("Error Fetch Movies"),
        ),
      );
    }else{
      return Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              Banner(popularMovie,height),
              NowPlayingMovie(latestMovie, height,width,"Now Playing Movie"),
              NowPlayingMovie(popularMovie, height, width,"Top Rated Movie")
            ],
          )
        ),
      );
    }
  }
}