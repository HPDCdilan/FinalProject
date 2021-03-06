import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/blocs/notification_bloc.dart';
import 'package:news_admin/models/article.dart';
import 'package:news_admin/pages/comments.dart';
import 'package:news_admin/utils/cached_image.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/empty.dart';
import 'package:news_admin/utils/next_screen.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:news_admin/widgets/article_preview.dart';
import 'package:provider/provider.dart';

class ContentNotifications extends StatefulWidget {
  ContentNotifications({Key key}) : super(key: key);

  @override
  _ContentNotificationsState createState() => _ContentNotificationsState();
}

class _ContentNotificationsState extends State<ContentNotifications> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = new List<DocumentSnapshot>();
  List<Article> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final collectionName = 'contents';
  bool _hasData;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (this.mounted) {
      _getData();
    }
  }

  Future<Null> _getData() async {
    await context
        .read<NotificationBloc>()
        .getContentNotificationsList()
        .then((notificationsList) async {
      if (notificationsList.isNotEmpty) {
        setState(() => _hasData = true);
        QuerySnapshot data;
        if (_lastVisible == null)
          data = await firestore
              .collection(collectionName)
              .where('timestamp', whereIn: notificationsList)
              .limit(20)
              .get();

        if (data.docs.isNotEmpty) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _snap.addAll(data.docs);
              _data = _snap.map((e) => Article.fromFirestore(e)).toList();
              _data.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            });
          }
        } else {
          setState(() {
            _hasData = false;
            _isLoading = false;
          });
        }
        return null;
      } else {
        return null;
      }
    });
  }

  refreshData() {
    setState(() {
      _isLoading = true;
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    _getData();
  }

  handlePreview(Article d) async {
    await showArticlePreview(
        context,
        d.title,
        d.description,
        d.thumbnailImagelUrl,
        d.loves,
        d.sourceUrl ?? '',
        d.date,
        d.category,
        d.contentType,
        d.contentType);
  }

  handleDelete(Article d) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            children: <Widget>[
              Text('Delete?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text('Want to delete this item from the database?',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.redAccent,
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (ab.userType == 'tester') {
                        Navigator.pop(context);
                        openDialog(context, 'You are a Tester',
                            'Only admin can delete contents');
                      } else {
                        await context
                            .read<NotificationBloc>()
                            .removeFromNotificationList(context, d.timestamp)
                            .then((value) =>
                                ab.decreaseCount('notifications_count'))
                            .then((value) =>
                                openToast1(context, 'Deleted Successfully'));
                        refreshData();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.deepPurpleAccent,
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Center(
          child: Text(
            'Conternt Notification',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        Center(
          child: Text('Comment, View and Delete Content Notification'),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 10),
            height: 3,
            width: 670,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    offset: Offset(3, 6)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _hasData == false
              ? emptyPage(LineIcons.bell, 'No data available')
              : RefreshIndicator(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _data.length + 1,
                    itemBuilder: (_, int index) {
                      if (index < _data.length) {
                        return dataList(_data[index]);
                      }
                      return Center(
                        child: new Opacity(
                          opacity: _isLoading ? 1.0 : 0.0,
                          child: new SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: new CircularProgressIndicator()),
                        ),
                      );
                    },
                  ),
                  onRefresh: () async {
                    refreshData();
                  },
                ),
        ),
      ],
    );
  }

  Widget dataList(Article d) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 6)),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomCacheImage(
              imageUrl: d.thumbnailImagelUrl,
              radius: 10,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    d.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          d.category,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(width: 3),
                      Text(
                        d.date,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: Colors.grey,
                            ),
                            Text(
                              d.loves.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        child: Container(
                          height: 35,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.comment,
                            size: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        onTap: () => nextScreenPopuup(
                            context, CommentsPage(timestamp: d.timestamp)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          child: Container(
                              height: 35,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.remove_red_eye,
                                  size: 16, color: Colors.grey[800])),
                          onTap: () {
                            handlePreview(d);
                          }),
                      SizedBox(width: 10),
                      // InkWell(
                      //   child: Container(
                      //       height: 35,
                      //       width: 45,
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey[200],
                      //           borderRadius: BorderRadius.circular(10)),
                      //       child: Icon(Icons.edit,
                      //           size: 16, color: Colors.grey[800])),
                      //   onTap: () {
                      //     nextScreen(context, UpdateContent(data: d));
                      //   },
                      // ),
                      // SizedBox(width: 10),
                      InkWell(
                        child: Container(
                            height: 35,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.delete,
                                size: 16, color: Colors.redAccent)),
                        onTap: () {
                          handleDelete(d);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
