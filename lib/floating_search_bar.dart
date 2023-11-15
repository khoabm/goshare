import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/models/vietmap_autocomplete_model.dart';

class FloatingSearchBar extends ConsumerWidget {
  final Function(VietmapAutocompleteModel) onSearchItemClick;
  final FocusNode focusNode;
  const FloatingSearchBar(
      {super.key, required this.onSearchItemClick, required this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 20,
      height: 50,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            focusNode: focusNode,
            autofocus: false,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                hintText: 'Nhập địa chỉ...',
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)))),
        suggestionsCallback: (pattern) async {
          if (pattern.isNotEmpty) {
            var data = await ref
                .watch(homeControllerProvider.notifier)
                .searchLocation(context, pattern);

            // SearchAddressUseCase(VietmapApiRepositories())
            //     .call(pattern);
            // var res = <VietmapAutocompleteModel>[];
            // data.fold((l) {
            //   res = [];
            // }, (r) {
            //   res = r;
            // });
            return data;
          }
          return <VietmapAutocompleteModel>[];
        },
        itemBuilder: (context, VietmapAutocompleteModel suggestion) {
          return ListTile(
            leading: const Icon(Icons.location_on),
            contentPadding: EdgeInsets.zero,
            title: Text(suggestion.name ?? ''),
            subtitle: Text(suggestion.address ?? ''),
          );
        },
        noItemsFoundBuilder: (context) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Không tìm thấy địa chỉ này.',
              style: TextStyle(fontSize: 17),
            ),
          );
        },
        onSuggestionSelected: onSearchItemClick,
      ),
    );
  }
}
