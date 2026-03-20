
import 'package:fashion/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdksoyldefecnizqotwp.supabase.co',    
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',               
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Onboarding(),
  ));
}
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late AnimationController _animController;
bool startedOverview = false;
List pages = ['EXPLORE', 'PLAY', 'CREATE'];

List descriptions = ['There are many stories to choose from! ', 'Play by tapping options and swiping!', 
 'Using our story studio, you can create and preview interactive stories!'];
int currentPage = 0;
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   


    return Scaffold(
      body:
       Stack(
         children: [
        
           Container(
                      
                      decoration: BoxDecoration(
                       
                        gradient: LinearGradient(
           
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white,Colors.white,Color(0xFFFFCEED)])
                      ),
                      child: SafeArea(
                        child: Padding(
                                             padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                             
                            children: [
                              GestureDetector(
                                onTap: () async {
                                    final pref =  await SharedPreferences.getInstance();
                                                                pref.setBool('onboarded', true);
                                                                Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                                                      );   
                                                            
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Skip', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 173, 142, 227)
                                                                    //     const Color.fromARGB(255, 195, 166, 246)
                                                                         ,
                                                                                                            fontSize: 17),),
                                                                                                        SizedBox(width: 2,),
                                      Icon(Icons.keyboard_arrow_right, color: const Color.fromARGB(255, 173, 142, 227), size: 30,)
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:      
                          pages.map((e)=>
                          Padding(
                            padding: const EdgeInsets.only(left: 8, ),
                            child: Container(
                              width: 60,
                              height: 7,
                              decoration: BoxDecoration(
                            color: pages.indexOf(e) <= currentPage ?    const Color.fromRGBO(255, 168, 209, 1)
                            : const Color.fromARGB(255, 255, 226, 240),
                              borderRadius: BorderRadius.circular(10)
                              )
                              ,
                            ),
                          )
                          ).toList(),
                         ) ,
                           SizedBox(height: 20,),
                         Text(pages[currentPage], style: TextStyle(fontFamily: 'Poppins',
                            foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        const Color.fromARGB(255, 255, 129, 188),
                                        const Color.fromARGB(255, 192, 159, 252),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, 200, 70),
                                    ),
                           fontWeight: FontWeight.bold, fontSize: 35),),
                         SizedBox(height: 50,),

                                            
                          Spacer(),
                         
                          Text(descriptions[currentPage], textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Poppins' , color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20),),
                                        SizedBox(height: 20,),
                            GestureDetector(
                                         
                                                               onTap: () async {
                                                        
                                         if ((currentPage+1) < pages.length){
                                                                currentPage+=1;
                                                              } else {
                                                                final pref =  await SharedPreferences.getInstance();
                                                                pref.setBool('onboarded', true);
                                                                Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                                                      );   
                                                              }  setState(() {
                                                            });
                                                               },
                                                              
                                                               child: Container(
                                                                
                                                                 decoration: BoxDecoration(
                                       color:    Color.fromARGB(255, 244, 225, 255),
                                        border: Border.all(color: Color.fromARGB(255, 190, 156, 250), width: 2 ),
                                        borderRadius: BorderRadius.circular(30),
                                        
                                                                 ),
                                                                 height: 55,
                                                                 
                                                                 width: MediaQuery.of(context).size.width*0.7,
                                                                 child: const Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            
                                            Text(
                                              'Continue',
                                              style: TextStyle(
                                                color:     Color.fromARGB(255, 190, 156, 250),
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                             SizedBox(width: 10,),
                                                Icon(Icons.arrow_forward, color:   Color.fromARGB(255, 190, 156, 250), size: 20,)
                                          ],
                                        ),
                                                                 ),
                                                               ),
                                                           ),
                                                             
                            ],
                          
                          ),
                        ),
                      ),
                    ),
                    Positioned(
          right: 0,
          left: 0, bottom: 0, top: 0,
          child: 
            IgnorePointer(
              child: Center(
                            child: Transform.scale(
                              scale:  MediaQuery.of(context).size.width > 700  ? (MediaQuery.of(context).size.height/800) : (MediaQuery.of(context).size.height/720), 
                              child: Container(
                                
                              
                                height: MediaQuery.of(context).size.height > 1000 ? MediaQuery.of(context).size.height*0.7: MediaQuery.of(context).size.height*0.4,
                                decoration: BoxDecoration(
                                  
                                   image: DecorationImage(
                                       alignment: Alignment.center,
                                                  
              
                                                            image: AssetImage('assets/${
                                                         MediaQuery.of(context).size.width > 700   ?    '${pages[currentPage].toLowerCase()}ipad':  
                                                               currentPage == 1 ? 'playstories' : pages[currentPage].toLowerCase()}.png')),
                                ),),
                            ),
                          ),
            )),
         ],
       )
    );
  }

    }