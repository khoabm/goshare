// class TripModel {
//   final String? id;
//   final String? passengerId;
//   final String? driverId;
//   final String? startLocationId;
//   final String? endLocationId;
//   // int startTime;
//   // int endTime;
//   // int pickupTime;
//   final double? distance;
//   final double? price;
//   final String? cartypeId;
//   final int? status;
//   // int createTime;
//   // int updatedTime;
//   final int? paymentMethod;
//   final String? bookerId;
//   String? note;
//   // Driver driver;
//   final Passenger? passenger;
//   final Booker? booker;
//   final Location? endLocation;
//   final Location? startLocation;
//   final CarType? cartype;

//   TripModel({
//     this.id,
//     this.passengerId,
//     this.driverId,
//     this.startLocationId,
//     this.endLocationId,
//     // required this.startTime,
//     // required this.endTime,
//     // required this.pickupTime,
//     this.distance,
//     this.price,
//     this.cartypeId,
//     this.status,
//     // required this.createTime,
//     // required this.updatedTime,
//     this.paymentMethod,
//     this.bookerId,
//     this.note,
//     // required this.driver,
//     this.passenger,
//     this.booker,
//     this.endLocation,
//     this.startLocation,
//     this.cartype,
//   });

//   factory TripModel.fromJson(Map<String, dynamic> json) {
//     return TripModel(
//       id: json['id'] ?? '',
//       passengerId: json['passengerId'] ?? '',
//       driverId: json['driverId'] ?? '',
//       startLocationId: json['startLocationId'] ?? '',
//       endLocationId: json['endLocationId'] ?? '',
//       // startTime: json['startTime'],
//       // endTime: json['endTime'],
//       // pickupTime: json['pickupTime'],
//       distance: json['distance']?.toDouble() ?? 0.0,
//       price: json['price']?.toDouble() ?? 0.0,
//       cartypeId: json['cartypeId'] ?? '',
//       status: json['status'] ?? 1,
//       // createTime: json['createTime'],
//       // updatedTime: json['updatedTime'],
//       paymentMethod: json['paymentMethod'] ?? 2,
//       bookerId: json['bookerId'] ?? '',
//       note: json['note'] ?? '',
//       // driver: Driver.fromJson(json['driver']),
//       //passenger: Passenger?.fromJson(json['passenger']),
//       //booker: Booker?.fromJson(json['booker']),
//       // endLocation: Location?.fromJson(json['endLocation']),
//       // startLocation: Location?.fromJson(json['startLocation']),
//       // cartype: CarType?.fromJson(json['cartype']),
//     );
//   }
// }

// class Booker {
//   final String? id;
//   final String? name;
//   final String? phone;
//   final String? avatarUrl;
//   final String? guardianId;
//   final int? status;
//   // int createTime;
//   // int updatedTime;
//   final int? gender;
//   // int birth;
//   // Car car;
//   final Guardian? guardian;

//   Booker({
//     this.id,
//     this.name,
//     this.phone,
//     this.avatarUrl,
//     this.guardianId,
//     this.status,
//     // required this.createTime,
//     // required this.updatedTime,
//     this.gender,
//     // required this.birth,
//     // required this.car,
//     this.guardian,
//   });

//   factory Booker.fromJson(Map<String, dynamic> json) {
//     return Booker(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       phone: json['phone'] ?? '',
//       avatarUrl: json['avatarUrl'] ?? '',
//       guardianId: json['guardianId'] ?? '',
//       status: json['status'] ?? 0,
//       // createTime: json['createTime'],
//       // updatedTime: json['updatedTime'],
//       gender: json['gender'] ?? 1,
//       // birth: json['birth'],
//       // car: Car.fromJson(json['car']),
//       guardian: Guardian?.fromJson(json['guardian']),
//     );
//   }
// }

// class Passenger {
//   final String? id;
//   final String? name;
//   final String? phone;
//   final String? avatarUrl;
//   final String? guardianId;
//   final int? status;
//   // int createTime;
//   // int updatedTime;
//   final int? gender;
//   // int birth;
//   // Car car;
//   final Guardian? guardian;

