import 'package:flutter/material.dart';

void main() {
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchComparison(),
    );
  }
}

// -------------------- TRIE IMPLEMENTATION --------------------
class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class Trie {
  final TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode node = root;
    for (var char in word.split('')) {
      node.children.putIfAbsent(char, () => TrieNode());
      node = node.children[char]!;
    }
    node.isEndOfWord = true;
  }

  bool search(String word) {
    TrieNode node = root;
    for (var char in word.split('')) {
      if (!node.children.containsKey(char)) {
        return false;
      }
      node = node.children[char]!;
    }
    return node.isEndOfWord;
  }
}

// -------------------- UI & SEARCH TEST --------------------
class SearchComparison extends StatefulWidget {
  @override
  State<SearchComparison> createState() => _SearchComparisonState();
}

class _SearchComparisonState extends State<SearchComparison> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> wordList = [];
  final Trie trie = Trie();

  String listSearchTime = "";
  String trieSearchTime = "";
  bool listResult = false;
  bool trieResult = false;

  void addWord() {
    String word = _inputController.text.trim();
    if (word.isEmpty) return;

    wordList.add(word);
    trie.insert(word);

    _inputController.clear();
    setState(() {});
  }

  void searchWord() {
    String word = _searchController.text.trim();
    if (word.isEmpty) return;

    // List search timing
    final listStart = DateTime.now().microsecondsSinceEpoch;
    listResult = wordList.contains(word);
    final listEnd = DateTime.now().microsecondsSinceEpoch;
    listSearchTime = "${listEnd - listStart} μs";

    // Trie search timing
    final trieStart = DateTime.now().microsecondsSinceEpoch;
    trieResult = trie.search(word);
    final trieEnd = DateTime.now().microsecondsSinceEpoch;
    trieSearchTime = "${trieEnd - trieStart} μs";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:   Text("List vs Trie Search")),
      body: Padding(
        padding:   EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: "Add word",
                suffixIcon: IconButton(
                  icon:   Icon(Icons.add),
                  onPressed: addWord,
                ),
              ),
            ),
              SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search word",
                suffixIcon: IconButton(
                  icon:   Icon(Icons.search),
                  onPressed: searchWord,
                ),
              ),
            ),
              SizedBox(height: 20),
            Text("List Search → Found: $listResult, Time: $listSearchTime"),
            Text("Trie Search → Found: $trieResult, Time: $trieSearchTime"),
              SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: wordList.length,
                itemBuilder: (context, index) =>
                    ListTile(title: Text(wordList[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
