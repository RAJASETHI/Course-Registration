import 'dart:convert';

class Admin {
  String? userId;
  String? name;
  Admin({
    this.userId,
    this.name,
  });
  

  Admin copyWith({
    String? userId,
    String? name,
  }) {
    return Admin(
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      userId: map['userId'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source));

  @override
  String toString() => 'Admin(userId: $userId, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Admin &&
      other.userId == userId &&
      other.name == name;
  }

  @override
  int get hashCode => userId.hashCode ^ name.hashCode;
}