//   Passenger({
//     this.id,
//     this.name,
//     this.phone,
//     this.avatarUrl,
//     this.guardianId,
//     this.status,
//     // required this.createTime,
//     // required this.updatedTime,
//     this.gender,
//     // required this.birth,
//     // required this.car,
//     this.guardian,
//   });

//   factory Passenger.fromJson(Map<String, dynamic> json) {
//     return Passenger(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       phone: json['phone'] ?? '',
//       avatarUrl: json['avatarUrl'] ?? '',
//       guardianId: json['guardianId'] ?? '',
//       status: json['status'] ?? 0,
//       // createTime: json['createTime'],
//       // updatedTime: json['updatedTime'],
//       gender: json['gender'] ?? 1,
//       // birth: json['birth'],
//       // car: Car.fromJson(json['car']),
//       guardian: Guardian?.fromJson(json['guardian']),
//     );
//   }
// }

// class Guardian {
//   final String? id;
//   final String? name;
//   final String? phone;
//   final String? avatarUrl;
//   //String guardianId;
//   final int? status;
//   // int createTime;
//   // int updatedTime;
//   final int? gender;
//   // int birth;
//   // Car car;
//   // Guardian guardian;

//   Guardian({
//     this.id,
//     this.name,
//     this.phone,
//     this.avatarUrl,
//     //required this.guardianId,
//     this.status,
//     // required this.createTime,
//     // required this.updatedTime,
//     this.gender,
//     // required this.birth,
//     // required this.car,
//     // required this.guardian,
//   });

//   factory Guardian.fromJson(Map<String, dynamic> json) {
//     return Guardian(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       phone: json['phone'] ?? '',
//       avatarUrl: json['avatarUrl'] ?? '',
//       //guardianId: json['guardianId'],
//       status: json['status'] ?? 0,
//       // createTime: json['createTime'],
//       // updatedTime: json['updatedTime'],
//       gender: json['gender'] ?? 1,
//       // birth: json['birth'],
//       // car: Car.fromJson(json['car']),
//       // guardian: Guardian.fromJson(json['guardian']),
//     );
//   }
// }

// class Location {
//   final String? id;
//   final String? userId;
//   final String? address;
//   final double? latitude;
//   final double? longitude;
//   final int? type;
//   // int createTime;
//   // int updatedTime;

//   Location({
//     this.id,
//     this.userId,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.type,
//     // required this.createTime,
//     // required this.updatedTime,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] ?? '',
//       userId: json['userId'] ?? '',
//       address: json['address'] ?? '',
//       latitude: json['latitude']?.toDouble() ?? 0.0,
//       longitude: json['longitude']?.toDouble() ?? 0.0,
//       type: json['type'] ?? 1,
//       // createTime: json['createTime'],
//       // updatedTime: json['updatedTime'],
//     );
//   }
// }

// class CarType {
//   final int? capacity;

//   CarType({
//     this.capacity,
//   });

//   factory CarType.fromJson(Map<String, dynamic> json) {
//     return CarType(
//       capacity: json['capacity'] ?? 4,
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/widgets.dart';

class TripModel {
  final String id;
  final String passengerId;
  final String driverId;
  final String startLocationId;
  final String endLocationId;
  // int startTime;
  // int endTime;
  // int pickupTime;
  final double distance;
  final double price;
  final String cartypeId;
  final int status;
  // int createTime;
  // int updatedTime;
  final int paymentMethod;
  final String bookerId;
  String? note;
  Driver? driver;
  final Passenger passenger;
  final Booker booker;
  final EndLocation endLocation;
  final StartLocation startLocation;
  final CarType cartype;
  TripModel({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.startLocationId,
    required this.endLocationId,
    required this.distance,
    required this.price,
    required this.cartypeId,
    required this.status,
    required this.paymentMethod,
    required this.bookerId,
    this.note,
    required this.driver,
    required this.passenger,
    required this.booker,
    required this.endLocation,
    required this.startLocation,
    required this.cartype,
  });

