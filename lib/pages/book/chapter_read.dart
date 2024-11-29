import 'package:bebks_ebooks/models/chapterModel.dart';
import 'package:bebks_ebooks/models/colorModel.dart';
import 'package:bebks_ebooks/services/api.dart';
import 'package:bebks_ebooks/widgets/title.dart';
import 'package:flutter/material.dart';

class ChapterRead extends StatefulWidget {
  final String chapterId;
  const ChapterRead({required this.chapterId, Key? key}) : super(key: key);

  @override
  State<ChapterRead> createState() => _ChapterReadState();
}

class _ChapterReadState extends State<ChapterRead> {
  bool isLoading = false;
  ChapterModel chapter = ChapterModel(id: '', name: '', chapterUrl: []);
  List<String> chapterUrls = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorModel.primaryColor,
      body: isLoading ? Center(child: CircularProgressIndicator()): NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: 70,
            backgroundColor: ColorModel.primaryColor,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: titleWidget(title: chapter.name, size: 25, padding: 0,),
            leading: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 37,
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 30,
                  ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent
                ),
              ),
            )
          )],
          body: (chapter.chapterUrl == null) ?
          Center(
          child: titleWidget(title: 'We are translating this chapter')
          ): 
          ListView.builder(
            itemCount: chapter.chapterUrl?.length,
            itemBuilder: (context, index) {
              final image = chapter.chapterUrl?[index];
              return Image.network(
                image,
              );
            },
            )
          )
    );
  }

  Future<void> fetchChapters() async {
  try {
    final response = await ChapterApi.fetchChapters(widget.chapterId);
    chapterUrls = response.chapterUrl?.map((url) => url.toString()).toList() ?? [];
    setState(() {
      chapter = response;
      chapterUrls = chapterUrls;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = true;
    });
    print('Failed to fetch chapter by id: $e');
  }
}
}