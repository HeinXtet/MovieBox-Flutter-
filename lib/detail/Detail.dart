import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_box/constant/BaseConfig.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title, this.id}) : super(key: key);

  final String title;
  final int id;

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<Detail> {
  bool isLoading = true;
  bool isError = false;
  var detail;

  Future getDetail() async {
    var response = await http.get(getDetailUrl(widget.id));
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      detail = json.decode(response.body);
    } else {
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

  Widget DetailFrame(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ),
      );
    } else if (isError) {
      return Center(
        child: Text("Error Fetch Detail"),
      );
    } else
      return DetailBody(detail, context);
  }

  Widget ScrollAbleFrame() {
    new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
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

  Widget DetailBody(dynamic detail, BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    var height = queryData.size.height;
    return ListView(
      children: <Widget>[
        Container(
          height: height / 2.3,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.network("$poster_base_url${detail["backdrop_path"]}"),
                ],
              ),
              Positioned(
                top: 120,
                left: 16,
                child: Row(
                  children: <Widget>[
                    Image.network(
                      "$poster_base_url${detail["poster_path"]}",
                      width: width / 3.5,
                      height: 200,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 32, 16, 4),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 48, 0, 0),
                            child: Text(
                              detail["title"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            width: width - (width / 3.5) - 24,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                          child: Container(
                              child: Text(
                                " Release-Date ${detail["release_date"]}",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              width: width - (width / 3.5) - 2),
                        )

                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: width - 16,
          child: Column(
            children: <Widget>[
              DetailGenreFrame(detail,width,height),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text("${detail["overview"]}") ,
              ),
              productionFrame(detail, width, height)
              ],
          )
        )
      ],
    );
  }

  Widget DetailGenreFrame(dynamic detail,double width,double height){
    List genre = detail["genres"];
    if (genre.length>0){
      return Container(
        margin: EdgeInsets.fromLTRB(8,8, 8, 0),
        height: 40,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genre.length,
            itemBuilder: (context,index){
              return Card(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("${genre[index]["name"]}",style: TextStyle(color: Colors.white),),
                ),
              );
            }),
      );
    }
  }

  Widget productionFrame(dynamic detail,double width ,double height){
    List production = detail["production_companies"];

    if (production.length>0){
      return Container(
          height: height / 3.5,
        child: Column(
          children: <Widget>[

            Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  width: width - 16,
                  child: Text("Production Company",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                ),
              ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: production.length,
                  itemBuilder: (context,index) {
                    return Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            width: width / 5,
                            height: height / 4 - 100,
                            decoration:  BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image:  DecorationImage(
                                    fit: BoxFit.fill,
                                    image:  NetworkImage(
                                        "$poster_base_url${production[index]["logo_path"]}")
                                )
                            )),

                        Center(
                          child:  Container(
                            width: width / 5,
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text("${production[index]["name"]}",maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                        )

                      ],
                    );
                  }),
            )
          ],
        )
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DetailFrame(context),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
