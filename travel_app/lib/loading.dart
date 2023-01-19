import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    getDataFromDataBase();
    super.initState();
  }

  void getDataFromDataBase() async {
    CollectionReference ParentPlaces =
        FirebaseFirestore.instance.collection('ParentPlaces');

    List bannerPlaces = [];
    List normalPlaces = [];

    var allPlaces = await ParentPlaces.get();
    List<Map> allDocs = allPlaces.docs.map((doc) => doc.data() as Map).toList();

    for (var i = 0; i < allDocs.length; i++) {
      if (allDocs[i]['type'] == 'banner_place') {
        bannerPlaces.add(allDocs[i]);
      } else {
        normalPlaces.add(allDocs[i]);
      }
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, 'home', arguments: {
      'bannerPlaces': bannerPlaces,
      'normalPlaces': normalPlaces
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_ampohobu.json'),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 10,
              ),
              Text(
                "Loading...",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    letterSpacing: 2),
              )
            ]),
      ),
    );
  }
}
