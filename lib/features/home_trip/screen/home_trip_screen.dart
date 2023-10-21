import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/back_leading.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/features/signup/screen/sign_up_screen.dart';

class HomeTripScreen extends ConsumerStatefulWidget {
  const HomeTripScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTripScreenState();
}

class _HomeTripScreenState extends ConsumerState<HomeTripScreen> {
  final TextEditingController _addressTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackLeading(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HomeCenterContainer(
          verticalPadding: 24.0,
          horizontalPadding: 24.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LeftSideText(
                title: 'Số người đi với bạn',
              ),
              const CounterWidget(),
              const SizedBox(
                height: 20,
              ),
              const LeftSideText(
                title: 'Nhập địa chỉ nhà',
              ),
              AppTextField(
                controller: _addressTextController,
                hintText: 'Địa chỉ nhà',
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search_outlined,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Expanded(
                child: Placeholder(),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AppButton(
                  buttonText: 'Tiếp tục',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final counterProvider = StateNotifierProvider<Counter, int>((ref) => Counter());

class Counter extends StateNotifier<int> {
  Counter() : super(1);

  void increment() {
    if (state < 6) {
      state++;
    }
  }

  void decrement() {
    if (state > 1) {
      state--;
    }
  }
}

class CounterWidget extends ConsumerWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.grey[300],
          child: IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => ref.read(counterProvider.notifier).decrement(),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          '$counter',
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          color: Colors.grey[300],
          child: IconButton(
            icon: const Icon(
              IconData(
                0xf489,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
            ),
            onPressed: () => ref.read(counterProvider.notifier).increment(),
          ),
        ),
      ],
    );
  }
}

// class Counter extends StatefulWidget {
//   const Counter({super.key});

//   @override
//   State<Counter> createState() => _CounterState();
// }

// class _CounterState extends State<Counter> {
//   int _counter = 1;

//   void _incrementCounter() {
//     setState(() {
//       if (_counter < 6) {
//         _counter++;
//       }
//     });
//   }

//   void _decrementCounter() {
//     setState(() {
//       if (_counter > 1) {
//         _counter--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.remove),
//           onPressed: _decrementCounter,
//         ),
//         Text('$_counter', style: const TextStyle(fontSize: 22)),
//         IconButton(
//           icon: const Icon(
//             IconData(
//               0xf489,
//               fontFamily: CupertinoIcons.iconFont,
//               fontPackage: CupertinoIcons.iconFontPackage,
//             ),
//           ),
//           onPressed: _incrementCounter,
//         ),
//       ],
//     );
//   }
// }
