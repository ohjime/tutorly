import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rive/rive.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

Widget introStep(BuildContext context, GlobalKey<FormBuilderState> formKey) {
  final List<Widget> fancyCards = <Widget>[
    FancyCard(
      image: RiveAnimation.asset("assets/animations/onboarding/cooked.riv"),
      title: "Say goodbye to falling behind!",
    ),
    FancyCard(
      image: RiveAnimation.asset("assets/animations/onboarding/teacher.riv"),
      title: "One app to manage all your Tutoring needs!",
    ),
  ];
  return IntroStep(fancyCards: fancyCards, formKey: formKey);
}

class IntroStep extends StatelessWidget {
  const IntroStep({super.key, required this.fancyCards, required this.formKey});

  final List<Widget> fancyCards;
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        child: StackedCardCarousel(
          type: StackedCardCarouselType.fadeOutStack,
          initialOffset: 0,
          pageController: PageController(initialPage: 5),
          // spaceBetweenItems: MediaQuery.of(context).size.height,
          applyTextScaleFactor: true,
          items: fancyCards,
          // type: StackedCardCarouselType.,
        ),
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({super.key, required this.image, required this.title});
  final RiveAnimation image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondaryFixedDim,
          width: 6.0,
        ),
      ),
      color: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: image,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
