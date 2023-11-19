// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:goshare/features/home/widgets/location_card.dart';

// final tabProvider = StateProvider<int>(
//   (ref) => 0,
// );

// class HomeTabBar extends ConsumerStatefulWidget {
//   const HomeTabBar({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabBarState();
// }

// class _HomeTabBarState extends ConsumerState<HomeTabBar>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   @override
//   void initState() {
//     super.initState();
//     ref.read(
//       tabProvider,
//     );
//     _tabController = TabController(
//       length: 2,
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           tabs: const [
//             Tab(
//               icon: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.location_on_outlined),
//                   SizedBox(width: 5), // You can adjust this value as needed
//                   Text(
//                     'Chọn điểm đến',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Tab(
//               icon: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     IconData(0xe050, fontFamily: 'MaterialIcons'),
//                   ),
//                   SizedBox(width: 5), // You can adjust this value as needed
//                   Text(
//                     'Tạo điểm đến',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 12,
//           ),
//           height: MediaQuery.of(context).size.height * .8,
//           child: TabBarView(
//             controller: _tabController,
//             children: _tabController.length > 0
//                 ? [
//                     const Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12,
//                           ),
//                           child: LocationCard(),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12,
//                           ),
//                           child: LocationCard(),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12,
//                           ),
//                           child: LocationCard(),
//                         ),
//                       ],
//                     ),
//                     Container(),
//                   ]
//                 : [Container()],
//           ),
//         ),
//       ],
//     );
//   }
// }