  TripModel copyWith({
    String? id,
    String? passengerId,
    String? driverId,
    String? startLocationId,
    String? endLocationId,
    double? distance,
    double? price,
    String? cartypeId,
    int? status,
    int? paymentMethod,
    String? bookerId,
    ValueGetter<String?>? note,
    ValueGetter<Driver?>? driver,
    Passenger? passenger,
    Booker? booker,
    EndLocation? endLocation,
    StartLocation? startLocation,
    CarType? cartype,
  }) {
    return TripModel(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      startLocationId: startLocationId ?? this.startLocationId,
      endLocationId: endLocationId ?? this.endLocationId,
      distance: distance ?? this.distance,
      price: price ?? this.price,
      cartypeId: cartypeId ?? this.cartypeId,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      bookerId: bookerId ?? this.bookerId,
      note: note?.call() ?? this.note,
      driver: driver?.call() ?? this.driver,
      passenger: passenger ?? this.passenger,
      booker: booker ?? this.booker,
      endLocation: endLocation ?? this.endLocation,
      startLocation: startLocation ?? this.startLocation,
      cartype: cartype ?? this.cartype,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passengerId': passengerId,
      'driverId': driverId,
      'startLocationId': startLocationId,
      'endLocationId': endLocationId,
      'distance': distance,
      'price': price,
      'cartypeId': cartypeId,
      'status': status,
      'paymentMethod': paymentMethod,
      'bookerId': bookerId,
      'note': note,
      'driver': driver?.toMap(),
      'passenger': passenger.toMap(),
      'booker': booker.toMap(),
      'endLocation': endLocation.toMap(),
      'startLocation': startLocation.toMap(),
      'cartype': cartype.toMap(),
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] ?? '',
      passengerId: map['passengerId'] ?? '',
      driverId: map['driverId'] ?? '',
      startLocationId: map['startLocationId'] ?? '',
      endLocationId: map['endLocationId'] ?? '',
      distance: map['distance']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      cartypeId: map['cartypeId'] ?? '',
      status: map['status']?.toInt() ?? 0,
      paymentMethod: map['paymentMethod']?.toInt() ?? 0,
      bookerId: map['bookerId'] ?? '',
      note: map['note'],
      driver: map['driver'] != null ? Driver.fromMap(map['driver']) : null,
      passenger: Passenger.fromMap(map['passenger']),
      booker: Booker.fromMap(map['booker']),
      endLocation: EndLocation.fromMap(map['endLocation']),
      startLocation: StartLocation.fromMap(map['startLocation']),
      cartype: CarType.fromMap(map['cartype']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TripModel.fromJson(String source) =>
      TripModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripModel(id: $id, passengerId: $passengerId, driverId: $driverId, startLocationId: $startLocationId, endLocationId: $endLocationId, distance: $distance, price: $price, cartypeId: $cartypeId, status: $status, paymentMethod: $paymentMethod, bookerId: $bookerId, note: $note, driver: $driver, passenger: $passenger, booker: $booker, endLocation: $endLocation, startLocation: $startLocation, cartype: $cartype)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripModel &&
        other.id == id &&
        other.passengerId == passengerId &&
        other.driverId == driverId &&
        other.startLocationId == startLocationId &&
        other.endLocationId == endLocationId &&
        other.distance == distance &&
        other.price == price &&
        other.cartypeId == cartypeId &&
        other.status == status &&
        other.paymentMethod == paymentMethod &&
        other.bookerId == bookerId &&
        other.note == note &&
        other.driver == driver &&
        other.passenger == passenger &&
        other.booker == booker &&
        other.endLocation == endLocation &&
        other.startLocation == startLocation &&
        other.cartype == cartype;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        passengerId.hashCode ^
        driverId.hashCode ^
        startLocationId.hashCode ^
        endLocationId.hashCode ^
        distance.hashCode ^
        price.hashCode ^
        cartypeId.hashCode ^
        status.hashCode ^
        paymentMethod.hashCode ^
        bookerId.hashCode ^
        note.hashCode ^
        driver.hashCode ^
        passenger.hashCode ^
        booker.hashCode ^
        endLocation.hashCode ^
        startLocation.hashCode ^
        cartype.hashCode;
  }
}

class Passenger {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  Passenger({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
  });
  //final "guardianId": "{string}",
  //"status": {int},
  //"createTime": "{timestamp}",
  //"updatedTime": "{timestamp}",
  //"gender": {int},
  //"birth": "{timestamp}",
  //"car": {},
  //"guardian": {}

