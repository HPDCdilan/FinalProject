import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/config/config.dart';
import 'package:news_admin/pages/admin.dart';
import 'package:news_admin/pages/articles.dart';
import 'package:news_admin/pages/content_notifications.dart';
import 'package:news_admin/pages/data_info.dart';
import 'package:news_admin/pages/featured.dart';
import 'package:news_admin/pages/notifications.dart';
import 'package:news_admin/pages/settings.dart';
import 'package:news_admin/pages/sign_in.dart';
import 'package:news_admin/pages/categories.dart';
import 'package:news_admin/pages/upload_content.dart';
import 'package:news_admin/pages/users.dart';
import 'package:news_admin/utils/next_screen.dart';
import 'package:news_admin/widgets/cover_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  final List<String> titles = [
    'Home',
    'Articles',
    'Featured Articles',
    'Upload Article',
    'Categories',
    'Push Notifications',
    'Content Notifications',
    'Users',
    'Admin',
    'Settings'
  ];

  final List icons = [
    LineIcons.home,
    LineIcons.file_archive_o,
    LineIcons.bomb,
    LineIcons.arrow_circle_up,
    LineIcons.map_pin,
    LineIcons.bell,
    LineIcons.file_photo_o,
    LineIcons.users,
    LineIcons.user_secret,
    LineIcons.chain
  ];

  Future handleLogOut() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp
        .clear()
        .then((value) => nextScreenCloseOthers(context, SignInPage()));
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      context.read<AdminBloc>().getCategories();
      context.read<AdminBloc>().getAdsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    return Scaffold(
      appBar: _appBar(ab),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                // ? create verticl tab
                child: VerticalTabs(
                  tabBackgroundColor: Colors.white,

                  backgroundColor: Colors.grey[200],
                  tabsElevation: 10,
                  tabsShadowColor: Colors.grey[500],
                  tabsWidth: 250,
                  indicatorColor: Colors.blue[900],
                  selectedTabBackgroundColor:
                      Colors.blueAccent.withOpacity(0.5),

                  indicatorWidth: 5,
                  disabledChangePageFromContentView: true, //!
                  initialIndex: _pageIndex,
                  // ? change page navigation duration. if duration is high it navigate to page by page
                  changePageDuration: Duration(microseconds: 1),
                  tabs: <Tab>[
                    //? contents
                    tab(titles[0], icons[0]),
                    tab(titles[1], icons[1]),
                    tab(titles[2], icons[2]),
                    tab(titles[3], icons[3]),
                    tab(titles[4], icons[4]),
                    tab(titles[5], icons[5]),
                    tab(titles[6], icons[6]),
                    tab(titles[7], icons[7]),
                    tab(titles[8], icons[8]),
                    tab(titles[9], icons[9]),
                  ],
                  contents: <Widget>[
                    DataInfoPage(),
                    CoverWidget(widget: Articles()),
                    CoverWidget(widget: FeaturedArticles()),
                    CoverWidget(widget: UploadContent()),
                    CoverWidget(widget: Categories()),
                    CoverWidget(widget: Notifications()),
                    CoverWidget(widget: ContentNotifications()),
                    CoverWidget(widget: UsersPage()),
                    CoverWidget(widget: AdminPage()),
                    CoverWidget(widget: Settings())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tab(title, icon) {
    return Tab(
        child: Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(50),
      //   border: Border.all(color: Colors.blueAccent, width: 3),
      //),
      padding: EdgeInsets.only(
        left: 10,
      ),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
            color: Colors.blueAccent,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[900],
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    ));
  }

  Widget _appBar(ab) {
    return PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          height: 60,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.lightBlueAccent,
                blurRadius: 10,
                offset: Offset(0, 5))
          ]),
          child: Row(
            children: <Widget>[
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10,
                            offset: Offset(3, 3))
                      ],
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/en/9/9b/NSBM_Green_University_seal.png')))),
              SizedBox(
                width: 5,
              ),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent,
                          fontFamily: 'Muli'),
                      text: Config().appName,
                      children: <TextSpan>[
                    TextSpan(
                        text: ' - Admin Control Panel',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                            fontFamily: 'Muli'))
                  ])),
              Spacer(),
              Container(
                  child: Text(DateFormat("dd MMMM yy").format(DateTime.now()))),

              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ]),
                child: FlatButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  icon: Icon(
                    LineIcons.sign_out,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Sign-out',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  onPressed: () => handleLogOut(),
                ),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              // // Container(
              // //   margin: EdgeInsets.all(10),
              // //   padding: EdgeInsets.only(left: 10, right: 10),
              // //   decoration: BoxDecoration(
              // //     border: Border.all(color: Colors.deepPurpleAccent),
              // //     borderRadius: BorderRadius.circular(20),
              // //   ),
              // //   child: FlatButton.icon(
              // //     shape: RoundedRectangleBorder(
              // //         borderRadius: BorderRadius.circular(20)),
              // //     icon: Icon(
              // //       LineIcons.user,
              // //       color: Colors.grey[800],
              // //       size: 20,
              // //     ),
              // //     label: Text(
              // //       'Signed as ${ab.userType}',
              // //       style: TextStyle(
              // //           fontWeight: FontWeight.w400,
              // //           color: Colors.deepPurpleAccent,
              // //           fontSize: 16),
              // //     ),
              // //     onPressed: () => null,
              // //   ),
              // // ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ));
  }
}
