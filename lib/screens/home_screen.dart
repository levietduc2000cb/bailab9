import 'package:bailab9/screens/post_screen.dart';
import 'package:bailab9/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../apis/http_service.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import '../utils/local_storage.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<User?> _futureUser;
  User? _user;
  late String token;
  late TabController _tabController;
  String _appBarTitle = 'Home Page';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setAppBarTitle);

    // Fix LateInitializationError: _futureUser has not been initialized.
    _futureUser = Future.value(null); // Initialize with a default value
    var futureToken = LocalStorage.getValue(Constants.token);
    futureToken.then((newToken) {
      token = newToken;
      _fetchUser();
    });
  }

  void _setAppBarTitle() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _appBarTitle = 'Home Page';
          break;
        case 1:
          _appBarTitle = 'Profile Page';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: FutureBuilder(
            future: _futureUser,
            builder: (context, snapshot) {
              return _user != null
                  ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.amber,
                  title: Text(_appBarTitle),
                  actions: [
                    IconButton(
                        onPressed: () => logout(),
                        icon: const Icon(Icons.logout))
                  ],
                ),
                bottomNavigationBar: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    PostScreen(user: _user!),
                    ProfileScreen(user: _user!),
                  ],
                ),
              )
                  : const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  void _fetchUser() {
    _futureUser = HttpService.getCurrentAuthUser(token);
    _futureUser.then((newUser) {
      setState(() {
        _user = newUser;
      });
    });
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
  }
}