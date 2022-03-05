import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int? temprature;
  String? location;
  int woeid = 2487956;
  String weather = 'clear';

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  Future <void> fechSearch(String input) async {
    //variable ini berfungsi untuk get API
    //disini kode kita akan error lihat di stack over flow
    //https://stackoverflow.com/questions/66473263/the-argument-type-string-cant-be-assigned-to-the-parameter-type-uri
    //var searchResult = await http.get(searchApiUrl + input);
    var searchResult = await http.get(Uri.parse(searchApiUrl + input));
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result['title'];
      woeid = result['woeid'];
    });
  }

  Future <void> fetchLocation() async {
    var locationResult =
        await http.get(Uri.parse(locationApiUrl + woeid.toString()));
    var result = json.decode(locationResult.body);
    var consolidated_weather = result['consolidated_weather'];
    var data = consolidated_weather[0];

    setState(() {
      temprature = data['the_temp'].toInt();
      weather = data['weather_state_name'].replaceAll(' ', '').toLowerCase();
    });
  }

  // dibuat setelah membuat onSubmitted pada bagian bawah
  void onTextFieldSubmitted(String input){
    fechSearch(input);
    fetchLocation();
  }

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/${weather}.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //https://www.degreesymbol.net/ for degree
              Column(
                children: [
                  Center(
                    child: Text(
                      temprature.toString() + '°',
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                  Center(
                    child: Text(
                      location.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 300,
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      decoration: InputDecoration(
                        hintText: 'Search another location...',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      //kita lakukan terakhir setelah membuat 2 method diatas
                      onSubmitted: (String input){
                        setState(() {
                        });
                          onTextFieldSubmitted(input);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