  Passenger copyWith({
    String? id,
    String? name,
    String? phone,
    ValueGetter<String?>? avatarUrl,
  }) {
    return Passenger(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl?.call() ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Passenger.fromJson(String source) =>
      Passenger.fromMap(json.decode(source));
}

class Booker {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  Booker({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
  });

  Booker copyWith({
    String? id,
    String? name,
    String? phone,
    ValueGetter<String?>? avatarUrl,
  }) {
    return Booker(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl?.call() ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  factory Booker.fromMap(Map<String, dynamic> map) {
    return Booker(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Booker.fromJson(String source) => Booker.fromMap(json.decode(source));
}

class EndLocation {
  final String id;
  final String userId;
  final String address;
  final double latitude;
  final double longitude;
  EndLocation({
    required this.id,
    required this.userId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  EndLocation copyWith({
    String? id,
    String? userId,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return EndLocation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory EndLocation.fromMap(Map<String, dynamic> map) {
    return EndLocation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EndLocation.fromJson(String source) =>
      EndLocation.fromMap(json.decode(source));
}

class StartLocation {
  final String id;
  final String userId;
  final String address;
  final double latitude;
  final double longitude;
  StartLocation({
    required this.id,
    required this.userId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  StartLocation copyWith({
    String? id,
    String? userId,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return StartLocation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory StartLocation.fromMap(Map<String, dynamic> map) {
    return StartLocation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StartLocation.fromJson(String source) =>
      StartLocation.fromMap(json.decode(source));
}

class CarType {
  final int capacity;
  CarType({
    required this.capacity,
  });

  CarType copyWith({
    int? capacity,
  }) {
    return CarType(
      capacity: capacity ?? this.capacity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity,
    };
  }

  factory CarType.fromMap(Map<String, dynamic> map) {
    return CarType(
      capacity: map['capacity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarType.fromJson(String source) =>
      CarType.fromMap(json.decode(source));
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final Car car;
  Driver({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.car,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? phone,
    ValueGetter<String?>? avatarUrl,
    Car? car,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl?.call() ?? this.avatarUrl,
      car: car ?? this.car,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'car': car.toMap(),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
      car: Car.fromMap(map['car']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Driver.fromJson(String source) => Driver.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Driver(id: $id, name: $name, phone: $phone, avatarUrl: $avatarUrl, car: $car)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Driver &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.avatarUrl == avatarUrl &&
        other.car == car;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        avatarUrl.hashCode ^
        car.hashCode;
  }
}

class Car {
  final String licensePlate;
  final String make;
  final String model;
  Car({
    required this.licensePlate,
    required this.make,
    required this.model,
  });

  Car copyWith({
    String? licensePlate,
    String? make,
    String? model,
  }) {
    return Car(
      licensePlate: licensePlate ?? this.licensePlate,
      make: make ?? this.make,
      model: model ?? this.model,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'licensePlate': licensePlate,
      'make': make,
      'model': model,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      licensePlate: map['licensePlate'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Car.fromJson(String source) => Car.fromMap(json.decode(source));

  @override
  String toString() =>
      'Car(licensePlate: $licensePlate, make: $make, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Car &&
        other.licensePlate == licensePlate &&
        other.make == make &&
        other.model == model;
  }

  @override
  int get hashCode => licensePlate.hashCode ^ make.hashCode ^ model.hashCode;
}
