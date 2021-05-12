import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/models/category.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/styles.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Category> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'categories';

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Category.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
      openToast(context, 'No more contents available!');
    }
    return null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  refreshData() {
    setState(() {
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    _getData();
  }

  handleDelete(timestamp1) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(0.8),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: new BorderSide(
                  style: BorderStyle.none,
                )),
            children: <Widget>[
              Text(
                  'Are you sure you want to remove this?\n'
                  'You may face some tecnical issues \nfrom creates articals that belongs to this category',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Are you sure you want to delete this from database.\n'
                  'You can not recover this category after selecting CONFIRM\n'
                  '(You can add same category status again from New button)',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Column(
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.red,
                    child: Text(
                      'CONFIRM',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (ab.userType == 'tester') {
                        Navigator.pop(context);
                        openDialog(context, 'You are a Tester',
                            'You need admin privalages to continue the task');
                      } else {
                        await ab
                            .deleteContent(timestamp1, collectionName)
                            .then((value) => ab.getCategories())
                            .then(
                                (value) => ab.decreaseCount('categories_count'))
                            .then((value) => openToast1(context, 'Deleted'));
                        refreshData();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.blueAccent,
                    child: Text(
                      'GO BACK',
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
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              width: 35,
            ),
            Text('Add New categories to create new arical contents\n'
                'Delete created categories to remove cateory from database'),
            Spacer(),
            Container(
              width: 200,
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Colors.white60,
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton.icon(
                  onPressed: () {
                    openAddDialog();
                  },
                  icon: Icon(Icons.add_box_outlined),
                  label: Text('    New')),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        //!!!!!!!!!margin
        // Center(
        //   child: Container(
        //     margin: EdgeInsets.only(top: 5, bottom: 10),
        //     height: 3,
        //     width: 1100,
        //     decoration: BoxDecoration(
        //       color: Colors.black45,
        //       borderRadius: BorderRadius.circular(15),
        //       boxShadow: <BoxShadow>[
        //         BoxShadow(
        //             color: Colors.blueAccent,
        //             blurRadius: 10,
        //             offset: Offset(3, 6)),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: RefreshIndicator(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              controller: controller,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _data.length + 1,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 10,
              ),
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

  Widget dataList(Category d) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 6)),
          ],
          image: DecorationImage(
              image: CachedNetworkImageProvider(d.thumbnailUrl),
              fit: BoxFit.cover)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(15)),
            child: Text(
              d.name,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45),
            ),
          ),
          Spacer(),
          InkWell(
              child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.delete, size: 16, color: Colors.redAccent)),
              onTap: () {
                handleDelete(d.timestamp);
              }),
        ],
      ),
    );
  }

  var formKey = GlobalKey<FormState>();
  var nameCtrl = TextEditingController();
  var thumbnailCtrl = TextEditingController();
  String timestamp;

  Future addCategory() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(timestamp);
    await ref.set({
      'name': nameCtrl.text,
      'thumbnail': thumbnailCtrl.text,
      'timestamp': timestamp
    });
  }

  handleAddCategory() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ab.userType == 'tester') {
        Navigator.pop(context);
        openDialog(context, 'You are a Tester', 'Only admin can add contents');
      } else {
        await getTimestamp()
            .then((value) => addCategory())
            .then((value) =>
                context.read<AdminBloc>().increaseCount('categories_count'))
            .then((value) => openToast1(context, 'Added Successfully'))
            .then((value) => ab.getCategories());
        refreshData();
        Navigator.pop(context);
      }
    }
  }

  clearTextfields() {
    nameCtrl.clear();
    thumbnailCtrl.clear();
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      timestamp = _timestamp;
    });
  }

  openAddDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(100),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: <Widget>[
              Text(
                'Create New Category',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: inputDecoration(
                            'Enter Category Name', 'Category Name', nameCtrl),
                        controller: nameCtrl,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Can not continue with the empty Name';
                          return null;
                        },
                      ),
                      Text(
                        'This category name will also update in application view',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: inputDecoration('Enter Thumbnail Url',
                            'Thumbnail Url', thumbnailCtrl),
                        controller: thumbnailCtrl,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Can not continue with the empty Thumbnail url';
                          return null;
                        },
                      ),
                      Text(
                        'Add only a .jpg or .png format image url adress\n'
                        'Otherwise thumbnail will not show in the categories list',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Row(
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            color: Colors.blueAccent,
                            child: Text(
                              'ADD TO LIST 👍',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              await handleAddCategory();
                              clearTextfields();
                            },
                          ),
                          SizedBox(width: 25),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            color: Colors.blueAccent,
                            child: Text(
                              'GO BACK',
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
                  ))
            ],
          );
        });
  }
}
