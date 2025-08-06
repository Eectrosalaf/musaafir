import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      image: 'images/a.jpg',
      title: 'Life is short and the world is ',
      highlight: 'wide',
      desc:
          'At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world',
      button: 'Get Started',
    ),
    _OnboardData(
      image: 'images/aa.jpg',
      title: 'It’s a big world out there go ',
      highlight: 'explore',
      desc:
          'To get the best of your adventure you just need to leave and go where you like. we are waiting for you',
      button: 'Next',
    ),
    _OnboardData(
      image: 'images/aaa.jpg',
      title: 'People don’t take trips, trips take ',
      highlight: 'people',
      desc:
          'To get the best of your adventure you just need to leave and go where you like. we are waiting for you',
      button: 'Next',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final double imageHeight = SizeConfig.screenH! * 0.5;
    final double borderRadius = 32.0;

    return Scaffold(
      backgroundColor: DesignColors.backgroundColor,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (context, i) {
            final data = _pages[i];
            return Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      child: Image.asset(
                        data.image,
                        width: SizeConfig.screenW,
                        height: imageHeight * 1.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (i > 0)
                      Positioned(
                        top: SizeConfig.blockV! * 2,
                        right: SizeConfig.blockH! * 4,
                        child: TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed('/login'),
                          child: const Text('Skip'),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockH! * 7,
                      vertical: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: SizeConfig.blockV! * 4),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: SizeConfig.blockH! * 6,
                              fontWeight: FontWeight.bold,
                              color: DesignColors.textColor,
                            ),
                            children: [
                              TextSpan(text: data.title),
                              TextSpan(
                                text: data.highlight,
                                style: TextStyle(
                                  color: DesignColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 2),
                        Text(
                          data.desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: SizeConfig.blockH! * 4,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockH! * 0.5,
                              ),
                              width: _currentPage == index
                                  ? SizeConfig.blockH! * 8
                                  : SizeConfig.blockH! * 3,
                              height: SizeConfig.blockH! * 2,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? DesignColors.primaryColor
                                    : DesignColors.backgroundColorInactive,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 3),
                        SizedBox(
                          width: double.infinity,
                          //height: ,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DesignColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockV! * 2,
                              ),
                            ),
                            onPressed: _onNext,
                            child: Text(
                              data.button,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockH! * 4.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 3),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardData {
  final String image, title, highlight, desc, button;
  _OnboardData({
    required this.image,
    required this.title,
    required this.highlight,
    required this.desc,
    required this.button,
  });
}
