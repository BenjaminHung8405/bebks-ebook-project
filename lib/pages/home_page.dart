import 'package:bebks_ebooks/config/app_size.dart';
import 'package:bebks_ebooks/models/bannerModel.dart';
import 'package:bebks_ebooks/models/bookModel.dart';
import 'package:bebks_ebooks/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bebks_ebooks/widgets/RoundedImage.dart';
import 'package:bebks_ebooks/widgets/title.dart';
import 'package:bebks_ebooks/models/colorModel.dart';

class HomePage extends StatefulWidget {
 const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppBanner> banners = [];
  List<BookModel> books = [];
  var book = null;
  bool _isLoading = true;
  int myCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBanners();
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
            toolbarHeight: AppSizes.blockSizeHorizontal * 14,
            backgroundColor: ColorModel.primaryColor,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: titleWidget(title: 'BEBKs', size: AppSizes.blockSizeHorizontal * 5, padding: 0,),
          )],
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
            child: Column(
              children: [
                  SizedBox(height: AppSizes.blockSizeHorizontal * 1,),
                  _isLoading ? Center(child: CircularProgressIndicator()) : 
                  _trendingBox(),
                  SizedBox(height: AppSizes.blockSizeHorizontal * 4,),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleWidget(
                              title: 'Dành cho bạn',
                              padding: 0,
                            ),
                            TextButton(
                              onPressed: () {
                                
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: ColorModel.buttonColor,
                                  fontSize: AppSizes.blockSizeHorizontal * 3,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.blockSizeHorizontal * 2,),
                      Container(
                        height: AppSizes.blockSizeHorizontal * 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            book = books[index];
                            return Container(
                              width: AppSizes.blockSizeHorizontal * 30,
                              decoration: BoxDecoration(
                                color: ColorModel.backgroundColor,
                                borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 3)
                              ),
                            );
                          },
                        ),
                      )
                    ]
                  )
                  
                ],
            )
          ),
        )
      );
  }

  Container _trendingBox() {
    return Container(
                width: AppSizes.screenWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleWidget(
                            title: 'Nổi bật',
                            padding: 0,
                          ),
                          TextButton(
                            onPressed: () {
                              
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: ColorModel.buttonColor,
                                fontSize: AppSizes.blockSizeHorizontal * 3,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.blockSizeHorizontal * 2,),
                    _bannerSlider(),
                    SizedBox(height: AppSizes.blockSizeHorizontal * 4,),
                    
                  ],
                )
              );
  }

  Padding _bannerSlider() {
    return Padding(
                padding: const EdgeInsets.all(5),
                child: _isLoading ? Center(child: CircularProgressIndicator()): 
                AppSizes.isLoading ? Center(child: CircularProgressIndicator()): 
                Column(
                  children: [
                    CarouselSlider.builder(
                    itemCount: banners.length, 
                    itemBuilder: (context, index, realIndex) {
                      final banner = banners[index];
                      return RoundedImage(
                        imageUrl: banner.bannerUrl,
                        height: AppSizes.blockSizeHorizontal * 5,
                        fit: BoxFit.contain,
                      );
                    }, 
                    options: CarouselOptions(
                      autoPlay: true,
                      height: AppSizes.blockSizeHorizontal * 50,
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
                    SizedBox(height: AppSizes.blockSizeHorizontal * 4,),
                    AnimatedSmoothIndicator(
                      activeIndex: myCurrentIndex, 
                      count: banners.length,
                      effect: WormEffect(
                        dotHeight: AppSizes.blockSizeHorizontal * 2,
                        dotWidth: AppSizes.blockSizeHorizontal * 2,
                        spacing: AppSizes.blockSizeHorizontal * 2,
                        dotColor: ColorModel.lightTextColor,
                        activeDotColor: ColorModel.buttonColor,
                        paintStyle: PaintingStyle.fill,
                      ),
                      )
                  ]
                )
              );
  }

  Future<void> fetchBanners() async {
    try {
      final response = await BannerApi.fetchBanners();
      setState(() {
        banners = response;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = true;
      print('Failed to fetch banners: $e');
    }
    
  }

  Future<void> fetchBooks() async {
    try {
      final response = await BookApi.fetchBooks();
      setState(() {
        books = response;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = true;
      print('Failed to fetch book: $e');
    }
  }
}

