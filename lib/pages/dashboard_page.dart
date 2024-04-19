import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lunchspot_v1/components/fortune_wheel.dart';
import 'package:lunchspot_v1/data/database.dart';
import 'package:lunchspot_v1/data/slice.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // reference the hive box
  // final _hiveBox = Hive.box('lunchSpots');
  LunchSpotsDatabase db = LunchSpotsDatabase();

  @override
  void initState() {
    // load database records
    db.loadData();

    super.initState();
  }

  customizeList() {
    final int totalRestaurants = db.restaurantList.length;
    // out of 1, 0.1 is reserved for try again and new place
    double equalProbability = 0.9 / totalRestaurants;
    // Map<String, double> restaurantProbabilities = {};
    final items = <Slice>[
      const Slice("Try Again", 0.05),
      for (int i = 0; i < totalRestaurants; i++)
        Slice(db.restaurantList[i][0], equalProbability),
      const Slice("Try New Place", 0.05),
    ];
    // print(items);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: db.restaurantList.isNotEmpty
          ? CustomFortuneWheel(
              restaurants: customizeList()) // Add the fortune wheel widget
          : const Text("0 restaurants, please create a restaurant."),
    );
  }
}
