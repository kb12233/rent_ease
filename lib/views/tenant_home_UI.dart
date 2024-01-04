//tenant_home
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/controllers/login_controller.dart';
import 'package:rent_ease/models/user_model.dart';
import 'package:rent_ease/views/available_properties_UI.dart';
import 'package:rent_ease/views/notifications_UI.dart';

class TenantHomeUI extends StatefulWidget {
  final UserModel user;
  const TenantHomeUI({required this.user});

  @override
  _TenantHomeUIState createState() => _TenantHomeUIState();
}

class _TenantHomeUIState extends State<TenantHomeUI> {
  Color navcolor = Color(0xFF532D29);
  int _currentIndex = 0;
  // UserModel userModel;

  // void getUser() async {
  //   user = await UserModel.getUserData(user_auth.uid);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   userModel = super.widget.user;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RentEase",
          style: TextStyle(
            color: navcolor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: _buildDrawer(),
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: navcolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
            backgroundColor: navcolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: navcolor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
                "${super.widget.user.firstname} ${super.widget.user.lastname}"),
            accountEmail: Text("${super.widget.user.email}"),
            currentAccountPicture: widget.user.profilePictureURL != 'none' ? 
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.user.profilePictureURL),
              ) : 
              CircleAvatar(
                child: Icon(Icons.person),
              )
            ,
            decoration: BoxDecoration(
              color: navcolor,
            ),
          ),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () {
              // Add your logic for editing profile here
              // For example: Navigator.pushNamed(context, '/editprofile');
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Add your logic for logging out here
              // For example: Navigator.pushNamed(context, '/logout');
              LoginControl.signOut();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return AvailablePropertiesUI();
      case 1:
        return PaymentScreen();
      case 2:
        return NotificationsUI();
      default:
        return Container(); // Placeholder, you can replace it with an appropriate widget
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //search
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: '   search here',
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {},
            child: Text("Reserve"),
          ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Payment Screen"),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Notification Screen"),
    );
  }
}
