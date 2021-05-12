import 'package:flutter/material.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/pages/admin.dart';
import 'package:provider/provider.dart';

class DataInfoPage extends StatefulWidget {
  const DataInfoPage({Key key}) : super(key: key);

  @override
  _DataInfoPageState createState() => _DataInfoPageState();
}

class _DataInfoPageState extends State<DataInfoPage> {
  Future users;
  Future contents;
  Future notifications;
  Future categories;
  Future featuredItems;

  initData() async {
    users = context.read<AdminBloc>().getTotalDocuments('users_count');
    contents = context.read<AdminBloc>().getTotalDocuments('contents_count');
    notifications =
        context.read<AdminBloc>().getTotalDocuments('notifications_count');
    categories =
        context.read<AdminBloc>().getTotalDocuments('categories_count');
    featuredItems =
        context.read<AdminBloc>().getTotalDocuments('featured_count');
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://img.freepik.com/free-vector/white-abstract-background_23-2148810113.jpg?size=626&ext=jpg&ga=GA1.2.1348306104.1615852800'),
              fit: BoxFit.cover)),
      padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05, top: w * 0.05),
      child: Column(
        children: [
          Container(
            child: Text(
              'total uploded artical count shown here',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              left: 10,
              bottom: 5,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 10),
            child: Image.asset('assets/images/admin.png'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 180,
                width: 180,
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
                            'https://global-uploads.webflow.com/5bf4baa92b7f991d7cb2fc22/5bf4baa92b7f99d1a5b2fdcf_select-template.png'))),
              ),
              SizedBox(
                width: 30,
              ),
              FutureBuilder(
                future: contents,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL ARTICLES', 0);
                  if (snap.hasError) return card('TOTAL ARTICLES', 0);
                  return card('TOTAL ARTICLES', snap.data);
                },
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        offset: Offset(3, 3))
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Direct to artical page\n'
                        '> to add new image articals\n'
                        '> to add new video articals',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.send_outlined,
                      ),
                      label: Text(">>>"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )
                    // your button beneath text
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Text(
              'total loged in user count shown here',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              left: 10,
              bottom: 5,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 10),
            child: Image.asset('assets/images/admin.png'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 180,
                width: 180,
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
                            'https://misterexportir.com/wp-content/uploads/2020/06/peluang-bisnis-online.png'))),
              ),
              SizedBox(
                width: 30,
              ),
              FutureBuilder(
                future: users,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL USERS', 0);
                  if (snap.hasError) return card('TOTAL USERS', 0);
                  return card('TOTAL USERS', snap.data);
                },
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        offset: Offset(3, 3))
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Direct to users page\n',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.send_outlined,
                      ),
                      label: Text(">>>"),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )
                    // your button beneath text
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Text(
              'total created category count shown here',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              left: 10,
              bottom: 5,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 10),
            child: Image.asset('assets/images/admin.png'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 180,
                width: 180,
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
                            'https://i.ytimg.com/vi/VnnhVhmtqdo/maxresdefault.jpg'))),
              ),
              SizedBox(
                width: 30,
              ),
              FutureBuilder(
                future: categories,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL CATEGORIES', 0);
                  if (snap.hasError) return card('TOTAL CATEGORIES', 0);
                  return card('TOTAL CATEGORIES', snap.data);
                },
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        offset: Offset(3, 3))
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Direct to category page\n'
                        '> to add new categories\n'
                        '> to delete categories',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.send_outlined,
                      ),
                      label: Text(">>>"),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )
                    // your button beneath text
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget card(String title, int number) {
    return Container(
      padding: EdgeInsets.all(30),
      height: 180,
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              // shadows: [
              //   Shadow(
              //     color: Colors.grey,
              //     blurRadius: 1.0,
              //     offset: Offset(0.0, 3.0),
              //   ),
              //   // Shadow(
              //   //   color: Colors.red,
              //   //   blurRadius: 1.0,
              //   //   offset: Offset(-2.0, 5.0),
              //   // ),
              // ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 4,
            width: 230,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15)),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.timeline_outlined,
                size: 40,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                number.toString(),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              )
            ],
          )
        ],
      ),
    );
  }
}
