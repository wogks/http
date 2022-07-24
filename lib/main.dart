import 'dart:convert';
import 'Images.dart';
import 'package:flutter/material.dart';
import 'Picture.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchApp(),
    );
  }
}


class SearchApp extends StatefulWidget {
  SearchApp({Key? key}) : super(key: key);

  @override
  State<SearchApp> createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchApp> {
  final _controller = TextEditingController();//질문:이 뭔지?
  String _query = '';

  @override//질문: 왜 여다 선언을 하는지
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImageSearch'),
      ),
      body: Column(
        children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _query = _controller.text;//질문: 왜이렇게 선언을 하는지?
                    });
                  },
                  child: const Icon(Icons.search),
                ),
                hintText: '검색어를 입력하세요',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Picture>>(//질문 이거 왜 쓰는지?
                future: getImages(_query),//질문:future부분에 뭘 쓰는건지?
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('에러가 발생했습니다'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('데이터가 없습니다'),
                    );
                  }

                  final List<Picture> images = snapshot.data!;

                  if (images.isEmpty) {
                    return const Center(
                      child: Text('데이터가 0개입니다'),
                    );
                  }
                  return GridView(//질문: 함수부분 모름
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: images
                        .where((e) => e.tags.contains(_query))
                        .map((Picture image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          image.previewURL,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  );
                },
                
              ),//질문: 이거 왜 쓰는건지?

            ),
          )
        ],
      )
    );
  }
  Future<List<Picture>> getImages(String query) async{//질문: 다 모르겠음
    Uri url = Uri.parse(
    'https://pixabay.com/api/?key=10711147-dc41758b93b263957026bdadb&q=$query&image_type=photo'
    );
    http.Response response = await http.get(url);
    print('response status: ${response.statusCode}');

    String jsonString = response.body;//질문 왜여기다가 변수선언?

    Map<String,dynamic> json = jsonDecode(jsonString);
    List<dynamic> hits = json['hits'];
    return hits.map((e) => Picture.fromJson(e)).toList();
  }
}
