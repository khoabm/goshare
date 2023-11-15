import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/error_text.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/theme/pallet.dart';

class SearchPlacesDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchPlacesDelegate(this.ref);
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.white,
      indicatorColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void navigateToLocationDisplay(BuildContext context, String refId) {
    context.pushNamed(
      'location-display',
      pathParameters: {
        'refId': refId,
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = ref.watch(homeControllerProvider.notifier).searchLocation(
          context,
          query,
        );
    print(data.then((value) {
      print(value.length);
    }));
    // final data = ref.watch(
    //   searchPlaceProvider(
    //     {'query': query},
    //   ).future,
    // );
    return Padding(
      padding: const EdgeInsets.all(
        12.0,
      ),
      child: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loader();
              // case ConnectionState.none:
              // case ConnectionState.active:
              //   break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const ErrorText(errorText: 'Lỗi');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final place = snapshot.data![index];
                      return ListTile(
                          iconColor: Pallete.primaryColor,
                          textColor: Pallete.primaryColor,
                          leading: const Icon(
                            Icons.location_on_outlined,
                          ),
                          title: Text(
                            place.display ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () => navigateToLocationDisplay(
                                context,
                                place.refId ?? '',
                              )
                          // => navigateToLocationDisplay(
                          //   context,
                          //   place.,
                          //   place.lat,
                          // ),
                          );
                    },
                  );
                }
              default:
                return const Center(
                  child: Text(
                    'Có lỗi xảy ra',
                  ),
                );
            }
          }),
    );
    // ref
    //     .watch(searchPlaceProvider({
    //       'query': query,
    //     }))
    //     .when(
    //         data: (places) => places.isEmpty
    //             ? Container()
    //             : ListView.builder(
    //                 itemCount: places.length,
    //                 itemBuilder: (context, index) {
    //                   final place = places[index];
    //                   return ListTile(
    //                     leading: const Icon(
    //                       Icons.location_on_outlined,
    //                     ),
    //                     title: Text(place.displayName),
    //                     onTap: () {},
    //                   );
    //                 }),
    //         error: (error, stackTrace) => ErrorText(
    //               errorText: error.toString(),
    //             ),
    //         loading: () => const Loader());
  }
}
