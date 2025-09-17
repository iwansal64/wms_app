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
  final bool status;

  Device({ required this.id, required this.deviceName, required this.createdAt, required this.description, required this.isValid, required this.status });

  factory Device.fromJson(Map<String, dynamic> data) {
    bool isValid = true;

    if(!data.containsKey("id") || !data.containsKey("device_name") || !data.containsKey("created_at") || !data.containsKey("status"))  {
      isValid = false;
    }

    DateTime createdAt = (data["created_at"] != null) ? DateTime.parse(data["created_at"]) : DateTime.now();
    
    return Device(
      id: data["id"] ?? "",
      deviceName: data["device_name"] ?? "",
      createdAt: createdAt,
      description: data["description"] ?? "",
      status: data["status"] ?? "",
      isValid: isValid,
    );
  }

  Device copyWith({
    String? id,
    String? deviceName,
    DateTime? createdAt,
    String? description,
    bool? status,
  }) {
    return Device(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      status: status ?? this.status,
      isValid: isValid,
    );
  }
}

class Sensor {
  final bool isValid;
  
  final String id;
  final String deviceId;

  int sensorValue = 0;

  Sensor({ required this.id, required this.deviceId, required this.isValid });
  
  factory Sensor.fromJson(Map<String, dynamic> data) {
    bool isValid = true;

    if(!data.containsKey("id") || !data.containsKey("device_id"))  {
      isValid = false;
    }

    return Sensor(
      id: data["id"] ?? "",
      deviceId: data["device_id"] ?? "",
      isValid: isValid
    );
  }
}