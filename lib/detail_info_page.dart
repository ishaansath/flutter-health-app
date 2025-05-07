// detail_info_page.dart
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'item_detail_page.dart'; // Assuming you'll use this for all item details

class DetailInfoPage extends StatelessWidget {
  final String title;
  final String mode;
  final String image;
  final MaterialColor color;
  final String organ;
  final String? info; // Make info nullable
  final List<Map<String, dynamic>>? items; // Make items nullable

  const DetailInfoPage({
    super.key,
    this.info,
    required this.mode,
    required this.image,
    required this.color,
    required this.organ,
    required this.title,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey.shade900, centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image.isNotEmpty)
                image.toLowerCase().endsWith('.gif')
                    ? SizedBox(
                  width: 200,
                  height: 200,
                  child: GifView.asset(
                    image,
                    loop: true,
                  ),
                )
                    : Image.asset(image, width: 200, height: 200),
              if (info != null && info!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    info!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              if (items != null && items!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 105),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 500.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayInterval: const Duration(seconds: 10),
                      viewportFraction: 0.75,
                    ),
                    items: items!.map((item) {
                      return Builder(
                        builder: (BuildContext context) { // Correct usage of Builder
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailPage( // Reusing ItemPage for all item details
                                    name: item['name']!,
                                    modelPath: item['modelPath'] ?? 'assets/models/default.glb',
                                    description: mode == 'fun'
                                        ? item['funModeDescription']!
                                        : item['normalModeDescription']!,
                                    additionalInfo: item['additionalInfo']!,
                                    image: item['image']!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade700, width: 3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (item['image'] != null)
                                    Container(
                                      height: 225,
                                      width: 225,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade700,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(item['image']!, fit: BoxFit.contain),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(fontSize: 20, color: Colors.white), // Adjusted font size
                                    textAlign: TextAlign.center,
                                  ),
                                  if (item['shortDescription'] != null) // Display short description
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        item['shortDescription']!,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  // if (item['normalModeDescription'] != null)
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(top: 5),
                                  //     child: Text(
                                  //       mode == 'fun' ? item['funModeDescription']! : item['normalModeDescription']!,
                                  //       style: const TextStyle(color: Colors.white70, fontSize: 15),
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   ),
                                  if (item['additionalInfo'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        item['additionalInfo']!,
                                        style: const TextStyle(color: Colors.white38, fontSize: 9),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(), // Added .toList() here
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}