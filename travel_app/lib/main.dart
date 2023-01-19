// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, non_constant_identifier_names, sort_child_properties_last
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/addParantPlaces.dart';
import 'package:travel_app/detail_page.dart';
import 'package:travel_app/loading.dart';
import 'package:travel_app/places_page.dart';
import 'package:travel_app/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'loading',
      routes: {
        'loading': (context) => Loading(),
        'home': (context) => Home(),
        'placepage': (context) => PlacePages(),
        'detailpage': (context) => DetailPage(),
        'addParentPlaces': (context) => AddPlaces(),
        'addChildPlaces': (context) => AddChildPlaces(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );
  }
}

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({
    Key? key,
  }) : super(key: key);

  var data = getData();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.pushNamed(context, 'addParentPlaces');
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            if (kDebugMode) {
                              print('search clicked');
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Popular Places",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 400,
                height: 250,
                child: PageView.builder(
                  itemCount: args['bannerPlaces'].length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'placepage', arguments: {
                        'places': args['bannerPlaces'][index]['places'],
                        'name': args['bannerPlaces'][index]['name'],
                      });
                    },
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://picsum.photos/500/500?random=1'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20)),
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Container(),
                            Container(
                                margin: EdgeInsets.all(20),
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      args['bannerPlaces'][index]['name']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    RatingBar.builder(
                                      itemSize: 18,
                                      initialRating: double.parse(
                                          args['bannerPlaces'][index]['raiting']
                                              .toString()),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Text(
                                      args['bannerPlaces'][index]['desc']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "Places you might like",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  height: 450,
                  width: 400,
                  child: ListView.builder(
                    itemCount: args['normalPlaces'].length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'placepage', arguments: {
                          'name': args['normalPlaces'][index]['name'],
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 150,
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://picsum.photos/500/500?random=$index'),
                                      fit: BoxFit.cover),
                                )),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    args['normalPlaces'][index]['name']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  RatingBar.builder(
                                    itemSize: 18,
                                    initialRating: double.parse(
                                        args['normalPlaces'][index]['raiting']
                                            .toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      args['normalPlaces'][index]['desc']
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
