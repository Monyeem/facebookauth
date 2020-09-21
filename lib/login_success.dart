import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;





class loginpage extends StatefulWidget {
  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {




  bool _isLoggedInfb =false;

  Map userProfile;
  final facebookLogin = FacebookLogin();

  // var twitterLogin = new TwitterLogin(
  //     consumerKey: null,
  //     consumerSecret: null
  // );



  _loginfb() async{
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedInfb = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedInfb = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedInfb = false );
        break;
    }

  }

  _logoutfb() async{
    facebookLogin.logOut();
    setState(() {
      _isLoggedInfb = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),

      body: Column(
        children: [
           Center(
              child: _isLoggedInfb
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(userProfile["picture"]["data"]["url"],
                    height: 50,
                    width: 50,
                  ),
                  Text(userProfile["name"]),

                  OutlineButton(
                      child: Text("Logout"),
                      onPressed: (){
                        _logoutfb();
                      }
                  )

                ],
              ):
              OutlineButton(
                child: Text("Login with Facebook"),
                onPressed: (){
                  _loginfb();

                },
              )

          ),
        ],
      ),
    );
  }
}
