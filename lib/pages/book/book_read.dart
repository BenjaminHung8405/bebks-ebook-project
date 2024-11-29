import 'package:bebks_ebooks/models/bookModel.dart';
import 'package:bebks_ebooks/models/chapterModel.dart';
import 'package:flutter/material.dart';
import 'package:bebks_ebooks/models/colorModel.dart';
import 'package:bebks_ebooks/services/api.dart';
import 'package:bebks_ebooks/widgets/title.dart';

class BookRead extends StatefulWidget {
  final String bookId;
  const BookRead({required this.bookId, Key? key}) : super(key: key);

  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  late BookModel book;
  List<ChapterModel> chapters = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookById();
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
            title: titleWidget(title: book.title, size: 25, padding: 0,),
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
        body: chapters.isNotEmpty ? 
        ListView.separated(
          itemCount: chapters.length,
          separatorBuilder: (context, index) => SizedBox(height: 10,),
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/chapter/${chapter.id}');
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorModel.borderColor,width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: ColorModel.primaryColor,
                ),
                child: titleWidget(title: chapter.name),
              ),
            );
          },
          )
        : Center(
          child: titleWidget(title: 'We are translating this book'),
        )
        )
    );
  }

  Future<void> fetchBookById() async {
  try {
    final response = await BookApi.fetchBookById(widget.bookId);
    setState(() {
      book = response;
      chapters = (response.chapters as List?)
          ?.map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
          .toList() ?? [];
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = true;
    });
    print('Failed to fetch book by id: $e');
  }
}
}
