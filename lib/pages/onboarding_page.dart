import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _onboardingPages = [
    const OnboardingPage(
      imagePath: 'assets/onboarding/drive_1.jpg',
      title: 'drive_on_your_terms',
      subtitle: 'go_online',
      isLastPage: false,
    ),
    const OnboardingPage(
      imagePath: 'assets/onboarding/drive_2.jpg',
      title: 'smart_navigation_support',
      subtitle: 'no_surprises',
      isLastPage: false,
    ),
    const OnboardingPage(
      imagePath: 'assets/onboarding/drive_3.jpg',
      title: 'safety_and_security',
      subtitle: 'every_trip',
      isLastPage: true,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _getStarted() {
    Navigator.pop(context);
  }

  void _skip() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  _currentPage != _onboardingPages.length - 1
                      ? AppLocalization.instance.getLocalizationFor('skip')
                      : '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _onboardingPages,
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_onboardingPages.length,
                      (int index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 14,
                      width: (index == _currentPage) ? 28 : 14,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: (index == _currentPage)
                            ? theme.dividerColor
                            : cardColor,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  child: CustomButton(
                    label: _currentPage == _onboardingPages.length - 1
                        ? AppLocalization.instance
                            .getLocalizationFor('get_started')
                        : AppLocalization.instance.getLocalizationFor('next'),
                    labelColor: Colors.white,
                    bgColor: Colors.black,
                    onTap: () {
                      if (_currentPage == _onboardingPages.length - 1) {
                        _getStarted();
                      } else {
                        _nextPage();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isLastPage;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 450,
          ),
          const SizedBox(height: 40),
          Text(
            AppLocalization.instance.getLocalizationFor(title),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalization.instance.getLocalizationFor(subtitle),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}
