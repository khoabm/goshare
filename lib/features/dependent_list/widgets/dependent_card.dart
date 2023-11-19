import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/theme/pallet.dart';

class DependentCard extends StatelessWidget {
  final DependentModel? dependentModel;
  const DependentCard({
    super.key,
    this.dependentModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD9D9D9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  dependentModel?.name ?? '',
                ),
                Text(
                  'Số điện thoại: ${dependentModel?.phone}',
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              context.pop(dependentModel);
            },
            splashColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: 60,
              width: 60, // Adjust the height as needed
              decoration: const BoxDecoration(
                color: Pallete.primaryColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
