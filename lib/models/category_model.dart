class CategoryModel {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? type;

  CategoryModel({this.id, this.userId, this.name, this.description, this.type});

  factory CategoryModel.fromMap(map) {
    return CategoryModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      description: map['description'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'type': type,
    };
  }
}
