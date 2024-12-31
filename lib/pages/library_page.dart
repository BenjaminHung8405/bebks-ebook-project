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

class LibraryPage extends StatefulWidget {
  final token;
  const LibraryPage({required this.token, Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<AppBanner> banners = [];
  List<BookModel> books = [];
  bool isLoading = true;
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
            toolbarHeight: 70,
            backgroundColor: ColorModel.primaryColor,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: titleWidget(title: 'BEBKs', size: 25, padding: 0,),
          )],
          body: ListView(
            padding: EdgeInsets.only(left: 20,right: 20),
            children: [
                const SizedBox(height: 5,),
                isLoading ? Center(child: CircularProgressIndicator()) : 
                _bannerSlider(),
                const SizedBox(height: 20,),

                
              ],
            ),
          )
      );
  }

  Padding _bannerSlider() {
    return Padding(
                padding: const EdgeInsets.all(5),
                child: isLoading ? Center(child: CircularProgressIndicator()): 
                AppSizes.isLoading ? Center(child: CircularProgressIndicator()): 
                Column(
                  children: [
                    CarouselSlider.builder(
                    itemCount: banners.length, 
                    itemBuilder: (context, index, realIndex) {
                      final banner = banners[index];
                      return RoundedImage(
                        imageUrl: banner.bannerUrl,
                      );
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
                        dotWidth: 8,
                        spacing: 12,
                        dotColor: ColorModel.secondaryColor,
                        activeDotColor: ColorModel.secondaryColor,
                        paintStyle: PaintingStyle.stroke,
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
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
      print('Failed to fetch banners: $e');
    }
    
  }

  Future<void> fetchBooks() async {
    try {
      final response = await BookApi.fetchBooks();
      setState(() {
        books = response;
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
      print('Failed to fetch book: $e');
    }
  }
}

