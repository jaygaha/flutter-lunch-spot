import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lunchspot_v1/components/form_dialog.dart';
import 'package:lunchspot_v1/components/restaurant_tile.dart';
import 'package:lunchspot_v1/data/database.dart';
import 'package:lunchspot_v1/data/restaurant_record.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  // reference the hive box
  final _hiveBox = Hive.box('lunchSpots');
  LunchSpotsDatabase db = LunchSpotsDatabase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create the default data
    if (_hiveBox.get("restaurants") == null) {
      db.initData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  RestaurantRecord record = const RestaurantRecord(
    name: "",
    address: "",
    logoUrl: "",
  );

  // Create a new record
  void createNewRestaurant() {
    showDialog(
        context: context,
        builder: (contest) {
          return FormDialog(
            isEditing: false,
            initialRecord: record,
            onRecordSaved: (savedRecord) {
              // Handle saved record within the app
              // Update UI, store record in database, etc.
              saveRestaurantRecord(savedRecord);
            },
          );
        });
  }

  // save record
  void saveRestaurantRecord(dynamic data,
      [bool isEditing = false, int primaryId = 0]) {
    //  if editing existing item, update it
    if (isEditing) {
      setState(() {
        db.restaurantList[primaryId][0] = data.name;
        db.restaurantList[primaryId][1] = data.address;
        db.restaurantList[primaryId][2] = data.logoUrl;
      });
    } else {
      //  otherwise add the new restaurant to our list of restaurants
      setState(() {
        db.restaurantList.add([
          data.name,
          data.address,
          data.logoUrl,
        ]);
      });
    }
    db.updateData();

    showSnackBar();
  }

  // update record
  void updateRestaurant(int i) {
    final restaurant = db.restaurantList[i];
    RestaurantRecord record = RestaurantRecord(
        name: restaurant[0], address: restaurant[1], logoUrl: restaurant[2]);

    showDialog(
        context: context,
        builder: (contest) {
          return FormDialog(
            isEditing: true,
            initialRecord: record,
            onRecordSaved: (savedRecord) {
              // Handle saved record within the app
              // Update UI, store record in database, etc.
              saveRestaurantRecord(savedRecord, true, i);
            },
          );
        });
  }

  // delete record
  void _deleteRecord(int i) {
    setState(() {
      db.restaurantList.removeAt(i);
    });
    db.updateData();
  }

  // Show response message
  void showSnackBar() {
    const snackBar = SnackBar(
      content: Text('Restaurant saved!'),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('Restaurant'));
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Restaurants',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: db.restaurantList.isNotEmpty
                  ? ListView.builder(
                      itemCount: db.restaurantList.length,
                      itemBuilder: (context, i) {
                        return RestaurantTile(
                          name: db.restaurantList[i][0].toString(),
                          address: db.restaurantList[i][1].toString(),
                          logoUrl: db.restaurantList[i][2].toString(),
                          updateRecord: () => {updateRestaurant(i)},
                          deleteRecord: (context) => _deleteRecord(i),
                        );
                      })
                  : const Text("No records found."),
            )
          ])),

      // Create button
      floatingActionButton: FloatingActionButton(
        onPressed: createNewRestaurant,
        backgroundColor: const Color.fromRGBO(59, 178, 115, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Icon(Icons.add_sharp),
      ),
    );
  }
}
