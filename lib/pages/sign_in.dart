import 'package:flutter/cupertino.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/config/config.dart';
import 'package:news_admin/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var passwordCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String password;

  void handleSignIn() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (password == Config().testerPassword) {
        await ab.setSignInForTesting().then((value) {
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => HomePage()));
        });
      } else {
        await ab.setSignIn().then((value) {
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => HomePage()));
        });
      }
    }
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

    return Scaffold(
        //backgroundColor: Colors.grey[400],

        body: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover)),
      child: Center(
        child: Container(
          height: 400,
          width: 600,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                Config().appName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              Text(
                'Welcome to Help Desk Admin Panel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Image.network(
                'https://dulana123.files.wordpress.com/2017/09/nsbm-logo.png?w=736',
                height: 80,
                width: 100,
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          contentPadding: EdgeInsets.only(right: 0, left: 10),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                  icon: Icon(Icons.close, size: 15),
                                  onPressed: () {
                                    passwordCtrl.clear();
                                  }),
                            ),
                          )),
                      validator: (String value) {
                        String _adminPassword = ab.adminPass;
                        if (value.length == 0)
                          return "Password can't be empty";
                        else if (value != _adminPassword &&
                            value != Config().testerPassword)
                          return 'Wrong Password! Please try again.';

                        return null;
                      },
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ]),
                child: FlatButton.icon(
                  //padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  icon: Icon(
                    LineIcons.sign_in,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  onPressed: () => handleSignIn(),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '       This is an announcement pannel\n'
                'only admins can able to post and edit here',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
