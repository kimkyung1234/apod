import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

const apiKey = 'jMhPoeFyprqtPvXudxVHOcqwW5QhvLDqXHb8MP6j';

class MainScreen extends StatefulWidget {
  final String currentTime;
  MainScreen(this.currentTime);

  @override
  _MainScreenState createState() => _MainScreenState(currentTime);
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState(this.currentTime);
  final String currentTime;

  String currentDescription;
  String currentImageUrl;
  String currentTitle;
  String currentDate;

  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    var response = await get(
        'https://api.nasa.gov/planetary/apod?api_key=$apiKey&date=$currentTime');
    this.setState(() {
      String data = response.body;
      var currentData = jsonDecode(data);
      currentDescription = currentData['explanation'];
      currentImageUrl = currentData['url'];
      currentTitle = currentData['title'];
      currentDate = currentData['date'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 500.0,
              floating: false,
              //pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: currentImageUrl == null
                        ? new Center(
                            child: CircularProgressIndicator(),
                          )
                        : new Text(
                            currentTitle,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  background: currentImageUrl == null
                      ? new Center(
                          child: const CircularProgressIndicator(),
                        )
                      : new Image.network(
                          currentImageUrl,
                          fit: BoxFit.cover,
                        )),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
          ),
          child: currentImageUrl == null
              ? new Center(
                  child: const CircularProgressIndicator(),
                )
              : new ListView(
                  children: <Widget>[
                    Text(
                      '${currentTime}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currentDescription,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
