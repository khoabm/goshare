import 'package:flutter/material.dart';
import 'package:goshare/models/trip_model.dart';

class TripPicturesWidget extends StatelessWidget {
  final List<TripImages?>? images;
  const TripPicturesWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    print(images?.toList());
    return images != null && images?.length != 0
        ? SizedBox(
            child: Column(
              children: [
                const Divider(
                  color: Colors.grey,
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ảnh của chuyến đi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Image.network(
                  images
                          ?.firstWhere((element) => element?.type == 0)!
                          .imageUrl ??
                      '',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Image.network(
                  images
                          ?.firstWhere((element) => element?.type == 1)!
                          .imageUrl ??
                      '',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          )
        : const SizedBox(
            child: Center(
              child: Text("LỖI - KHÔNG CÓ HÌNH"),
            ),
          );
  }
}
