class ExpenseModel {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? categoryId;
  String? amount;

  ExpenseModel(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.categoryId,
      this.amount});

  factory ExpenseModel.fromMap(map) {
    return ExpenseModel(
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
