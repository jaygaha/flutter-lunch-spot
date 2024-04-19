// lunch data record model
class LunchRecord {
  final DateTime lunchAt;
  final int restarurantId;
  final String restaurantName;
  // TODO: male relationship one to many
  // final List<RestaurantRecord> restaurants;
  final DateTime createdAt;

  const LunchRecord(
      {required this.lunchAt,
      required this.restarurantId,
      required this.restaurantName,
      required this.createdAt});
}
