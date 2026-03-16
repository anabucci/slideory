
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExplorePage(),
  ));
}
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  Color lightPurple =  Color.fromARGB(255, 145, 87, 232);
Color darkPurple = Color(0xFF8743F0);

  @override
  Widget build (BuildContext context){
  
 
  return Scaffold(
  
// backgroundColor: const Color.fromARGB(255, 248, 248, 248)
backgroundColor: Colors.transparent
,
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
          Color.fromARGB(255, 248, 248, 248),Color.fromARGB(255, 248, 248, 248),
   const Color.fromARGB(255, 255, 234, 241)])
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: 
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               SizedBox(height: 10,),
                Text('Explore', style: TextStyle( color: const Color.fromARGB(255, 213, 186, 225), fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Poppins'),),
                SizedBox(height: 5,),
                Text('Discover new stories', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 158, 158, 158)),)
               ],)
      ),
    ));
        }
        
}