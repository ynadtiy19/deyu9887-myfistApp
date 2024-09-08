import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hung/ui/views/article/article_view.dart';
import 'package:hung/ui/views/chat/chat_view.dart';
import 'package:hung/ui/views/profile/profile_view.dart';
import 'package:hung/ui/widgets/common/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
      child: Scaffold(
        bottomNavigationBar: MeBottomNavigationBar(
          (index) {
            // 处理底部导航栏按钮点击事件
            viewModel.onTabChange(index);
            print('Selected Index changed to: $index');
            // print('Selected Index: $index');
          },
        ),
        body: IndexedStack(
          index: viewModel.uuuindex,
          children: <Widget>[
            const ChatView(),
            const ArticleView(), // 传递 `jsonCache`
            // TravelcardView(),
            Container(
              color: Colors.green,
            ),
            const ProfileView(),
            // 其他视图...
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
