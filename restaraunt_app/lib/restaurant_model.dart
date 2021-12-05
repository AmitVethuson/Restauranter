class RestaurantModel {
  String name;
  String? rating;
  String address;
  String image;
  List<String>? hours;
  int waitTime = 0;
  RestaurantModel(this.name, this.rating, this.address, this.image, this.hours);
}
