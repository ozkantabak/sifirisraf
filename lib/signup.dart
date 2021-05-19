import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sifirisraf/utils/variables.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();

  signup(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text, password: passwordcontroller.text).then((signeduser) {
          usercollection.doc(signeduser.user.uid).set({
            'username': usernamecontroller.text,
            'password': passwordcontroller.text,
            'email': emailcontroller.text,
            'uid': signeduser.user.uid,
            'profilepic': 'https://www.gstatic.com/images/branding/product/2x/avatar_square_blue_120dp.png'
          });
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 80),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sıfır İsraf",
                style: mystyle(30,Colors.white,FontWeight.w600),
              ),
              SizedBox(height: 10,),
              Text("Hesap Oluştur", style: mystyle(25,Colors.white,FontWeight.w600),),
              SizedBox(height: 20,),
              Container(
                width: 64,
                height: 64,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20,right: 20),
                child: TextField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      labelStyle: mystyle(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.email)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20,right: 20),
                child: TextField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Parola',
                      labelStyle: mystyle(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20,right: 20),
                child: TextField(
                  controller: usernamecontroller,
                  //obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Kullanıcı Adı',
                      labelStyle: mystyle(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: ()=>signup(),
                child: Container(
                  width: MediaQuery.of(context).size.width /2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text('Kaydolun',
                      style: mystyle(20, Colors.black, FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kullanım koşullarını kabul ediyorum."
                    ,style: mystyle(20),
                  ),
                  SizedBox(width: 10),
                  /*InkWell(
                    //onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Terms())),
                    child: Text(
                      "Kabul ediyorum",
                      style: mystyle(20,Colors.purple, FontWeight.w700),
                    ),
                  ),*/
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

