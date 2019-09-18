import 'package:jtbMusicPlayer/utils/JtbSplashPageItem.dart';
import 'package:flutter/material.dart';
import 'package:jtbMusicPlayer/utils/my_navigator.dart';
import 'package:jtbMusicPlayer/widgets/walkthrough.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                Walkthrough(
                  title: JtbSplashPageItem.wt1,
                  content: JtbSplashPageItem.wc1,
                  imageIcon: Icons.mobile_screen_share,
                ),
                Walkthrough(
                  title: JtbSplashPageItem.wt2,
                  content: JtbSplashPageItem.wc2,
                  imageIcon: Icons.search,
                ),
                Walkthrough(
                  title: JtbSplashPageItem.wt3,
                  content: JtbSplashPageItem.wc3,
                  imageIcon: Icons.shopping_cart,
                ),
                Walkthrough(
                  title: JtbSplashPageItem.wt4,
                  content: JtbSplashPageItem.wc4,
                  imageIcon: Icons.verified_user,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : JtbSplashPageItem.skip,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                      lastPage ? null : MyNavigator.goToHome(context),
                ),
                FlatButton(
                  child: Text(lastPage ? JtbSplashPageItem.gotIt : JtbSplashPageItem.next,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? MyNavigator.goToHome(context)
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
