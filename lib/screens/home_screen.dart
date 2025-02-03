import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> categories = [
    {
      "name": "General Knowledge",
      "image":
          "https://play-lh.googleusercontent.com/7nZqAPEuWxAeckXC-lm1fWEk6pDK3mRlUCxPuLIctJ1MD9RM0HPgOdrhOwr39deWSjtn"
    },
    {
      "name": "Books",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsv5glwonyKZoix13xkW7_6y8PuivjcFUjRA&s"
    },
    {
      "name": "Film",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST1enE6GI9_tG3I_aNUTXs11VLEs8Y4v9gkw&s"
    },
    {
      "name": "Music",
      "image":
          "https://media.istockphoto.com/id/1385087437/vector/musical-wave.jpg?s=612x612&w=0&k=20&c=54tmVrmcCY-VwlfkGoz75zsckyl-EuBs0tkVuo8nR4E="
    },
    {
      "name": "Video Games",
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/003/759/813/small_2x/pink-video-game-control-free-vector.jpg"
    },
    {
      "name": "Computers",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSc097e-z96Y4GrnNhrTF8cyIH6QlzE35LFJg&s"
    },
    {
      "name": "Mathematics",
      "image":
          "https://miro.medium.com/v2/resize:fit:1400/1*L76A5gL6176UbMgn7q4Ybg.jpeg"
    },
    {
      "name": "Sports",
      "image":
          "https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg"
    },
    {
      "name": "History",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUfVuI-52gMsBUjICo8U71bZzPh_Sl60a0rw&s"
    },
    {
      "name": "Celebrity",
      "image":
          "https://png.pngtree.com/png-vector/20230728/ourlarge/pngtree-fame-clipart-celebrity-cartoon-characters-with-camera-and-microphone-vector-png-image_6807211.png"
    },
    {
      "name": "Animals",
      "image":
          "https://t4.ftcdn.net/jpg/04/15/79/09/360_F_415790935_7va5lMHOmyhvAcdskXbSx7lDJUp0cfja.jpg"
    },
    {
      "name": "Vehicles",
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/000/594/460/small_2x/ziky_4ltw_190312.jpg"
    },
    {
      "name": "Gadgets",
      "image":
          "https://static.vecteezy.com/system/resources/previews/002/216/690/non_2x/gadget-minimal-thin-line-icons-set-vector.jpg"
    },
  ];

  void _showDifficultyDialog(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Difficulty"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
              return ListTile(
                title: Text(difficulty),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                          category: category, difficulty: difficulty),
                    ),
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
        backgroundColor: Colors.deepPurpleAccent.shade400,
        title: Center(
          child: const Text(
            'Quiz Categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns in the grid
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2, // Adjust the size of grid items
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                _showDifficultyDialog(context, categories[index]["name"]!),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(categories[index]["image"]!),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    categories[index]["name"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
