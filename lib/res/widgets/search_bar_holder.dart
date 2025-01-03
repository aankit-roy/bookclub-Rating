import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class SearchBarHolder extends StatelessWidget {
//   const SearchBarHolder({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 46.h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.search, color: AppColors.textPrimary),
//                 const SizedBox(width: 8.0),
//                 Text(
//                   'Search by book title, author, or category...',
//                   style: TextStyle(
//                       fontSize: TextSizes.titleMedium,
//                       fontWeight: FontWeight.w800),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }