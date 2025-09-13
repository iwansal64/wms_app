import 'package:wms_app/utils/util.dart';

class User {
  final String? id;
  final String? username;
  final String? email;

  User({ this.id, this.username, this.email });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data["id"],
      username: data["username"],
      email: data["email"]
    );
  }
}

class Device {
  final bool isValid;

  final String id;
  final String deviceName;
  final String description;
  final DateTime createdAt;

  Device({ required this.id, required this.deviceName, required this.createdAt, required this.description, required this.isValid });

  factory Device.fromJson(Map<String, dynamic> data) {
    bool isValid = true;

    if(!data.containsKey("id") || !data.containsKey("device_name") || !data.containsKey("created_at"))  {
      isValid = false;
    }

    DateTime createdAt = (data["created_at"] != null) ? DateTime.parse(data["created_at"]) : DateTime.now();
    
    return Device(
      id: data["id"] ?? "",
      deviceName: data["device_name"] ?? "",
      createdAt: createdAt,
      description: data["description"] ?? "",
      isValid: isValid
    );
  }
}