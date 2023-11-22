class TripModel {
  final String? id;
  final String? passengerId;
  final String? driverId;
  final String? startLocationId;
  final String? endLocationId;
  // int startTime;
  // int endTime;
  // int pickupTime;
  final double? distance;
  final double? price;
  final String? cartypeId;
  final int? status;
  // int createTime;
  // int updatedTime;
  final int? paymentMethod;
  final String? bookerId;
  String? note;
  // Driver driver;
  final Passenger? passenger;
  final Booker? booker;
  final Location? endLocation;
  final Location? startLocation;
  final CarType? cartype;

  TripModel({
    this.id,
    this.passengerId,
    this.driverId,
    this.startLocationId,
    this.endLocationId,
    // required this.startTime,
    // required this.endTime,
    // required this.pickupTime,
    this.distance,
    this.price,
    this.cartypeId,
    this.status,
    // required this.createTime,
    // required this.updatedTime,
    this.paymentMethod,
    this.bookerId,
    this.note,
    // required this.driver,
    this.passenger,
    this.booker,
    this.endLocation,
    this.startLocation,
    this.cartype,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      passengerId: json['passengerId'] ?? '',
      driverId: json['driverId'] ?? '',
      startLocationId: json['startLocationId'] ?? '',
      endLocationId: json['endLocationId'] ?? '',
      // startTime: json['startTime'],
      // endTime: json['endTime'],
      // pickupTime: json['pickupTime'],
      distance: json['distance']?.toDouble() ?? 0.0,
      price: json['price']?.toDouble() ?? 0.0,
      cartypeId: json['cartypeId'] ?? '',
      status: json['status'] ?? 1,
      // createTime: json['createTime'],
      // updatedTime: json['updatedTime'],
      paymentMethod: json['paymentMethod'] ?? 2,
      bookerId: json['bookerId'] ?? '',
      note: json['note'] ?? '',
      // driver: Driver.fromJson(json['driver']),
      //passenger: Passenger?.fromJson(json['passenger']),
      //booker: Booker?.fromJson(json['booker']),
      // endLocation: Location?.fromJson(json['endLocation']),
      // startLocation: Location?.fromJson(json['startLocation']),
      // cartype: CarType?.fromJson(json['cartype']),
    );
  }
}

class Booker {
  final String? id;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final String? guardianId;
  final int? status;
  // int createTime;
  // int updatedTime;
  final int? gender;
  // int birth;
  // Car car;
  final Guardian? guardian;

  Booker({
    this.id,
    this.name,
    this.phone,
    this.avatarUrl,
    this.guardianId,
    this.status,
    // required this.createTime,
    // required this.updatedTime,
    this.gender,
    // required this.birth,
    // required this.car,
    this.guardian,
  });

  factory Booker.fromJson(Map<String, dynamic> json) {
    return Booker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      guardianId: json['guardianId'] ?? '',
      status: json['status'] ?? 0,
      // createTime: json['createTime'],
      // updatedTime: json['updatedTime'],
      gender: json['gender'] ?? 1,
      // birth: json['birth'],
      // car: Car.fromJson(json['car']),
      guardian: Guardian?.fromJson(json['guardian']),
    );
  }
}

class Passenger {
  final String? id;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final String? guardianId;
  final int? status;
  // int createTime;
  // int updatedTime;
  final int? gender;
  // int birth;
  // Car car;
  final Guardian? guardian;

  Passenger({
    this.id,
    this.name,
    this.phone,
    this.avatarUrl,
    this.guardianId,
    this.status,
    // required this.createTime,
    // required this.updatedTime,
    this.gender,
    // required this.birth,
    // required this.car,
    this.guardian,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      guardianId: json['guardianId'] ?? '',
      status: json['status'] ?? 0,
      // createTime: json['createTime'],
      // updatedTime: json['updatedTime'],
      gender: json['gender'] ?? 1,
      // birth: json['birth'],
      // car: Car.fromJson(json['car']),
      guardian: Guardian?.fromJson(json['guardian']),
    );
  }
}

class Guardian {
  final String? id;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  //String guardianId;
  final int? status;
  // int createTime;
  // int updatedTime;
  final int? gender;
  // int birth;
  // Car car;
  // Guardian guardian;

  Guardian({
    this.id,
    this.name,
    this.phone,
    this.avatarUrl,
    //required this.guardianId,
    this.status,
    // required this.createTime,
    // required this.updatedTime,
    this.gender,
    // required this.birth,
    // required this.car,
    // required this.guardian,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      //guardianId: json['guardianId'],
      status: json['status'] ?? 0,
      // createTime: json['createTime'],
      // updatedTime: json['updatedTime'],
      gender: json['gender'] ?? 1,
      // birth: json['birth'],
      // car: Car.fromJson(json['car']),
      // guardian: Guardian.fromJson(json['guardian']),
    );
  }
}

class Location {
  final String? id;
  final String? userId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? type;
  // int createTime;
  // int updatedTime;

  Location({
    this.id,
    this.userId,
    this.address,
    this.latitude,
    this.longitude,
    this.type,
    // required this.createTime,
    // required this.updatedTime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      type: json['type'] ?? 1,
      // createTime: json['createTime'],
      // updatedTime: json['updatedTime'],
    );
  }
}

class CarType {
  final int? capacity;

  CarType({
    this.capacity,
  });

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(
      capacity: json['capacity'] ?? 4,
    );
  }
}
