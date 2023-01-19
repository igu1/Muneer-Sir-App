// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, depend_on_referenced_packages, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacePages extends StatelessWidget {
  const PlacePages({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    "${args['name']} Places",
                    style: TextStyle(letterSpacing: 2, fontSize: 15),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 15),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'addChildPlaces',
                            arguments: {'parent_place': args['name']});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return buildGridView(context, 3, args);
                  } else if (constraints.maxWidth > 400) {
                    return buildGridView(context, 2, args);
                  } else {
                    return buildGridView(context, 1, args);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView(
      BuildContext context, int crossAxisCount, Map<dynamic, dynamic> args) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var sdata = snapshot.data as List;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            children: List.generate(sdata.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detailpage', arguments: {
                    'name': sdata[index]['name'],
                    'image': null,
                    'desc': sdata[index]['desc'],
                    'url': null,
                    'rating': sdata[index]['raiting']
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://picsum.photos/500/500?random=$index'))),
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 10, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sdata[index]['name'].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            RatingBar.builder(
                              itemSize: 18,
                              initialRating: double.parse(
                                  sdata[index]['raiting'].toString()),
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
                              sdata[index]['desc'],
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getData(args['name']),
    );
  }

  dynamic getData(Parentname) async {
    // CollectionReference ParentPlaces =
    //     FirebaseFirestore.instance.collection('ParentPlaces');

    CollectionReference ChildPlaces =
        FirebaseFirestore.instance.collection('ChildPlaces');

    var child_data = await ChildPlaces.get();

    List<Map> allChildDocs =
        child_data.docs.map((doc) => doc.data() as Map).toList();

    var child_places = [];

    for (var x in allChildDocs) {
      print(x);
      print(Parentname);
      if (x['parentPlace'] == Parentname) {
        child_places.add(x);
      }
    }
    print(child_places);

    return child_places;
  }
}

class AddChildPlaces extends StatefulWidget {
  const AddChildPlaces({super.key});

  @override
  State<AddChildPlaces> createState() => _AddChildPlacesState();
}

class _AddChildPlacesState extends State<AddChildPlaces> {
  TextEditingController placeNameController = TextEditingController();
  TextEditingController DescController = TextEditingController();
  TextEditingController UrlController = TextEditingController();
  TextEditingController RaitingController = TextEditingController();

  @override
  void dispose() {
    placeNameController.dispose();
    DescController.dispose();
    UrlController.dispose();
    RaitingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade300),
                      child: GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      top: screenSize.height * 0.02,
                      left: screenSize.width * 0.05),
                  child: Text(
                    "Add Place",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: screenSize.height * 0.03),
                  child: TextField(
                    style: TextStyle(),
                    controller: placeNameController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      print(placeNameController.value);
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.place),
                        helperText: "Place Name"),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: screenSize.height * 0.03),
                  child: TextField(
                    controller: DescController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: InputBorder.none,
                      helperText: 'Place Description',
                    ),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: screenSize.height * 0.03),
                  child: TextField(
                    style: TextStyle(),
                    controller: UrlController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.image),
                        helperText: "Image Url"),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: screenSize.height * 0.03),
                  child: TextField(
                    style: TextStyle(),
                    controller: RaitingController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.star),
                        helperText: "Raiting"),
                  ),
                ),
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        CollectionReference ChildPlace = FirebaseFirestore
                            .instance
                            .collection('ChildPlaces');

                        var allPlaces = await ChildPlace.get();
                        List<Map> allDocs = allPlaces.docs
                            .map((doc) => doc.data() as Map)
                            .toList();

                        for (Map<dynamic, dynamic> x in allDocs) {
                          if (x['name'] == placeNameController.value.text) {
                            return;
                          }
                        }

                        ChildPlace.doc(placeNameController.value.text).set({
                          'name': placeNameController.value.text,
                          'desc': DescController.value.text,
                          'imageUrl': UrlController.value.text,
                          'raiting': RaitingController.value.text,
                          'parentPlace': args['parent_place']
                        });
                      },
                      child: Container(
                        width: screenSize.width * 0.8,
                        height: screenSize.height * 0.06,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              "Add Place",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
