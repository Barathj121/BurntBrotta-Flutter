import 'dart:convert';
import 'package:burntbrotta/models/food.dart';
import 'package:burntbrotta/pages/foodDetails.dart';
import 'package:burntbrotta/pages/foodTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipiesPage extends StatelessWidget {
  const RecipiesPage({super.key});

  Future<List<Food>> loadRecipies() async {
    try {
      final String response = await rootBundle.loadString('lib/pages/recipes.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) {
        return Food(
          name: json['name'] ?? 'Unknown Recipe',
          duration: json['time'] ?? 'Unknown Time',
          serving: int.tryParse((json['servings'] ?? '0 servings').split(' ')[0]) ?? 0,
          level: json['difficulty'] ?? 'Unknown',
          imgpath: json['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void getRecipeDetails(BuildContext context, List<Food> recipies, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodDetails(food: recipies[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BURNT BROTTA",
          style: GoogleFonts.climateCrisis(fontSize: 20, height: 0.9),
        ),
        leading: const Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/favourites");
              },
              icon: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Food>>(
        future: loadRecipies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No recipes found"));
          }

          final recipies = snapshot.data!;

          return Column(
            children: [
              // Title promo section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 243, 239, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                          child: Image.asset("lib/images/pan.png"),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "We put recipes to the test, so you can savor the success!",
                          style: GoogleFonts.poppins(fontSize: 18, height: 0.9, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // All Recipes section
              Text(
                "All Recipes",
                style: GoogleFonts.poppins(fontSize: 22, height: 0.9, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Search here!",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recipies.length,
                  itemBuilder: (context, index) {
                    return FoodTile(
                      food: recipies[index],
                      ontap: () => getRecipeDetails(context, recipies, index),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

