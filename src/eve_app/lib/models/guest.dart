import 'dart:convert';

class Guest {
  final int id;
  final String firstname;
  final String lastname;
  final bool willCome;
  Guest({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.willCome,
  });

  Guest copyWith({
    int? id,
    String? firstname,
    String? lastname,
    bool? willCome,
  }) {
    return Guest(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      willCome: willCome ?? this.willCome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'willCome': willCome,
    };
  }

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id']?.toInt() ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      willCome: map['willCome'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Guest.fromJson(String source) => Guest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Guest(id: $id, firstname: $firstname, lastname: $lastname, willCome: $willCome)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Guest && other.id == id && other.firstname == firstname && other.lastname == lastname && other.willCome == willCome;
  }

  @override
  int get hashCode {
    return id.hashCode ^ firstname.hashCode ^ lastname.hashCode ^ willCome.hashCode;
  }

  static List<Guest> fromMapList(
    List<dynamic> list,
  ) {
    return list.map((x) => Guest.fromMap(x)).toList();
  }

  String getFullName() {
    String fullName = "$firstname $lastname";
    return fullName;
  }
}
