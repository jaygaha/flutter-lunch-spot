import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lunchspot_v1/components/sys_button.dart';
import 'package:lunchspot_v1/data/database.dart';
import 'package:lunchspot_v1/data/restaurant_record.dart';
import 'package:lunchspot_v1/data/slice.dart';
import 'dart:math';

class CustomFortuneWheel extends StatefulWidget {
  final List<dynamic> restaurants;

  const CustomFortuneWheel({
    super.key,
    required this.restaurants,
  });

  @override
  State<CustomFortuneWheel> createState() => _CustomFortuneWheelState();
}

class _CustomFortuneWheelState extends State<CustomFortuneWheel> {
  final _hiveBox = Hive.box('lunchSpots');
  LunchSpotsDatabase db = LunchSpotsDatabase();
  int selectedSliceIndex = 0;
  String selectedSliceName = "...";
  final selectedSlice = StreamController<int>();
  DateTime createdAt = DateTime.now();
  // lazy init, after createdAt loaded it will be loaded
  late DateTime lunchAt =
      DateTime(createdAt.year, createdAt.month, createdAt.day);

  @override
  void initState() {
    // load lunch data
    db.loadLunchData();

    // var luncheList = _hiveBox.get('lunches');
    var luncheList = db.lunchList;

    var lunch = luncheList.where((f) => f[0] == lunchAt);
    if (lunch.isNotEmpty) {
      selectedSliceName = lunch.first[2];
    }

    super.initState();
  }

  double sumProbabilities(List<dynamic> restaurants) =>
      restaurants.fold(0.0, (sum, item) => sum + item.probability);

  int spin(List<dynamic> restaurants) {
    final totalProbability = sumProbabilities(restaurants);
    final randomValue = Random().nextDouble() * totalProbability;
    var currentProbability = 0.0;

    int index = 0;
    for (final item in restaurants) {
      currentProbability += item.probability;
      if (randomValue <= currentProbability) {
        return index;
      }
      index++;
    }
    return index; // Handle this case as needed
  }

  void _spinWheel() {
    selectedSliceIndex = spin(widget.restaurants);

    selectedSlice.add(
        // Fortune.randomInt(0, items.length),
        selectedSliceIndex);

    setState(() {
      selectedSliceName = '...';
    });
  }

  void _printName() {
    var r = widget.restaurants[selectedSliceIndex];

    setState(() {
      selectedSliceName = r.value;
    });

    _showAlertDialog();
  }

  void _showAlertDialog() {
    // set up the button
    Widget okButton = SysButton(
      text: "No",
      onPressed: () {
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    Widget cancelButton = SysButton(
      text: "Yes",
      onPressed: () => _addToDb(),
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Yay!!!"),
      content: Text(
        '''$selectedSliceName
Are we going to this restaurant?''',
        maxLines: 20,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    ); // show the dialog

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _addToDb() {
    var r = widget.restaurants[selectedSliceIndex];
    var restaurantName = r.value;
    var lists = _hiveBox.get('restaurants');

    // -1 if not found
    int restarurantKey = lists.indexWhere((f) => f[0] == restaurantName);

    // add to database
    db.lunchList.add([
      lunchAt,
      restarurantKey,
      restaurantName,
      createdAt,
    ]);

    db.updateLunchData();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    selectedSlice.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _spinWheel();
          });
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: FortuneWheel(
                selected: selectedSlice.stream,
                animateFirst: false,
                onAnimationEnd: () => {_printName()},
                indicators: const <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment
                        .topCenter, // <-- changing the position of the indicator
                    child: TriangleIndicator(
                      color: Color.fromRGBO(162, 215, 41,
                          0.9), // <-- changing the color of the indicator
                      width: 50.0, // <-- changing the width of the indicator
                      height: 50.0, // <-- changing the height of the indicator
                      elevation:
                          20, // <-- changing the elevation of the indicator
                    ),
                  ),
                ],
                items: widget.restaurants
                    .map((slice) => FortuneItem(
                          child: Text(slice.value),
                        ))
                    .toList(),
              ),
            ),
            // const SizedBox(height: 5),
            SysButton(
              onPressed: () {
                _spinWheel();
              },
              text: "Spin the Wheel",
            ),
            const SizedBox(height: 10),
            Text("Today's restarurant: $selectedSliceName"),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
