import 'package:bebks_ebooks/config/app_size.dart';
import 'package:bebks_ebooks/models/bannerModel.dart';
import 'package:bebks_ebooks/models/bookModel.dart';
import 'package:bebks_ebooks/models/userModel.dart';
import 'package:bebks_ebooks/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bebks_ebooks/widgets/RoundedImage.dart';
import 'package:bebks_ebooks/widgets/title.dart';
import 'package:bebks_ebooks/utils/colorModel.dart';

class HomePage extends StatefulWidget {
 const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppBanner> banners = [];
  List<BookModel> books = [];
  List<BookModel> popularBooks = [];
  BookModel book = BookModel(id: '', title: '', coverImage: '', author: '', rate: 0);
  BookModel popularBook = BookModel(id: '', title: '', coverImage: '', author: '', rate: 0);
  UserModel user = UserModel(id: '', name: '', email: '', password: '',pictures: PictureModel(large: '', medium: '', thumbnail: ''));
  bool _isLoading = true;
  int myCurrentIndex = 0;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBanners();
    fetchBooks();
    fetchUserById();
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
        popularBooks = response;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = true;
      print('Failed to fetch book: $e');
    }
  }

  Future<void> fetchUserById() async {
    final id = await storage.read(key: 'userId');
    try {
      if(id != null){
        final response = await UserApi.fetchUserByEmail(id);
        setState(() {
          user = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      _isLoading = true;
      print('Failed to fetch user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorModel.backgroundColor,
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled)
          => [SliverAppBar(
            toolbarHeight: AppSizes.blockSizeHorizontal * 14,
            backgroundColor: ColorModel.primaryColor,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            title: titleWidget(title: 'BEBKs', size: AppSizes.blockSizeHorizontal * 5, padding: AppSizes.blockSizeHorizontal * 2,),
          )],
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
            child: Column(
              children: [
                  SizedBox(height: AppSizes.blockSizeHorizontal * 4,),
                  _isLoading ? Center(child: CircularProgressIndicator()) : 
                  _trendingBox(),
                  SizedBox(height: AppSizes.blockSizeHorizontal * 1,),
                  _recentRead(),
                  SizedBox(height: AppSizes.blockSizeHorizontal * 4,),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleWidget(
                              title: 'Phổ biến',
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
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: popularBooks.length,
                        itemBuilder: (context, index) {
                          popularBook = popularBooks[index];
                          return Container(
                            width: AppSizes.screenWidth,
                            height: AppSizes.blockSizeHorizontal * 50,
                            margin: EdgeInsets.symmetric(vertical: AppSizes.blockSizeHorizontal * 2),
                            padding: EdgeInsets.all(AppSizes.blockSizeHorizontal * 2),
                            decoration: BoxDecoration(
                              color: ColorModel.primaryColor,
                              borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 3),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 3),
                                  color: ColorModel.lightTextColor.withOpacity(0.3),
                                  blurRadius: 7,
                                  spreadRadius: 0.5
                                )
                              ]
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: AppSizes.blockSizeHorizontal * 45,
                                  child: RoundedImage(
                                    imageUrl: popularBook.coverImage,
                                    borderRadius: AppSizes.blockSizeHorizontal * 1,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(width: AppSizes.blockSizeHorizontal * 3,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: AppSizes.blockSizeHorizontal * 2,),
                                    Text(
                                      popularBook.title,
                                      style: TextStyle(
                                        color: ColorModel.textColor,
                                        fontSize: AppSizes.blockSizeHorizontal * 3.5,
                                        fontWeight: FontWeight.w600
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      popularBook.author,
                                      style: TextStyle(
                                        color: ColorModel.lightTextColor,
                                        fontSize: AppSizes.blockSizeHorizontal * 3,
                                        fontWeight: FontWeight.w500
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AppSizes.blockSizeHorizontal * 2,),
                                    Row(
                                      children: [
                                        StarRating(
                                          rating: popularBook.rate,
                                          starCount: 5,
                                          allowHalfRating: true,
                                          color: Colors.yellow.shade700,
                                          borderColor: Colors.yellow.shade700,
                                        ),
                                        SizedBox(width: AppSizes.blockSizeHorizontal * 1,),
                                        Text(
                                          '${popularBook.rate}',
                                          style: TextStyle(
                                            color: ColorModel.lightTextColor,
                                            fontSize: AppSizes.blockSizeHorizontal * 3,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSizes.blockSizeHorizontal * 1,),
                                    Wrap(
                                      spacing: AppSizes.blockSizeHorizontal * 1,
                                      children: List.generate(
                                        3, 
                                        (int index) {
                                          return Chip(
                                            label: Text('data'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 4)
                                            ),
                                          );
                                        }
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.blockSizeHorizontal * 50,)
                ],
            )
          ),
        )
      );
  }

  Column _recentRead() {
    return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleWidget(
                            title: 'Gần đây',
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
                      height: AppSizes.blockSizeHorizontal * 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          book = books[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 2),
                            child: Container(
                              width: AppSizes.blockSizeHorizontal * 35,
                              margin: EdgeInsets.symmetric(vertical: AppSizes.blockSizeHorizontal * 2),
                              padding: EdgeInsets.all(AppSizes.blockSizeHorizontal * 2),
                              decoration: BoxDecoration(
                                color: ColorModel.primaryColor,
                                borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 3),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 3),
                                    color: ColorModel.lightTextColor.withOpacity(0.3),
                                    blurRadius: 7,
                                    spreadRadius: 0.5
                                  )
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: AppSizes.blockSizeHorizontal * 45,
                                    child: RoundedImage(
                                      imageUrl: book.coverImage,
                                      borderRadius: AppSizes.blockSizeHorizontal * 1,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.blockSizeHorizontal * 2),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      book.title,
                                      style: TextStyle(
                                        color: ColorModel.textColor,
                                        fontSize: AppSizes.blockSizeHorizontal * 3.5,
                                        fontWeight: FontWeight.w600
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.blockSizeHorizontal * 1),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      book.author,
                                      style: TextStyle(
                                        color: ColorModel.lightTextColor,
                                        fontSize: AppSizes.blockSizeHorizontal * 2.5,
                                        fontWeight: FontWeight.w500
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ]
                );
  }

  Container _trendingBox() {
    return Container(
                width: AppSizes.screenWidth,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleWidget(
                          title: 'Nổi bật',
                          padding: AppSizes.blockSizeHorizontal * 4,
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
                    SizedBox(height: AppSizes.blockSizeHorizontal * 2,),
                    _bannerSlider(),                   
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
}

