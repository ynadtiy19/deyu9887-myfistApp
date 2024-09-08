import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hung/ui/animationartical/models/models.dart';
import 'package:hung/ui/animationartical/passport.dart';
import 'package:hung/ui/animationartical/passport_dialog.dart';
import 'package:hung/ui/animationartical/passport_dialog_route.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';

import '../../animationartical/focus_detector.dart';
import '../../utils/hero-icons-outline_icons.dart';
import '../../utils/travel_cards.dart';
import '../../webviewsite/musicsite.dart';
import '../../widgets/common/popmenu/popmenu.dart';
import 'article_viewmodel.dart';

class ArticleView extends StackedView<ArticleViewModel> {
  const ArticleView({super.key});

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ArticleViewModel viewModel,
    Widget? child,
  ) {
    return RefreshIndicator(
      color: Colors.black87,
      onRefresh: () async {
        viewModel.changeColor();
        await Future.delayed(const Duration(milliseconds: 1200));
        viewModel.refreshStorylyView();
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 216, 219, 231),
        body: FutureBuilder<Map<String, dynamic>?>(
            future: viewModel.jsonCacheKey.value('fetchedData'), // 获取存储的数据,
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // } else if (snapshot.hasError) {
              //   return Center(child: Text('Error: ${snapshot.error}'));
              // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //   return Center(child: Text('No data available'));
              // }

              var udata = snapshot.data?.isEmpty ?? true
                  ? {
                      "default-article": {
                        "uniqueSlug":
                            "the-resume-that-got-a-software-engineer-a-300-000-job-at-google-8c5a1ecff40f",
                        "title":
                            "The resume that got a software engineer a \$300,000 job at Google.",
                        "subtitle": "1-page. Well-formatted.",
                        "name": "Alexander Nguyen",
                        "avatarUrl":
                            "https://cdn-images-1.readmedium.com/v2/resize:fill:88:88/1*cwYWYCjbeXNc_pAtTeq_Zg.jpeg",
                        "postImg":
                            "https://cdn-images-1.readmedium.com/v2/resize:fit:224/1*-tpw_l_dLxBYJJ0JhHnf8A.png",
                        "readingTime": "4",
                        "createdAt": "2024-07-18T03:56:06.130Z",
                        "isEligibleForRevenue": true
                      },
                      "default-article-2": {
                        "uniqueSlug":
                            "what-happens-when-you-start-reading-every-day-fddfbf936092",
                        "title":
                            "What Happens When You Start Reading Every Day",
                        "subtitle":
                            "Think before you speak. Read before you think. — Fran Lebowitz",
                        "name": "Sufyan Maan, M.Eng",
                        "avatarUrl":
                            "https://cdn-images-1.readmedium.com/v2/resize:fill:88:88/1*YPRwtOeRYuUonnZUjBrEIQ.png",
                        "postImg":
                            "https://cdn-images-1.readmedium.com/v2/resize:fit:224/1*PMf6z2XnV71zWS18_ANIGw.png",
                        "readingTime": "6",
                        "createdAt": "2024-08-05T12:13:36.320Z",
                        "isEligibleForRevenue": true
                      }
                    }
                  : snapshot.data!;

              // print(udata);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 38),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getGreeting()}, Buddy!',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              MyPopupMenu(
                                onPress: (String value) {
                                  // 处理回调逻辑
                                  print('Pressed $value');
                                  viewModel.PushIntoMenu(value);
                                },
                                child: Icon(
                                  LineIcons.infinity,
                                  key: GlobalKey(),
                                  color: Colors.black87,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, MMMM d ').format(DateTime.now()),
                            style: const TextStyle(
                              fontFamily: 'GabrielaStencil',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: viewModel.controller,
                            decoration: InputDecoration(
                              hintText: 'Search for articles',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(LineIcons.search),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    String query = viewModel.controller.text;
                                    if (query.isNotEmpty) {
                                      viewModel
                                          .fetchData(query)
                                          .then((uuudata) {
                                        // 处理搜索结果
                                        viewModel.jsonCacheKey
                                            .refresh('fetchedData', uuudata!);
                                        viewModel.changeColor();
                                        // print('Fetched data: $uuudata');
                                      }).catchError((error) {
                                        print('Error fetching data: $error');
                                      });
                                    }
                                  },
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.deepOrangeAccent, // 聚焦时的粉橙色边框
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          // const Divider(
                          //   color: Colors.black,
                          //   height: 16.5,
                          //   thickness: 1.0,
                          //   indent: 38,
                          //   endIndent: 38,
                          // ),
                          SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CategoryChip(
                                  label: 'All',
                                  isSelected:
                                      viewModel.selectedCategory == 'All',
                                  onSelected: viewModel.onCategorySelected,
                                ),
                                CategoryChip(
                                  label: 'Wellness',
                                  isSelected:
                                      viewModel.selectedCategory == 'Wellness',
                                  onSelected: viewModel.onCategorySelected,
                                ),
                                CategoryChip(
                                  label: 'Mental Health',
                                  isSelected: viewModel.selectedCategory ==
                                      'Mental Health',
                                  onSelected: viewModel.onCategorySelected,
                                ),
                                CategoryChip(
                                  label: 'Productivity',
                                  isSelected: viewModel.selectedCategory ==
                                      'Productivity',
                                  onSelected: viewModel.onCategorySelected,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Container(
                    //     padding: EdgeInsets.all(8),
                    //     child: StorylyView(
                    //       onStorylyViewCreated: viewModel.onStorylyViewCreated,
                    //       androidParam: StorylyParam()
                    //         ..storylyId = viewModel.UstorylyToken
                    //         ..storyGroupSize = "large",
                    //       iosParam: StorylyParam()
                    //         ..storylyId = viewModel.UstorylyToken
                    //         ..storyGroupSize = "large",
                    //       storylyLoaded: (storyGroups, dataSource) {
                    //         debugPrint(
                    //             "storylyLoaded -> storyGroups: ${storyGroups.length}");
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: udata.keys.length, // 定义要渲染的列表项个数
                        (BuildContext context, int index) {
                          String key = udata.keys.elementAt(index);
                          var article = udata[key];
                          return FocusDetector.mobile(
                            key: ValueKey(apartments[index].host.id),
                            builder: (context, isFocused) => ArticleCard(
                              color: index % 2 == 0
                                  ? viewModel.uuucolor0
                                  : viewModel.uuucolor1,
                              isFocused: isFocused,
                              apartment: apartments[index],
                              avatarUrl: article['avatarUrl'],
                              isEligibleForRevenue:
                                  article['isEligibleForRevenue'],
                              name: article['name'],
                              title: utf8.decode(article['title']
                                  .runes
                                  .toList()), // 解码 'title' 字段
                              readingTime: article['readingTime'],
                              postImg: article['postImg'],
                              pushid: article['uniqueSlug'],
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: [8, 3],
                          radius: Radius.circular(10),
                          padding: EdgeInsets.all(8),
                          child: TravelCards(
                            foregroundImages: viewModel.foregroundImages,
                            backgroundImages: viewModel.backgroundImages,
                            texts: viewModel.texts,
                            onPageChangedCallback: (index) =>
                                viewModel.TravelCardsPageChange(index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  ArticleViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ArticleViewModel();
}

class CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  CategoryChip(
      {required this.label,
      required this.isSelected,
      required this.onSelected});

  @override
  _CategoryChipState createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant CategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(widget.label),
        selected: _isSelected,
        onSelected: (selected) {
          setState(() {
            _isSelected = selected;
          });
          widget.onSelected(widget.label);
        },
        selectedColor: Color.fromRGBO(253, 218, 225, 1),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(
          color: _isSelected
              ? const Color.fromRGBO(253, 218, 225, 255)
              : Colors.black,
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class ArticleCard extends StatefulWidget {
  final String name;
  final String readingTime;
  final String title;
  final String avatarUrl;
  final String postImg;
  final bool isEligibleForRevenue;
  final Apartment apartment;
  final bool isFocused;
  final Color color;
  final String pushid;

  ArticleCard({
    required this.name,
    required this.readingTime,
    required this.title,
    required this.avatarUrl,
    required this.apartment,
    required this.isFocused,
    required this.color,
    required this.postImg,
    required this.isEligibleForRevenue,
    required this.pushid,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard>
    with SingleTickerProviderStateMixin {
  late final PassportController _controller = PassportController();

  @override
  void initState() {
    super.initState();

    _animateFocus();
  }

  @override
  void didUpdateWidget(covariant ArticleCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isFocused == widget.isFocused) {
      return;
    }

    _animateFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateFocus() {
    if (widget.isFocused) {
      _controller.open();
    } else {
      _controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(201, 200, 0, 255),
                      offset: Offset(1, 1),
                      spreadRadius: 1,
                      blurRadius: 1),
                  BoxShadow(
                      color: Color.fromARGB(255, 255, 238, 3),
                      offset: Offset(-1, -1),
                      spreadRadius: 1,
                      blurRadius: 1),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: Card(
                  color: widget.color,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    //触发效果慢一些
                    splashFactory:
                        InkSparkle.constantTurbulenceSeedSplashFactory,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MusicWebView(pushid: widget.pushid),
                        ),
                      );
                      print(widget.pushid);
                    },
                    splashColor: Colors.amber.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.avatarUrl),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              //如果required this.isEligibleForRevenue,中的isEligibleForRevenue为true，则显示Icon(Hero_icons_outline.check_badge)
                              const Icon(
                                Hero_icons_outline.check_badge,
                                color: Color.fromRGBO(255, 192, 23, 1),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Stack(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 450,
                                    maxHeight: 200,
                                  ),

                                  // child: AspectRatio(
                                  //   aspectRatio: 16 / 9,
                                  //   child: HoverToZoom(
                                  //     imagePath: '${widget.imageUrl}',
                                  //   ),
                                  // ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      widget.postImg,
                                      height: 500,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PassportDialogRoute<void>(
                                            builder: (context) {
                                              return PassportDialog(
                                                host: widget.apartment.host,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Passport(
                                        key: ValueKey(
                                            'passport_${widget.apartment.host.id}'),
                                        host: widget.apartment.host,
                                        controller: _controller,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            double containerWidth = constraints.maxWidth * 0.65;
                            return Container(
                              width: containerWidth,
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 8),
                          Text(
                            widget.readingTime,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: FavoriteButton(),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        // Text and icon color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Change the shape here
          side: BorderSide(
              color: const Color.fromARGB(255, 192, 147, 147)), // Border color
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: 15), // Button padding
      ),
      child: LikeButton(
        // onTap: (bool isLiked) {
        //   return Future.value(!isLiked);
        // },
        animationDuration: Duration(milliseconds: 800),
        size: 20,
        circleColor: CircleColor(
            start: Color(0xff00ddff), end: Color.fromARGB(255, 241, 32, 32)),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Color.fromARGB(255, 229, 164, 12),
          dotSecondaryColor: Color.fromARGB(255, 221, 218, 26),
        ),
        bubblesSize: 100,
        likeBuilder: (bool isLiked) {
          return Icon(
            applyTextScaling: true,
            Hero_icons_outline.heart,
            color: isLiked ? Color.fromARGB(255, 150, 213, 42) : Colors.grey,
            size: 20,
          );
        },
        likeCount: 25,
      ),
    );
  }
}
