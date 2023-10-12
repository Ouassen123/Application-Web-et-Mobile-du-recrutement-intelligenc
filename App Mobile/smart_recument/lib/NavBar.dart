import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_recument/screens/favorites_page.dart';
import 'package:smart_recument/screens/home_screen.dart';
import 'package:smart_recument/favorites_provider.dart';

class NavBar extends StatefulWidget {
  final String username;
  final String email;
  final List<JobListing> favoriteJobListings;

  NavBar(
      {required this.username,
      required this.email,
      required this.favoriteJobListings});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String avatarImagePath = 'assets/user_image.png';

  Future<void> _changeProfileImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        avatarImagePath = image.path;
      });
    }
  }

  void _logOut() {
    logoutUser();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.username),
            accountEmail: Text(widget.email),
            currentAccountPicture: GestureDetector(
              onTap: _changeProfileImage,
              child: CircleAvatar(
                backgroundImage: AssetImage(avatarImagePath),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF89BA16),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favoriteJobListings:
                        widget.favoriteJobListings, // Use the list here
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Friends'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () {
              Navigator.pushNamed(context, '/policies');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Post Job'),
            onTap: () {
              Navigator.pushNamed(context, '/postjob');
            },
          ),
          ListTile(
            leading:
                Icon(Icons.mail), // Ajout de l'icône pour le bouton Contact
            title: Text('Contact'),
            onTap: () {
              Navigator.pushNamed(context, '/contact'); // Route "contact"
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }
}

void logoutUser() {
  // Implement your actual log out logic here
  // For example, clearing session data, resetting authentication, etc.
}
