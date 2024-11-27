import 'package:bebks_ebooks/models/bannerModel.dart';
import 'package:bebks_ebooks/models/bookModel.dart';
import 'package:bebks_ebooks/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bebks_ebooks/widgets/searchBar.dart';
import 'package:bebks_ebooks/widgets/RoundedImage.dart';
import 'package:bebks_ebooks/widgets/title.dart';
import 'package:bebks_ebooks/models/colorModel.dart';
import 'package:bebks_ebooks/models/chapterModel.dart';

class LibraryPage extends StatefulWidget {
  final token;
  const LibraryPage({@required this.token, Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  List<AppBanner> banners = [];
  List<ChapterModel> chapters = [];
  List<BookModel> books = [];
  bool isLoading = true;
  int myCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBanners();
    fetchChapters();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorModel.primaryColor,
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled)
          => [SliverAppBar(
            toolbarHeight: 70,
            backgroundColor: ColorModel.primaryColor,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: titleWidget(title: 'BEBKs', size: 25, padding: 0,),
            leading: GestureDetector(
              onTap: () {
                
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
          body: ListView(
            padding: EdgeInsets.only(left: 20,right: 20),
            children: [
                SearchBarWidget(),

                const SizedBox(height: 30,),
                titleWidget(title: 'Nổi bật',),
                const SizedBox(height: 5,),
                _bannerSlider(),
                const SizedBox(height: 20,),
                isLoading ? Center(child: CircularProgressIndicator()): 
                _bookList()
              ],
            ),
          )
      );
  }

  Column _bookList() {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget(title: 'Dành cho bạn'),
                  const SizedBox(height: 5,),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: books.length, 
                    separatorBuilder: (context, index) => const SizedBox(height: 25,), 
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  book.coverImage,
                                  scale: 1,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) { 
                                    return Text('Image not found. Please try a different URL.');
                                  },
                                  ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  titleWidget(
                                    title: book.title,
                                    padding: 20,
                                    size: 18,
                                    )
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ColorModel.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff1D1617).withOpacity(0.1),
                              offset: const Offset(0, 3),
                              blurRadius: 7,
                              spreadRadius: 5
                            )
                          ]
                          )
                          ),
                      );
                    },
                    )
                ],
              );
  }

  Padding _bannerSlider() {
    return Padding(
                padding: const EdgeInsets.all(5),
                child: isLoading ? Center(child: CircularProgressIndicator()): Column(
                  children: [
                    CarouselSlider.builder(
                    itemCount: banners.length, 
                    itemBuilder: (context, index, realIndex) {
                      final banner = banners[index];
                      return RoundedImage(imageUrl: banner.bannerUrl);
                    }, 
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 250,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(milliseconds: 1600),
                      autoPlayInterval: const Duration(seconds: 4),
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          myCurrentIndex = index;
                        });
                      },
                      viewportFraction: 1
                    )),
                    const SizedBox(height: 20,),
                    AnimatedSmoothIndicator(
                      activeIndex: myCurrentIndex, 
                      count: banners.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 25,
                        spacing: 12,
                        dotColor: ColorModel.lightTextColor,
                        activeDotColor: ColorModel.secondaryColor,
                        paintStyle: PaintingStyle.fill,
                      ),
                      )
                  ]
                )
              );
  }

  Future<void> fetchBanners() async {
    final response = await BannerApi.fetchBanners();
    setState(() {
      banners = response;
      isLoading = false;
    });
  }

  Future<void> fetchChapters() async {
    final response = await ChapterApi.fetchChapters();
    setState(() {
      chapters = response;
      isLoading = false;
    });
  }

  Future<void> fetchBooks() async {
    final response = await BookApi.fetchBooks();
    setState(() {
      books = response;
      isLoading = false;
    });
  }
}


