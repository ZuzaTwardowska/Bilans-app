class IncomeModel {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? categoryId;
  String? amount;

  IncomeModel(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.categoryId,
      this.amount});

  factory IncomeModel.fromMap(map) {
    return IncomeModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      description: map['description'],
      categoryId: map['categoryId'],
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'amount': amount,
    };
  }
}
