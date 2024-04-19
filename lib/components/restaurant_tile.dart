import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RestaurantTile extends StatelessWidget {
  final String name;
  final String address;
  final String logoUrl;
  final void Function()? updateRecord;
  final Function(BuildContext)? deleteRecord;

  const RestaurantTile({
    super.key,
    required this.name,
    required this.address,
    required this.logoUrl,
    required this.updateRecord,
    required this.deleteRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteRecord,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(230, 232, 230, 1),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(38, 70, 83, 0.6),
                  // child: const Text('NH'),
                  foregroundImage: NetworkImage((logoUrl.isEmpty)
                      ? 'https://cdn.pixabay.com/photo/2016/10/08/18/35/restaurant-1724294_1280.png'
                      : logoUrl),
                  //     'https://img.freepik.com/free-psd/engraved-black-logo-mockup_125540-223.jpg'),
                  // foregroundImage: AssetImage('lib/images/restaurant.png'),
                  maxRadius: 25,
                ),
                title: Text(name),
                subtitle: Text(address),
                onTap: updateRecord),
          ),
        ));
  }
}
