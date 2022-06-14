class Category {

  String name;
  String id;

  Category({required this.name, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'].toString(),
    name: json['name'],
  );

}