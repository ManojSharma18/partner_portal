import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/screens/dashboard_screen.dart';

import '../constants/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: GlobalVariables.primaryColor,
        //   toolbarHeight: 220,
        //   shadowColor: GlobalVariables.whiteColor,
        //   elevation: 10,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(1000))
        //   ),
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xfffbb830),
                          // Color(0xFFE94057),
                          // Color(0xFFF27121),
                          Color(0xfffbb830),
                        ]
                    )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      // Image.asset("assets/images/logo-removebg-preview.png",width: 150,height: 130,fit: BoxFit.fill,),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.whiteColor, // Set the background color of the circle
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/logo1-removebg-preview.png",
                            width: 90,
                            height: 90,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Image.asset(
                        "assets/images/slys-removebg-preview.png",
                        width: 100,
                        height: 50,
                        // fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 480,
                        width: 325,
                        decoration: BoxDecoration(
                          color: GlobalVariables.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            Text("Please login to your account",style:
                            SafeGoogleFont(
                              'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:Colors.grey,
                            ),),
                            SizedBox(height: 30,),
                            Container(
                              width: 280,
                              height: 60,
                              child: TextFormField(
                                controller: emailController,
                                cursorHeight: 20,
                                cursorRadius: Radius.circular(10),
                                showCursor: true,
                                cursorColor: GlobalVariables.primaryColor,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                    ),
                                    disabledBorder: InputBorder.none,

                                    labelText: 'Mobile Number',
                                    labelStyle: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:GlobalVariables.textColor,
                                    ),
                                    prefixIcon: Icon(Icons.phone_android,size: 17,)
                                ),
                              ),
                            ) ,
                            SizedBox(height: 20,),
                            Container(
                              width: 280,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                cursorHeight: 20,
                                cursorRadius: Radius.circular(10),
                                showCursor: true,
                                cursorColor: GlobalVariables.primaryColor,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                    ),
                                    disabledBorder: InputBorder.none,
                                    labelText: 'Password',
                                    labelStyle: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:GlobalVariables.textColor,
                                    ),
                                    prefixIcon: Icon(Icons.lock_open_rounded,size: 17,),
                                    suffixIcon: Icon(Icons.remove_red_eye,size: 17,)
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Forget password",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.orangeAccent[700],
                                  ),),



                                ],
                              ),),

                            SizedBox(height: 20,),

                            InkWell(
                              onTap: (){
                                // if(emailController.text == "Admin" && passwordController.text=="Password")
                                //   {
                                //     Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                                //   }
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xfffbb830),
                                          // Color(0xFFF27121),
                                          Color(0xfffbb830),
                                        ]
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('Login',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:GlobalVariables.textColor,
                                    ),),
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),

                            RichText(
                              text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " Partner with us",
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color:GlobalVariables.primaryColor,
                                      ),
                                    )
                                  ]
                              ),

                            )

                          ],
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }, tabletBuilder:(BuildContext context,BoxConstraints constraints){
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: GlobalVariables.primaryColor,
      //   toolbarHeight: 220,
      //   shadowColor: GlobalVariables.whiteColor,
      //   elevation: 10,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(1000))
      //   ),
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xfffbb830),
                        // Color(0xFFE94057),
                        // Color(0xFFF27121),
                        Color(0xfffbb830),
                      ]
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40,),
                    // Image.asset("assets/images/logo-removebg-preview.png",width: 150,height: 130,fit: BoxFit.fill,),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.whiteColor, // Set the background color of the circle
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/logo1-removebg-preview.png",
                          width: 90,
                          height: 90,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Image.asset(
                      "assets/images/slys-removebg-preview.png",
                      width: 100,
                      height: 50,
                      // fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 480,
                      width: 325,
                      decoration: BoxDecoration(
                        color: GlobalVariables.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30,),
                          Text("Please login to your account",style:
                          SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color:Colors.grey,
                          ),),
                          SizedBox(height: 30,),
                          Container(
                            width: 280,
                            height: 60,
                            child: TextFormField(
                              controller: emailController,
                              cursorHeight: 20,
                              cursorRadius: Radius.circular(10),
                              showCursor: true,
                              cursorColor: GlobalVariables.primaryColor,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                  ),
                                  disabledBorder: InputBorder.none,

                                  labelText: 'Mobile Number',
                                  labelStyle: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:GlobalVariables.textColor,
                                  ),
                                  prefixIcon: Icon(Icons.phone_android,size: 17,)
                              ),
                            ),
                          ) ,
                          SizedBox(height: 20,),
                          Container(
                            width: 280,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              cursorHeight: 20,
                              cursorRadius: Radius.circular(10),
                              showCursor: true,
                              cursorColor: GlobalVariables.primaryColor,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                  ),
                                  disabledBorder: InputBorder.none,
                                  labelText: 'Password',
                                  labelStyle: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:GlobalVariables.textColor,
                                  ),
                                  prefixIcon: Icon(Icons.lock_open_rounded,size: 17,),
                                  suffixIcon: Icon(Icons.remove_red_eye,size: 17,)
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Forget password",style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color:Colors.orangeAccent[700],
                                ),),



                              ],
                            ),),

                          SizedBox(height: 20,),

                          InkWell(
                            onTap: (){
                              // if(emailController.text == "Admin" && passwordController.text=="Password")
                              //   {
                              //     Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                              //   }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfffbb830),
                                        // Color(0xFFF27121),
                                        Color(0xfffbb830),
                                      ]
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text('Login',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),

                          RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: " Partner with us",
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color:GlobalVariables.primaryColor,
                                    ),
                                  )
                                ]
                            ),

                          )

                        ],
                      ),
                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );},
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: GlobalVariables.primaryColor,
      //   toolbarHeight: 220,
      //   shadowColor: GlobalVariables.whiteColor,
      //   elevation: 10,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(1000))
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xfffbb830),
              // Color(0xFFE94057),
              // Color(0xFFF27121),
                Color(0xfffbb830),
              ]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
            // Image.asset("assets/images/logo-removebg-preview.png",width: 150,height: 130,fit: BoxFit.fill,),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GlobalVariables.whiteColor, // Set the background color of the circle
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/logo1-removebg-preview.png",
                    width: 90,
                    height: 90,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Image.asset(
                "assets/images/slys-removebg-preview.png",
                width: 100,
                height: 50,
                // fit: BoxFit.cover,
              ),
              SizedBox(height: 20,),
              Container(
                height: 480,
                width: 325,
                decoration: BoxDecoration(
                  color: GlobalVariables.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Text("Please login to your account",style:
                    SafeGoogleFont(
                      'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:Colors.grey,
                    ),),
                    SizedBox(height: 30,),
                    Container(
                      width: 280,
                      height: 60,
                      child: TextFormField(
                        controller: emailController,
                          cursorHeight: 20,
                          cursorRadius: Radius.circular(10),
                          showCursor: true,
                          cursorColor: GlobalVariables.primaryColor,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            disabledBorder: InputBorder.none,

                          labelText: 'Mobile Number',
                          labelStyle: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:GlobalVariables.textColor,
                          ),
                          prefixIcon: Icon(Icons.phone_android,size: 17,)
                        ),
                      ),
                    ) ,
                    SizedBox(height: 20,),
                    Container(
                      width: 280,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        cursorHeight: 20,
                        cursorRadius: Radius.circular(10),
                        showCursor: true,
                        cursorColor: GlobalVariables.primaryColor,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            disabledBorder: InputBorder.none,
                            labelText: 'Password',
                            labelStyle: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:GlobalVariables.textColor,
                            ),
                            prefixIcon: Icon(Icons.lock_open_rounded,size: 17,),
                            suffixIcon: Icon(Icons.remove_red_eye,size: 17,)
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forget password",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color:Colors.orangeAccent[700],
                        ),),



                      ],
                    ),),

                    SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        // if(emailController.text == "Admin" && passwordController.text=="Password")
                        //   {
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                        //   }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xfffbb830),
                              // Color(0xFFF27121),
                              Color(0xfffbb830),
                            ]
                          )
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Login',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),

                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),
                        children: [
                          TextSpan(
                            text: " Partner with us",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.primaryColor,
                            ),
                          )
                        ]
                      ),

                    )

                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
    }
    );
  }
}
