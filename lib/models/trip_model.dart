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

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TripModel {
  final String id;
  final String passengerId;
  final String passengerName;
  final String? passengerPhoneNumber;
  final String driverId;
  final String startLocationId;
  final String endLocationId;
  DateTime startTime;
  DateTime endTime;
  DateTime pickupTime;
  final double distance;
  final double price;
  final String cartypeId;
  final int status;
  DateTime createTime;
  DateTime updatedTime;
  final int paymentMethod;
  final String bookerId;
  String? note;
  final int type;
  Driver? driver;
  final Passenger passenger;
  final Booker booker;
  final EndLocation endLocation;
  final StartLocation startLocation;
  final CarType cartype;
  List<TripImages?>? tripImages;
  TripModel({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    this.passengerPhoneNumber,
    required this.driverId,
    required this.startLocationId,
    required this.endLocationId,
    required this.startTime,
    required this.endTime,
    required this.pickupTime,
    required this.distance,
    required this.price,
    required this.cartypeId,
    required this.status,
    required this.createTime,
    required this.updatedTime,
    required this.paymentMethod,
    required this.bookerId,
    this.note,
    required this.type,
    required this.driver,
    required this.passenger,
    required this.booker,
    required this.endLocation,
    required this.startLocation,
    required this.cartype,
    this.tripImages,
  });

  TripModel copyWith({
    String? id,
    String? passengerId,
    String? passengerName,
    ValueGetter<String?>? passengerPhoneNumber,
    String? driverId,
    String? startLocationId,
    String? endLocationId,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? pickupTime,
    double? distance,
    double? price,
    String? cartypeId,
    int? status,
    DateTime? createTime,
    DateTime? updatedTime,
    int? paymentMethod,
    String? bookerId,
    ValueGetter<String?>? note,
    int? type,
    Driver? driver,
    Passenger? passenger,
    Booker? booker,
    EndLocation? endLocation,
    StartLocation? startLocation,
    CarType? cartype,
    ValueGetter<List<TripImages>?>? tripImages,
  }) {
    return TripModel(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      passengerName: passengerName ?? this.passengerName,
      passengerPhoneNumber:
          passengerPhoneNumber?.call() ?? this.passengerPhoneNumber,
      driverId: driverId ?? this.driverId,
      startLocationId: startLocationId ?? this.startLocationId,
      endLocationId: endLocationId ?? this.endLocationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pickupTime: pickupTime ?? this.pickupTime,
      distance: distance ?? this.distance,
      price: price ?? this.price,
      cartypeId: cartypeId ?? this.cartypeId,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      updatedTime: updatedTime ?? this.updatedTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      bookerId: bookerId ?? this.bookerId,
      note: note?.call() ?? this.note,
      type: type ?? this.type,
      driver: driver ?? this.driver,
      passenger: passenger ?? this.passenger,
      booker: booker ?? this.booker,
      endLocation: endLocation ?? this.endLocation,
      startLocation: startLocation ?? this.startLocation,
      cartype: cartype ?? this.cartype,
      tripImages: tripImages?.call() ?? this.tripImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerPhoneNumber': passengerPhoneNumber,
      'driverId': driverId,
      'startLocationId': startLocationId,
      'endLocationId': endLocationId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'pickupTime': pickupTime.millisecondsSinceEpoch,
      'distance': distance,
      'price': price,
      'cartypeId': cartypeId,
      'status': status,
      'createTime': createTime.millisecondsSinceEpoch,
      'updatedTime': updatedTime.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'bookerId': bookerId,
      'note': note,
      'type': type,
      'driver': driver?.toMap(),
      'passenger': passenger.toMap(),
      'booker': booker.toMap(),
      'endLocation': endLocation.toMap(),
      'startLocation': startLocation.toMap(),
      'cartype': cartype.toMap(),
      'tripImages': tripImages?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    print('CAST TRIP MODEL');
    print(map.toString());
    return TripModel(
      id: map['id'] ?? '',
      passengerId: map['passengerId'] ?? '',
      passengerName: map['passengerName'] ?? '',
      passengerPhoneNumber: map['passengerPhoneNumber'],
      driverId: map['driverId'] ?? '',
      startLocationId: map['startLocationId'] ?? '',
      endLocationId: map['endLocationId'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['startTime']).millisecondsSinceEpoch,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['endTime']).millisecondsSinceEpoch,
      ),
      pickupTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['pickupTime']).millisecondsSinceEpoch,
      ),
      distance: map['distance']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      cartypeId: map['cartypeId'] ?? '',
      status: map['status']?.toInt() ?? 0,
      createTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['createTime']).millisecondsSinceEpoch,
      ),
      updatedTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['updatedTime']).millisecondsSinceEpoch,
      ),
      paymentMethod: map['paymentMethod']?.toInt() ?? 0,
      bookerId: map['bookerId'] ?? '',
      note: map['note'],
      type: map['type']?.toInt() ?? 0,
      driver: map['driver'] != null ? Driver.fromMap(map['driver']) : null,
      passenger: Passenger.fromMap(map['passenger']),
      booker: Booker.fromMap(map['booker']),
      endLocation: EndLocation.fromMap(map['endLocation']),
      startLocation: StartLocation.fromMap(map['startLocation']),
      cartype: CarType.fromMap(map['cartype']),
      tripImages: map['tripImages'] != null
          ? List<TripImages>.from(
              map['tripImages']?.map((x) => TripImages.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripModel.fromJson(String source) =>
      TripModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripModel(id: $id, passengerId: $passengerId, passengerName: $passengerName, passengerPhoneNumber: $passengerPhoneNumber, driverId: $driverId, startLocationId: $startLocationId, endLocationId: $endLocationId, startTime: $startTime, endTime: $endTime, pickupTime: $pickupTime, distance: $distance, price: $price, cartypeId: $cartypeId, status: $status, createTime: $createTime, updatedTime: $updatedTime, paymentMethod: $paymentMethod, bookerId: $bookerId, note: $note, type: $type, driver: $driver, passenger: $passenger, booker: $booker, endLocation: $endLocation, startLocation: $startLocation, cartype: $cartype, tripImages: $tripImages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripModel &&
        other.id == id &&
        other.passengerId == passengerId &&
        other.passengerName == passengerName &&
        other.passengerPhoneNumber == passengerPhoneNumber &&
        other.driverId == driverId &&
        other.startLocationId == startLocationId &&
        other.endLocationId == endLocationId &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.pickupTime == pickupTime &&
        other.distance == distance &&
        other.price == price &&
        other.cartypeId == cartypeId &&
        other.status == status &&
        other.createTime == createTime &&
        other.updatedTime == updatedTime &&
        other.paymentMethod == paymentMethod &&
        other.bookerId == bookerId &&
        other.note == note &&
        other.type == type &&
        other.driver == driver &&
        other.passenger == passenger &&
        other.booker == booker &&
        other.endLocation == endLocation &&
        other.startLocation == startLocation &&
        other.cartype == cartype &&
        listEquals(other.tripImages, tripImages);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        passengerId.hashCode ^
        passengerName.hashCode ^
        passengerPhoneNumber.hashCode ^
        driverId.hashCode ^
        startLocationId.hashCode ^
        endLocationId.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        pickupTime.hashCode ^
        distance.hashCode ^
        price.hashCode ^
        cartypeId.hashCode ^
        status.hashCode ^
        createTime.hashCode ^
        updatedTime.hashCode ^
        paymentMethod.hashCode ^
        bookerId.hashCode ^
        note.hashCode ^
        type.hashCode ^
        driver.hashCode ^
        passenger.hashCode ^
        booker.hashCode ^
        endLocation.hashCode ^
        startLocation.hashCode ^
        cartype.hashCode ^
        tripImages.hashCode;
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
    print('CAST PASSENGER MODEL');
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
    print('CAST BOOKER MODEL');
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
    print('CAST EndLocation MODEL');
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
    print("CAST StartLocation MODEL");
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
    print('CAST CarType MODEL');
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
  final Car? car;
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
    ValueGetter<Car?>? car,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl?.call() ?? this.avatarUrl,
      car: car?.call() ?? this.car,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'car': car?.toMap(),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
      car: map['car'] != null ? Car.fromMap(map['car']) : null,
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

class TripImages {
  final String id;
  final String tripId;
  final String imageUrl;
  final int type;
  final DateTime createTime;
  final DateTime updatedTime;
  TripImages({
    required this.id,
    required this.tripId,
    required this.imageUrl,
    required this.type,
    required this.createTime,
    required this.updatedTime,
  });

  TripImages copyWith({
    String? id,
    String? tripId,
    String? imageUrl,
    int? type,
    DateTime? createTime,
    DateTime? updatedTime,
  }) {
    return TripImages(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      createTime: createTime ?? this.createTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'imageUrl': imageUrl,
      'type': type,
      'createTime': createTime.millisecondsSinceEpoch,
      'updatedTime': updatedTime.millisecondsSinceEpoch,
    };
  }

  factory TripImages.fromMap(Map<String, dynamic> map) {
    print('CAST TRIP IMAGE MODEL');

    return TripImages(
      id: map['id'] ?? '',
      tripId: map['tripId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      type: map['type']?.toInt() ?? 0,
      createTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['createTime']).millisecondsSinceEpoch,
      ),
      updatedTime: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['updatedTime']).millisecondsSinceEpoch,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TripImages.fromJson(String source) =>
      TripImages.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripImages(id: $id, tripId: $tripId, imageUrl: $imageUrl, type: $type, createTime: $createTime, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripImages &&
        other.id == id &&
        other.tripId == tripId &&
        other.imageUrl == imageUrl &&
        other.type == type &&
        other.createTime == createTime &&
        other.updatedTime == updatedTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tripId.hashCode ^
        imageUrl.hashCode ^
        type.hashCode ^
        createTime.hashCode ^
        updatedTime.hashCode;
  }
}
