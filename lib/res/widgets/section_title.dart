import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.sp,vertical: 12.sp),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.0.sp),
            height: 22.sp,
            width: 4.sp,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4.0)
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: TextSizes.titleLarge, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
