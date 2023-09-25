class ItemInfo{
  final int id;
  final String item_name;
  final int categories;
  final int price;
  final String description;
  final String date;
  final int quantity;

ItemInfo({
 required this.id,
  required this.categories,
  required this.price,
  required this.description,
  required this.quantity,
  required this.date,
  required this.item_name,

});

factory ItemInfo.fromJson(Map<String, dynamic> json){

  return ItemInfo(

      id: json['id'],
      item_name: json['item_name'],
      price: json['price'],
      quantity:json['quantity'],
      description: json['description'],
      date: json['date_created'],
      categories: json['categories']);

}



}