import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/services.dart';
import 'package:tutorly/onboarding/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class BillingForm extends StatefulWidget {
  final String uid;
  const BillingForm({super.key, required this.uid});

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Controllers for live updates in the preview card.
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cardExpiryDateController =
      TextEditingController();
  final TextEditingController cardCvvController = TextEditingController();

  final FlipCardController flipCardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    const Color kDarkBlue = Color(0xFF090943);
    bool frontIsFlipped = true;
    return Column(
      children: [
        // Credit Card Preview remains the same.
        SizedBox(
          width: 400,
          child: FlipCard(
            fill: Fill.fillFront,
            direction: FlipDirection.HORIZONTAL,
            controller: flipCardController,
            onFlip: () {},
            flipOnTouch: false,
            onFlipDone: (isFront) {},
            front: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildCreditCard(
                color: kDarkBlue,
                cardExpiration: cardExpiryDateController.text.isEmpty
                    ? "08/2022"
                    : cardExpiryDateController.text,
                cardHolder: cardHolderNameController.text.isEmpty
                    ? "Card Holder"
                    : cardHolderNameController.text.toUpperCase(),
                cardNumber: cardNumberController.text.isEmpty
                    ? "XXXX XXXX XXXX XXXX"
                    : cardNumberController.text,
              ),
            ),
            back: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 4.0,
                color: kDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  height: 230,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 0),
                      const Text(
                        'https://www.paypal.com',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      CustomPaint(
                        painter: CardPainter(),
                        child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cardCvvController.text.isEmpty
                                    ? "322"
                                    : cardCvvController.text,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Wrap the input fields in a FormBuilder to use the new validators.
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              // Card Number Field
              FormBuilderTextField(
                name: 'cardNumber',
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: onboardingFormStyle(context: context),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardInputFormatter(),
                ],
                onChanged: (value) {
                  var text =
                      value?.replaceAll(RegExp(r'\s+\b|\b\s'), ' ') ?? '';
                  setState(() {
                    cardNumberController.value =
                        cardNumberController.value.copyWith(
                      text: text,
                      selection: TextSelection.collapsed(offset: text.length),
                      composing: TextRange.empty,
                    );
                  });
                },
                onTap: () {
                  setState(() {
                    if (frontIsFlipped == false) {
                      flipCardController.toggleCard();
                      frontIsFlipped = true;
                    }
                  });
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Card number is required'),
                  // Additional validators (like length check) can be added here.
                ]),
              ),
              const SizedBox(height: 12),
              // Card Holder Name Field
              FormBuilderTextField(
                name: 'cardHolderName',
                controller: cardHolderNameController,
                keyboardType: TextInputType.name,
                decoration: onboardingFormStyle(context: context),
                onTap: () {
                  setState(() {
                    if (frontIsFlipped == false) {
                      flipCardController.toggleCard();
                      frontIsFlipped = true;
                    }
                  });
                },
                onChanged: (value) {
                  setState(() {
                    cardHolderNameController.value =
                        cardHolderNameController.value.copyWith(
                      text: value ?? '',
                      selection:
                          TextSelection.collapsed(offset: (value ?? '').length),
                      composing: TextRange.empty,
                    );
                  });
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Full name is required'),
                ]),
              ),
              const SizedBox(height: 12),
              // Expiry Date and CVV Fields in a Row
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'cardExpiryDate',
                      controller: cardExpiryDateController,
                      keyboardType: TextInputType.number,
                      decoration: onboardingFormStyle(context: context),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardDateInputFormatter(),
                      ],
                      onChanged: (value) {
                        var text =
                            value?.replaceAll(RegExp(r'\s+\b|\b\s'), ' ') ?? '';
                        setState(() {
                          cardExpiryDateController.value =
                              cardExpiryDateController.value.copyWith(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: text.length),
                            composing: TextRange.empty,
                          );
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (frontIsFlipped == false) {
                            flipCardController.toggleCard();
                            frontIsFlipped = true;
                          }
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Expiry date is required'),
                        // You could add a regex validator for MM/YY format here.
                      ]),
                    ),
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      onTapAlwaysCalled: true,
                      name: 'cardCvv',
                      controller: cardCvvController,
                      keyboardType: TextInputType.number,
                      decoration: onboardingFormStyle(context: context),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onTap: () {
                        setState(() {
                          if (frontIsFlipped == true) {
                            flipCardController.toggleCard();
                            frontIsFlipped = false;
                          }
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          int length = value?.length ?? 0;
                          if (length == 4 || length == 9 || length == 14) {
                            cardNumberController.text = '$value ';
                            cardNumberController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: (value?.length ?? 0) + 1));
                          }
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'CVV is required'),
                        // Optionally enforce a length validator here.
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // The Submit Button – here we validate the form before proceeding.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubmitButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          // Clear controllers and toggle the flip card as before.
                          cardCvvController.clear();
                          cardExpiryDateController.clear();
                          cardHolderNameController.clear();
                          cardNumberController.clear();
                          if (frontIsFlipped == false) {
                            flipCardController.toggleCard();
                            frontIsFlipped = true;
                          }
                        });
                        context.read<OnboardingCubit>().skipBillingForm();
                      }
                    },
                    buttonText: 'Add Card',
                  ),
                  SubmitButton(
                    onPressed: () {
                      context.read<OnboardingCubit>().skipBillingForm();
                    },
                    buttonText: 'Skip',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
