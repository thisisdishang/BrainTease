import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final bool showBackButton;

  HomeScreen({super.key, this.showBackButton = true});

  final List<Map<String, dynamic>> categories = [
    {
      "id": 9,
      "name": "General Knowledge",
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/011/470/395/small_2x/brain-technology-logo-design-template-circuit-brain-logo-concept-free-vector.jpg"
    },
    {
      "id": 10,
      "name": "Books",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsv5glwonyKZoix13xkW7_6y8PuivjcFUjRA&s"
    },
    {
      "id": 11,
      "name": "Film",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST1enE6GI9_tG3I_aNUTXs11VLEs8Y4v9gkw&s"
    },
    {
      "id": 12,
      "name": "Music",
      "image":
          "https://media.istockphoto.com/id/1385087437/vector/musical-wave.jpg?s=612x612&w=0&k=20&c=54tmVrmcCY-VwlfkGoz75zsckyl-EuBs0tkVuo8nR4E="
    },
    {
      "id": 15,
      "name": "Video Games",
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/003/759/813/small_2x/pink-video-game-control-free-vector.jpg"
    },
    {
      "id": 18,
      "name": "Computers",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSc097e-z96Y4GrnNhrTF8cyIH6QlzE35LFJg&s"
    },
    {
      "id": 19,
      "name": "Mathematics",
      "image":
          "https://miro.medium.com/v2/resize:fit:1400/1*L76A5gL6176UbMgn7q4Ybg.jpeg"
    },
    {
      "id": 21,
      "name": "Sports",
      "image":
          "https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg"
    },
    {
      "id": 23,
      "name": "History",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUfVuI-52gMsBUjICo8U71bZzPh_Sl60a0rw&s"
    },
    {
      "id": 26,
      "name": "Celebrity",
      "image":
          "https://thumbs.dreamstime.com/b/elegant-young-beautiful-woman-female-celebrity-movie-star-superstar-posing-front-photographers-red-carpet-ceremony-143610506.jpg"
    },
    {
      "id": 27,
      "name": "Animals",
      "image":
          "https://t4.ftcdn.net/jpg/04/15/79/09/360_F_415790935_7va5lMHOmyhvAcdskXbSx7lDJUp0cfja.jpg"
    },
    {
      "id": 28,
      "name": "Vehicles",
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/000/594/460/small_2x/ziky_4ltw_190312.jpg"
    },
    {
      "id": 30,
      "name": "Gadgets",
      "image":
          "https://static.vecteezy.com/system/resources/previews/002/216/690/non_2x/gadget-minimal-thin-line-icons-set-vector.jpg"
    },
  ];

  void _showDifficultyDialog(
      BuildContext context, String categoryName, int categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Difficulty"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['easy', 'medium', 'hard'].map((difficulty) {
              return ListTile(
                title:
                    Text(difficulty[0].toUpperCase() + difficulty.substring(1)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/quiz',
                    arguments: {
                      'categoryId': categoryId,
                      'difficulty': difficulty
                    },
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        backgroundColor: Colors.blue.shade900,
        title: Center(
          child: const Text(
            'Quiz Categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10).copyWith(bottom: 80),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showDifficultyDialog(
                context, categories[index]["name"], categories[index]["id"]),
            child: Container(
              height: 180,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(categories[index]["image"]!),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      categories[index]["name"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
