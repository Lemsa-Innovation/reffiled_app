import 'dart:convert';

class UserProfile {
  String? name;
  String? phoneNumber;
  UserProfile({
    this.name,
    this.phoneNumber,
  });
  String? email;

  UserProfile copyWith({
    String? name,
    String? phoneNumber,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() => 'UserProfile(name: $name, phoneNumber: $phoneNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.name == name &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => name.hashCode ^ phoneNumber.hashCode;
}
