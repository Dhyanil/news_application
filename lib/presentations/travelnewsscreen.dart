import 'package:flutter/material.dart';
import 'package:newsapp/models/post.dart';
import 'package:newsapp/services/api_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:newsapp/presentations/NewsDetailScreen.dart';
import 'package:newsapp/presentations/searchscreen.dart';
import 'package:newsapp/presentations/profile.dart';
import 'package:newsapp/presentations/sportscreen.dart';
import 'package:newsapp/presentations/automationnewsscreen.dart';
import 'package:newsapp/presentations/crimescreen..dart';
import 'package:newsapp/presentations/home_screen.dart';
import 'package:newsapp/presentations/shorts_screen.dart';

class TravelNewsScreen extends StatefulWidget {
  const TravelNewsScreen({super.key});

  @override
  State<TravelNewsScreen> createState() => _TravelNewsScreenState();
}

class _TravelNewsScreenState extends State<TravelNewsScreen> {
  Future<List<Post>>? travelPosts;
  final HtmlUnescape unescape = HtmlUnescape();
  String selectedCategory = "Travel"; // ✅ Default selected
  final List<Map<String, dynamic>> categories = [
    {"title": "Sports", "icon": Icons.sports_soccer, "color": Colors.green, "screen": SportsNewsScreen()},
    {"title": "Crime", "icon": Icons.gavel, "color": Colors.red, "screen": CrimeNewsScreen()},
    {"title": "Tech", "icon": Icons.memory, "color": Colors.blue, "screen": AutomationNewsScreen()},
    {"title": "Travel", "icon": Icons.flight, "color": Colors.orange, "screen": TravelNewsScreen()},
  ];
  @override
  void initState() {
    super.initState();
    travelPosts = ApiService().fetchTravelNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildCategoriesList(), // ✅ Icons under AppBar
            _buildSectionTitle("Latest Travel News"),
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
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()), // ✅ Navigates to Home Screen
              );
            },
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
          const SizedBox(width: 12), // Spacing between back icon and title
          Text(
            "Travel News",
            style: GoogleFonts.hindVadodara(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(), // Pushes everything else to the right
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
            },
            child: const Icon(Icons.search, size: 24, color: Colors.black),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfile()));
            },
            child: const CircleAvatar(radius: 15, backgroundColor: Colors.grey),
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

  
 Widget _buildCategoryItem(String title, IconData icon) {
  bool isSelected = selectedCategory == title;
  return GestureDetector(
    onTap: () {
      if (title == "Sports") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SportsNewsScreen()));
      } else if (title == "Crime") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CrimeNewsScreen()));
      } else if (title == "Tech & Auto") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AutomationNewsScreen()));
      } else if (title == "Travel") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelNewsScreen()));
      } else if (title == "Shorts") {
        ApiService apiService = ApiService();
        apiService.fetchYouTubeShorts().then((videos) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoFeedScreen(videoPosts: videos),
            ),
          );
        }).catchError((error) {
          print("❌ Error fetching videos: $error");
        });
      } else {
        setState(() {
          selectedCategory = isSelected ? '' : title;
          travelPosts = ApiService().fetchPosts(category: title); // ✅ Fixed Error
        });
      }
    },
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.blue : Colors.grey),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.hindVadodara(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue : Colors.black,
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
        style: GoogleFonts.hindVadodara(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
      ),
    );
  }

  Widget _buildVerticalNewsList() {
    return FutureBuilder<List<Post>>(
      future: travelPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('⚠️ No travel news available!'));
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
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: post.featuredImageUrl,
                          width: 120,
                          height: 100,
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
                            Text(
                              post.date,
                              style: GoogleFonts.hindVadodara(fontSize: 12, color: Colors.grey),
                            ),
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
      width: 120,
      height: 100,
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
