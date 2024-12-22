import 'package:burntbrotta/models/favourites.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Future<void> refreshFavourites() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void removeFromFavs(Food food, BuildContext context) {
    setState(() {
      var favs = context.read<Favourites>();
      favs.removefromfavs(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourites",
          style: GoogleFonts.climateCrisis(
            fontSize: 25,
            height: 0.9,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: Consumer<Favourites>(
        builder: (context, favs, child) {
          final favouriteFoods = favs.favs;

          return RefreshIndicator(
            onRefresh: refreshFavourites, // Refresh logic
            child: favouriteFoods.isEmpty
                ? ListView( // Empty ListView to enable pull-to-refresh
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No Favourites Added Yet!",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: favouriteFoods.length,
              itemBuilder: (context, index) {
                final food = favouriteFoods[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 120,
                    child: Row(
                      children: [
                        // Food Image
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(food.imgpath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Food Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  food.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  food.level,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Delete Button
                        IconButton(
                          onPressed: () => removeFromFavs(food, context),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}