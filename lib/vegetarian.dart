import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Foodapi extends StatefulWidget {
  @override
  _FoodapiState createState() => _FoodapiState();
}

class _FoodapiState extends State<Foodapi> {
  String url = "https://www.themealdb.com/api/json/v1/1/filter.php?a=American";

  getfood() async {
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 24),
                      Text(
                        "Food API Demo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isActive = false;
                              print(isActive);
                            });
                          },
                          child: Text("LIST")),
                      SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isActive = true;
                              print(isActive);
                            });
                          },
                          child: Text("GRID")),
                      SizedBox(width: 24),
                    ],
                  ),
                ),
                !isActive
                    ? FutureBuilder(
                        future: getfood(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data);
                            var listfood = snapshot.data['meals'];
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listfood.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(24, 8, 24, 8),
                                    leading: Image.network(
                                        listfood[index]['strMealThumb']),
                                    title: Text(listfood[index]['strMeal']),
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    : FutureBuilder(
                        future: getfood(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data);
                            var listfood = snapshot.data['meals'];
                            return GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listfood.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      // crossAxisSpacing: 20.0,
                                      mainAxisSpacing: 20.0),
                              itemBuilder: (context, index) {
                                // var namefood = listfood[index]['strMeal'];
                                // namefood = namefood.subString(0, 20) + "...";
                                return Container(
                                  // #TODO #FIXME BENERIN CARD NYA
                                  padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.network(
                                              listfood[index]['strMealThumb']),
                                        ),
                                        SizedBox(height: 10),
                                        (listfood[index]['strMeal'].length >=
                                                20)
                                            ? Text(
                                                listfood[index]['strMeal']
                                                        .substring(0, 20) +
                                                    "...",
                                                style: TextStyle(fontSize: 14),
                                              )
                                            : Text(listfood[index]['strMeal'],
                                                style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
              ],
            ),
          );
        }),
       
      ),
    );
  }
}
