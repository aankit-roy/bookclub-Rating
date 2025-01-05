

import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_constants.dart';
import 'package:bookclub/screens/root_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int counterIndex = 0;


  SharedPreferences? _prefs;



 // Add loading state
  bool _isLoading = false;
  //
  // // void _navigateToRoot(BuildContext context) async {
  // //   setState(() {
  // //     _isLoading = true; // Set loading to true when navigation starts
  // //   });
  // //
  // //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  // //   final loadingProvider = Provider.of<GeneralProvider>(context, listen: false);
  // //   loadingProvider.setLoading(true);
  // //   prefs.setBool('isFirstTimeOpen', false); // Set the flag to false after onboarding
  // //   Navigator.pushReplacement(
  // //     context,
  // //     MaterialPageRoute(
  // //       builder: (_) => const RootScreen(),
  // //     ),
  // //   ).then((_) {
  // //     loadingProvider.setLoading(false);
  // //     setState(() {
  // //       _isLoading = false; // Reset loading state when done
  // //     });
  // //   });
  // // }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft,child: RootScreen()));

              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                counterIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(
                image: 'assets/images/first.jpg',
                title: TextConstants.titleOne,
                description: TextConstants.descriptionOne,
              ),
              createPage(
                image: 'assets/images/second.jpg',
                title: TextConstants.titleTwo,
                description: TextConstants.descriptionTwo,
              ),
              createPage(
                image: 'assets/images/fourth.png',
                title: TextConstants.titleThree,
                description: TextConstants.descriptionThree,
              ),

            ],
          ),
          Positioned(
              bottom: 85,
              left: 30,
              child: Row(
                children: _buildIndicator(),
              )),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,

              ),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    if(counterIndex<2) {
                      counterIndex++;

                      if (counterIndex < 3) {
                        _pageController.nextPage(duration: const Duration(
                            milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                    }
                    else{
                      // _navigateToRoot(context);
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft,child: const RootScreen()));

                    }

                  });

                },
                icon: const Icon(Icons.arrow_forward,size: 25,color: Colors.white,),
              ),

            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color:AppColors.primary,
              ), // Show loading indicator during navigation
            ),

        ],
      ),
    );
  }

  //create indicator list;
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 3; i++) {
      if (counterIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const createPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50.sp, right: 50.sp, bottom: 100.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 3,

            child: Container(

              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
            ),
          ),
           SizedBox(
            height: 20.sp,
          ),
          Flexible(
            child: Text(
              title,
              style:  TextStyle(
                  fontSize: 32.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
           SizedBox(
            height: 20.sp,
          ),
          Flexible(
            child: Text(
              description,
              style:  TextStyle(
                fontSize: 18.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


}

//create indicator decoration widget
Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 10.0,
    width: isActive ? 20 : 8,
    margin: const EdgeInsets.only(right: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: AppColors.primary,
    ),
  );
}
