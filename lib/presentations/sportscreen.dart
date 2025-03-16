import 'package:flutter/material.dart';
import 'package:newsapp/models/post.dart';
import 'package:newsapp/services/api_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:newsapp/presentations/NewsDetailScreen.dart';
import 'package:newsapp/presentations/searchscreen.dart';
import 'package:newsapp/presentations/profile.dart';
import 'package:newsapp/presentations/automationnewsscreen.dart';
import 'package:newsapp/presentations/travelnewsscreen.dart';
import 'package:newsapp/presentations/home_screen.dart';
import 'package:newsapp/presentations/shorts_screen.dart';

import 'crimescreen..dart';

class SportsNewsScreen extends StatefulWidget {
  const SportsNewsScreen({super.key});

  @override
  State<SportsNewsScreen> createState() => _SportsNewsScreenState();
}

class _SportsNewsScreenState extends State<SportsNewsScreen> {
  Future<List<Post>>? sportsPosts;
  final HtmlUnescape unescape = HtmlUnescape();
  String selectedCategory = "Sports"; // Default category

  final List<Map<String, dynamic>> categories = [
    {"title": "Sports", "icon": Icons.sports_soccer, "color": Colors.green, "screen": SportsNewsScreen()},
    {"title": "Crime", "icon": Icons.gavel, "color": Colors.red, "screen": CrimeNewsScreen()},
    {"title": "Tech", "icon": Icons.memory, "color": Colors.blue, "screen": AutomationNewsScreen()},
    {"title": "Travel", "icon": Icons.flight, "color": Colors.orange, "screen": TravelNewsScreen()},
  ];

  @override
  void initState() {
    super.initState();
    sportsPosts = ApiService().fetchSportsNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildCategoriesList(), // Enhanced UI
            _buildSectionTitle("Latest Sports News"),
            Expanded(child: _buildVerticalNewsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen())),
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
          const SizedBox(width: 12), // Space between the back button and the title
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft, // Aligns text to the left
              child: Text(
                'Sports News',
                style: GoogleFonts.hindVadodara(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                child: const Icon(Icons.search, size: 24, color: Colors.black),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfile())),
                child: const CircleAvatar(radius: 15, backgroundColor: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // Adding 1 for Shorts
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          if (index == categories.length) {
            // Handle Shorts separately
            return GestureDetector(
              onTap: () async {
                final shortsVideos = await ApiService().fetchYouTubeShorts(); // Fetch Shorts videos
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoFeedScreen(videoPosts: shortsVideos),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple),
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_fill, size: 18, color: Colors.purple),
                    const SizedBox(width: 6),
                    Text(
                      "Shorts",
                      style: GoogleFonts.hindVadodara(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => category["screen"]),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: category["color"].withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: category["color"]),
              ),
              child: Row(
                children: [
                  Icon(category["icon"], size: 18, color: category["color"]),
                  const SizedBox(width: 6),
                  Text(
                    category["title"],
                    style: GoogleFonts.hindVadodara(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: category["color"],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color, Widget screen) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        if (title == selectedCategory) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.hindVadodara(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.hindVadodara(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVerticalNewsList() {
    return FutureBuilder<List<Post>>(
      future: sportsPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('⚠️ No sports news available!'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetailScreen(post: post)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 2),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: post.featuredImageUrl,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _imagePlaceholder(),
                          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              unescape.convert(post.title),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.hindVadodara(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(post.date, style: GoogleFonts.hindVadodara(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 100,
      height: 80,
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
