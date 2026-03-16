// import 'package:flutter/material.dart';
// import 'package:newapp/closet.dart';
// import 'package:newapp/connect.dart';
// import 'package:newapp/discover.dart';
// import 'package:newapp/homepage.dart';
// import 'package:newapp/profile.dart';
// import 'package:newapp/welcome.dart';
// import 'navbar.dart';
// import 'shop.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Supabase.initialize(
//     url: 'https://hdksoyldefecnizqotwp.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
//   );

//   runApp(const RootApp());
// }

// class RootApp extends StatelessWidget {
//   const RootApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyApp(),
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   final int selectedIndex;
//   const MyApp({Key? key, this.selectedIndex = 0}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late int currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.selectedIndex;
//   }

//   final List<String> tabLabels = [
//     'Home',
//     'Explore',
//     'Closet',
//     'Shop',
//     'Profile',
//     'Connect'
//   ];

//   final user = Supabase.instance.client.auth.currentUser;
  

//   final List<Widget> pages = const [
//     HomePage(),
//     DiscoverPage(),
//     ClosetPage(),
//     ShopPage(),
//    ProfilePage(),
//     ConnectPage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     if (user == null){
//      return const Welcome();
//     }
//     return Scaffold(
//       body: Stack(
//         children: [
//           IndexedStack(
//             index: currentIndex,
//             children: pages,
//           ),
//           CustomNavBar(
//             current: tabLabels[currentIndex],
//             onTabSelected: (label) {
//               setState(() {
//                 currentIndex = tabLabels.indexOf(label);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:fashion/intro.dart';
import 'package:fashion/profile.dart';
import 'package:fashion/storiesforyou.dart';
import 'package:fashion/studiomenu.dart';
import 'package:fashion/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qbehrysrnnhvxigeocdm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFiZWhyeXNybm5odnhpZ2VvY2RtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA2MDM0NDAsImV4cCI6MjA4NjE3OTQ0MH0.00mpD4oRE1uMO8-ZbD9kR2pE45e9Dlu767zfhz7uDf4',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final int selectedIndex;
  final dynamic guest;
  const MyApp({Key? key, this.selectedIndex =0, this.guest=false}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int currentIndex;
  bool guest = false;
  bool onboarded = false;
void getPrefs() async {
 final sharedPrefs = await SharedPreferences.getInstance();
 if (sharedPrefs.getBool('Guest')??false){
guest=true;
 } 
 if (sharedPrefs.getBool('onboarded')??false) {
onboarded=true;
 }
setState(() {
  
});
 
 
}
  @override
  void initState() {
   getPrefs();
    super.initState();
    
    currentIndex = widget.selectedIndex;
  }

  final List<String> tabLabels = [
    'Home',
   'Add',
    // 'Collections',
    'Profile'
  ];

  

  final List<Widget> pages = const [

StoriesForYou(),
// ExplorePage(),
StudioMenu(),
// Collections(),
ProfilePage()

  ];


  @override
  Widget build(BuildContext context) {

 
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
       home: 
       Supabase.instance.client.auth.currentUser== null && !onboarded && !widget.guest ? Intro()
       : 
      Supabase.instance.client.auth.currentUser== null && !guest ? Welcome() :
       
      Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        body: Stack(
          children: [
             IndexedStack(
            index: currentIndex,
            children: pages,
          ),
            CustomNavBar(
              
        current: tabLabels[currentIndex],
              onTabSelected: (label) {
              setState(() {
                currentIndex = tabLabels.indexOf(label);
              });
            },
            ),
          ],
        ),
      ),
    
    );
  }
}
