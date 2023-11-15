import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class LocationDisplayDemo extends ConsumerStatefulWidget {
  // final String longitude;
  // final String latitude;
  final String refId;
  const LocationDisplayDemo({
    super.key,
    // required this.longitude,
    // required this.latitude,
    required this.refId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationDisplayDemoState();
}

class _LocationDisplayDemoState extends ConsumerState<LocationDisplayDemo> {
  @override
  void initState() {
    super.initState();

    // buildRoute();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   Location.instance.requestPermission();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
