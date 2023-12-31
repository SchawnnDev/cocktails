import 'package:cocktails/models/drink.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeMoreModal extends StatelessWidget {
  final String title;
  final List<Drink> drinks;

  const SeeMoreModal({super.key, required this.title, required this.drinks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFBAA9DB),
        centerTitle: true,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.spaceEvenly,
              children: List.generate(
                drinks.length,
                (index) {
                  final drink = drinks[index];

                  return DrinkCard(
                    drink,
                    index,
                    singleColor: Color(0xFFBAA9DB).withOpacity(0.6),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
