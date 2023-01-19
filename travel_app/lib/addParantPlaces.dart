// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlaces extends StatefulWidget {
  AddPlaces({super.key});

  @override
  State<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends State<AddPlaces> {
  TextEditingController placeNameController = TextEditingController();
  TextEditingController DescController = TextEditingController();
  TextEditingController UrlController = TextEditingController();
  TextEditingController RaitingController = TextEditingController();
  String _selected_type = "normal_place";

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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: screenSize.height * 0.03),
                  child: TextField(
                    style: TextStyle(),
                    controller: placeNameController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {},
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
                Row(
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: DropdownButton(
                          onChanged: (value) {
                            _selected_type = value!;
                          },
                          value: _selected_type,
                          // ignore: prefer_const_literals_to_create_immutables
                          items: [
                            DropdownMenuItem(
                                value: "banner_place",
                                child: Text("Banner Place")),
                            DropdownMenuItem(
                              value: "normal_place",
                              child: Text("Normal Place"),
                            )
                          ],
                        )),
                  ],
                ),
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        if (placeNameController.value.text == '' ||
                            UrlController.value.text == '' ||
                            DescController.value.text == '' ||
                            RaitingController.value.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No Data Given")));
                          return;
                        }

                        CollectionReference ParentPlaces = FirebaseFirestore
                            .instance
                            .collection('ParentPlaces');

                        var allPlaces = await ParentPlaces.get();
                        List<Map> allDocs = allPlaces.docs
                            .map((doc) => doc.data() as Map)
                            .toList();

                        for (Map<dynamic, dynamic> x in allDocs) {
                          if (x['name'] == placeNameController.value.text) {
                            return;
                          }
                        }

                        ParentPlaces.doc(placeNameController.value.text).set({
                          'name': placeNameController.value.text,
                          'desc': DescController.value.text,
                          'imageUrl': UrlController.value.text,
                          'raiting': RaitingController.value.text,
                          'type': _selected_type,
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
