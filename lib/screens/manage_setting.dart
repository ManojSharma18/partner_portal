import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';

class ManageSetting extends StatefulWidget {
  const ManageSetting({Key? key}) : super(key: key);

  @override
  State<ManageSetting> createState() => _ManageSettingState();
}

class _ManageSettingState extends State<ManageSetting> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  String selectedType = "View all";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
  }

  List<String> outletList = ['Preference','Outlet information','Bank details','Outlet Timings','FSSAI','GST'];

  List<String> permission = ['Outlet Permission','App permission','Communication permission'];

  String selectedPermission = "";

  bool number = true;

  List<Map<String,dynamic>> staff =[
    {
      "role" : "Owner",
      "number" : "+91 8431944706",
      "name" : "Krishna",
      "email" : "krishna@gmail.com"
    },

    {
      "role" : "Manager",
      "number" : "+91 8105445911",
      "name" : "Manoj",
      "email" : "manojsharma1882001@gmail.com"
    }
  ];

  Map<String,dynamic> selectedStaff =  {
    "role" : "Owner",
    "number" : "+91 8431944706",
    "name" : "Krishna",
    "email" : "krishna@gmail.com"
  };
  List<String> roleType = ['Owner','Manager'];

  String selectedOutlet = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController numberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xFF363563);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color lighterColor = baseColor.withOpacity(0.1);
    nameController.text = selectedStaff['name'] ?? '';
    numberController.text = selectedStaff['number'] ?? '';
    emailController.text = selectedStaff['email'] ?? '';
    roleController.text = selectedStaff['role'] ?? '';
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 80,
        title: Row(
          children: [
            Text("MANAGE OUTLET",style: SafeGoogleFont(
              'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
            SizedBox(width: 50,),
            // Switch(
            //     activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
            //     inactiveTrackColor: Colors.grey,
            //     inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
            //     inactiveThumbColor: GlobalVariables.whiteColor,
            //     value: isOpend, onChanged: (val){
            //   setState(() {
            //     isOpend =val;
            //   });
            // }),
            SizedBox(width: 50,),
            // Container(
            //
            //     child: Padding(
            //       padding: const EdgeInsets.all(4.0),
            //       child: Center(child: Text("${DateFormat('dd MMM').format(todday)}",style: SafeGoogleFont(
            //         'Poppins',
            //         fontSize: 14,
            //         fontWeight: FontWeight.bold,
            //         color: Color(0xFF363563),
            //       ),)),
            //     )
            // ),
            SizedBox(width: 50,),
            SearchBars(hintText: "Search....", width: MediaQuery.of(context).size.width/3,height: 45,),
          ],
        ),
        backgroundColor: Color(0xfffbb830),
        actions: [
          Icon(Icons.settings,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          CircleAvatar(
            backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar:AppBar(
                  toolbarHeight: 0,
                  backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 400,
                          child: TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            indicatorColor: Color(0xfffbb830),
                            unselectedLabelColor: Colors.black54,
                            labelColor: Color(0xFF363563),
                            labelStyle: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),
                            tabs: [
                              Tab(text: 'Staff'),
                              Tab(text: 'Outlets'),

                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black45,
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    color: GlobalVariables.whiteColor,
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(

                        body: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    ratingFilter("View all"),
                                    SizedBox(width: 20,),
                                    ratingFilter("Permissions")
                                  ],
                                ),
                                SizedBox(height: 20,),

                                Visibility(
                                  visible:selectedType == "View all" ,
                                  child: Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: ListView.separated(
                                        itemCount: staff.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: (){
                                              setState(() {
                                                selectedStaff = staff[index];
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left:10,right: 10,bottom:10),
                                              decoration: BoxDecoration(
                                                color:  GlobalVariables.whiteColor,
                                                borderRadius: BorderRadius.circular(10),boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey, // You can set the shadow color here
                                                  blurRadius: 5, // Adjust the blur radius as needed
                                                  offset: Offset(0, 2), // Adjust the offset to control the shadow's position
                                                ),
                                              ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Visibility(
                                                    visible: selectedStaff == staff[index],
                                                    child: Container(
                                                      width: 5,
                                                      height:110,
                                                      decoration: BoxDecoration(
                                                          color:  GlobalVariables.textColor,
                                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                                                      ),
                                                      margin:EdgeInsets.only(left: 20,top: 5,bottom: 5),

                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          // height: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                          margin: EdgeInsets.only(left: 0,top: 10),
                                                          padding: EdgeInsets.only(left: 0),
                                                          child: ListTile(
                                                            title: Container(

                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    staff[index]['name'],
                                                                    style: SafeGoogleFont(
                                                                      'Poppins',
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: GlobalVariables.textColor,
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                      onTap: (){


                                                                      },
                                                                      child: Icon(Icons.more_vert,color: GlobalVariables.textColor.withOpacity(0.9),size: 25,)
                                                                  )

                                                                ],
                                                              ),
                                                            ),
                                                            trailing:  Text(
                                                              staff[index]['role'],
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.bold,
                                                                color: GlobalVariables.textColor,
                                                              ),
                                                            ),

                                                          ),
                                                        ),

                                                        SizedBox(height: 5,),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            staff[index]['number'],
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                              color: GlobalVariables.textColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            staff[index]['email'],
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                              color: GlobalVariables.textColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5,),


                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }, separatorBuilder: (BuildContext context, int index) {
                                          return SizedBox(height: 30,);
                                      },
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: selectedType != "View all",
                                  child: Expanded(
                                    flex: 5,
                                    child: ListView.separated(
                                    itemCount: permission.length,
                                    itemBuilder:(context,index){
                                      return InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedPermission = permission[index];
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left:10,right: 10,bottom:10,top: 20),
                                          decoration: BoxDecoration(
                                            color:  GlobalVariables.whiteColor,
                                            borderRadius: BorderRadius.circular(10),boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey, // You can set the shadow color here
                                              blurRadius: 5, // Adjust the blur radius as needed
                                              offset: Offset(0, 2), // Adjust the offset to control the shadow's position
                                            ),
                                          ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Visibility(
                                                visible: selectedPermission == permission[index],
                                                child: Container(
                                                  width: 5,
                                                  height:50,
                                                  decoration: BoxDecoration(
                                                      color:  GlobalVariables.textColor,
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                                                  ),
                                                  margin:EdgeInsets.only(left: 20,top: 5,bottom: 5),

                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      margin: EdgeInsets.only(left: 0,top: 10),
                                                      padding: EdgeInsets.only(left: 0),
                                                      child: ListTile(
                                                        title: Text(outletList[index],style: SafeGoogleFont('Poppins',fontWeight: FontWeight.bold,fontSize: 15,color: GlobalVariables.textColor),),
                                                        trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 18,),

                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                      //   Container(
                                      //   margin: EdgeInsets.only(top: 30,left: 20,right: 20),
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(5),
                                      //     border: Border.all(color: GlobalVariables.textColor.withOpacity(0.2)),
                                      //     color: GlobalVariables.whiteColor
                                      //   ),
                                      //   child: ListTile(
                                      //     title: Text(outletList[index],style: SafeGoogleFont('Poppins',fontWeight: FontWeight.bold,fontSize: 15,color: GlobalVariables.textColor),),
                                      //     trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 18,),
                                      //   ),
                                      // );
                                    }, separatorBuilder: (BuildContext context, int index) {
                                    return SizedBox(height: 20,);
                                                                    },),
                                  ),
                                )

                              ],
                            ),
                            ListView.separated(
                              itemCount: outletList.length,
                                itemBuilder:(context,index){
                              return InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedOutlet = outletList[index];
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left:10,right: 10,bottom:10,top: 20),
                                  decoration: BoxDecoration(
                                    color:  GlobalVariables.whiteColor,
                                    borderRadius: BorderRadius.circular(10),boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey, // You can set the shadow color here
                                      blurRadius: 5, // Adjust the blur radius as needed
                                      offset: Offset(0, 2), // Adjust the offset to control the shadow's position
                                    ),
                                  ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Visibility(
                                        visible: selectedOutlet == outletList[index],
                                        child: Container(
                                          width: 5,
                                          height:50,
                                          decoration: BoxDecoration(
                                              color:  GlobalVariables.textColor,
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                                          ),
                                          margin:EdgeInsets.only(left: 20,top: 5,bottom: 5),

                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              // height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              margin: EdgeInsets.only(left: 0,top: 10),
                                              padding: EdgeInsets.only(left: 0),
                                              child: ListTile(
                                                title: Text(outletList[index],style: SafeGoogleFont('Poppins',fontWeight: FontWeight.bold,fontSize: 15,color: GlobalVariables.textColor),),
                                                trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 18,),

                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              //   Container(
                              //   margin: EdgeInsets.only(top: 30,left: 20,right: 20),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     border: Border.all(color: GlobalVariables.textColor.withOpacity(0.2)),
                              //     color: GlobalVariables.whiteColor
                              //   ),
                              //   child: ListTile(
                              //     title: Text(outletList[index],style: SafeGoogleFont('Poppins',fontWeight: FontWeight.bold,fontSize: 15,color: GlobalVariables.textColor),),
                              //     trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 18,),
                              //   ),
                              // );
                            }, separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 20,);
                            },),

                          ],
                        ),
                        bottomNavigationBar: Visibility(
                          visible: selectedType == "View all" ,
                          child: Padding(
                            padding:  EdgeInsets.only(right: 0,left: 0*fem),
                            child: BottomNavigationBar(
                              elevation: 3,
                              type: BottomNavigationBarType.fixed,


                              items: [

                                BottomNavigationBarItem(
                                  icon: Container(),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 1*fem,right: 10),
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Invite new user",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black45,
                  width: 1,
                ),
                Expanded(
                  flex: 5,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      selectedType == "View all" ?
                      Scaffold(
                        appBar: AppBar(

                          title: Text(
                            "${selectedStaff['name']}'s Profile" ?? '',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),
                          ),
                          elevation: 3,
                          backgroundColor: GlobalVariables.whiteColor,
                        ),
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(left: 20,top: 20),
                              child: Text(
                                "Contact information",
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF363563),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextField(label: "Name", controller: nameController,width: 55*fem,
                                    onChanged: (val){

                                    },
                                  ),
                                  CustomTextField(label: "Number", controller: numberController,width: 55*fem,),

                                  CustomTextField(label: "Role", controller: roleController,width: 55*fem,isDropdown: true,dropdownItems: roleType,
                                    onChanged: (val) {
                                      // ItemDetails.checking = true;
                                    },),

                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              margin: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(label: "Email", controller: emailController,width: 70*fem,onChanged: (val) {

                                  },),
                                  SizedBox(width: 20*fem,),
                                  Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text("Whatsapp communication",
                                        style:TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 15,),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            number = !number ;
                                          });
                                        },
                                        child: Container(
                                          width: 140,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.grey.shade200),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Container(
                                                  width: 65,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                      color: number
                                                          ? Colors.white
                                                          : Colors.grey.shade200),
                                                  child: Center(
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Open Sans',
                                                            color: number
                                                                ? Color(0xfffbb830)
                                                                : Colors.black),
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Container(
                                                  width: 65,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                      color: number
                                                          ? Colors.grey.shade200
                                                          : Colors.white),
                                                  child: Center(
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Open Sans',
                                                            color: number
                                                                ? Colors.black
                                                                : Color(0xfffbb830)),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        bottomNavigationBar: Padding(
                          padding:  EdgeInsets.only(right: 0,left: 0*fem),
                          child: BottomNavigationBar(
                            elevation: 3,
                            type: BottomNavigationBarType.fixed,
                            items: [
                              BottomNavigationBarItem(
                                icon: Container(
                                  margin: EdgeInsets.only(left: 50*fem,right: 10),
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: GlobalVariables.textColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                label: '',
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  margin: EdgeInsets.only(left: 1*fem,right: 10),
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Save user",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                label: '',
                              ),

                            ],
                          ),
                        ),
                      ) : Column(),

                      Column(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget ratingFilter(String label){
    return InkWell(
      onTap: (){
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
            color: selectedType == label ? GlobalVariables.textColor : GlobalVariables.whiteColor,
            border: Border.all(color: GlobalVariables.textColor),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(label,style: SafeGoogleFont('Poppins',fontSize: 12,color: GlobalVariables.primaryColor,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
