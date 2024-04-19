import 'package:hive_flutter/hive_flutter.dart';

class LunchSpotsDatabase {
  List restaurantList = [];
  List lunchList = [];

  // reference the box
  final _hiveBox = Hive.box('lunchSpots');

  // run this method if this is the 1st time ever openning this app
  void initData() {
    restaurantList = [
      [
        "Cabe",
        "Tokyo, Shinagawa City, Kamiosaki, 3-5-4 第１ 田中ビル 2F",
        "https://cdn0.tablecheck.com/shops/5fadf09039d4ad01f067226b/tc_header_images/lg/cabeecoHP%E3%83%AD%E3%82%B4-2.png?1611742928"
      ],
      [
        "ONE THE DINER",
        "Tokyo, Shinagawa City, Kamiosaki, 1-1-14 トーカン白金キャステール1階",
        "https://www.one-thediner.com/shared/img/share/logo_footer.png"
      ],
      [
        "Shin Meguro Chaya",
        "2-13-22 Kamiosaki, Shinagawa City, Tokyo 141-0021",
        ""
      ],
      [
        "Hidakaya",
        "2-13-35 Kamiosaki, Shinagawa City, Tokyo 141-0021",
        "https://hidakaya.hiday.co.jp/hits/res/img/sitelogo.png"
      ],
    ];
  }

  // load the data from the database
  void loadData() {
    restaurantList = _hiveBox.get("restaurants");
  }

  // update the database
  void updateData() {
    _hiveBox.put('restaurants', restaurantList);
  }

  // load the data from the database
  void loadLunchData() {
    lunchList = _hiveBox.get("lunches");
  }

  // update the database
  void updateLunchData() {
    _hiveBox.put('lunches', lunchList);
  }
}
