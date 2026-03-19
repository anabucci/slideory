
import 'package:fashion/onboarding.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdksoyldefecnizqotwp.supabase.co',    
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',               
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Intro(),
  ));
}
class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late AnimationController _animController;
bool startedOverview = false;
List pages = ['Explore', 'Play', 'Create'];
  @override
  void initState() {
    super.initState();
 //  genDeviceID();
  }
// void genDeviceID() async {
// final  prefs = await SharedPreferences.getInstance();
// final uuuid = prefs.getString('device_id');
// if (uuuid == null){
// final uuid = Uuid();
// String id = uuid.v4();
// prefs.setString('device_id', id);

// }

// }
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
      backgroundColor: Colors.white,
      body:
     
                Stack(
                key: ValueKey(1),
                  children: [
                    
                    Container(
                      decoration: BoxDecoration(
                        
                         image: DecorationImage(
                                  opacity: 1,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                              image: AssetImage('assets/Untitled design (16).png')),
                                              
                    //     gradient: LinearGradient(
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                    // //            colors: [
                       
                    // //              Color(0xFFFFE2F0),
                    // //               Color.fromARGB(255, 255, 248, 219),
                    // // ]
                    //  colors: [
                      
                    //     Color.fromARGB(255, 188, 172, 253).withAlpha(100),
                       
                    //                                              const Color.fromARGB(255, 240, 145, 212).withAlpha(100)
                         
                    // ]
                    // )
                      ),
                               
                            child:  Padding(
                           padding: const EdgeInsets.only(top: 30),
                              child: Container(
                               
                                          //         padding:
                                          // const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                                decoration: BoxDecoration(
                                    
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [Colors.white.withAlpha(0), const Color.fromARGB(255, 248, 248, 248)],
                      //   stops: [0.4,0.9]),
                    
                                
                                         
                                        
                                
                                        
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                       MediaQuery.of(context).size.height > 1000 ?
                                        Column(
                                          children: [
                                       Text(
                                                'Create & Play',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        shadows: [BoxShadow(color: Color.fromARGB(255, 186, 186, 186), blurRadius: 20)],
                                        fontSize: MediaQuery.of(context).size.height*0.03,
                                        wordSpacing: 3,
                                        color:   const Color.fromARGB(255, 255, 129, 188),
                                    
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    
                                     Text(
                                                'INTERACTIVE \nSLIDESHOW',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: MediaQuery.of(context).size.height*0.05,
                                        wordSpacing: 3,
                                           shadows: [BoxShadow(color: Color.fromARGB(255, 255, 176, 219), blurRadius: 30)],
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        
                                  
                                    
                                      ),
                                    ),
                                       SizedBox(height: 2,),
                                     Text(
                                                'Games',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                                shadows: [BoxShadow(color: Color.fromARGB(255, 186, 186, 186), blurRadius: 20)],
                                                                                        fontSize: MediaQuery.of(context).size.height*0.03,
                                        fontFamily: 'Poppins',
                                  
                                        wordSpacing: 3,
                                        color:               const Color.fromARGB(255, 192, 159, 252),
                                    
                                      ),
                                    ),
                                          ]):   Column(
                                          children: [
                                       const Text(
                                                'Create & Play',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 28,
                                        wordSpacing: 3,
                                        color:Color.fromARGB(255, 0, 0, 0),
                                    
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    
                                     Text(
                                                'INTERACTIVE \nSLIDESHOW',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 35,
                                        wordSpacing: 3,
                                         foreground: Paint()
                                        ..shader = LinearGradient(
                                          colors: [
                                            const Color.fromARGB(255, 255, 129, 188),
                                            
                                            const Color.fromARGB(255, 192, 159, 252),
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                  
                                    
                                      ),
                                    ),
                                       SizedBox(height: 2,),
                                     Text(
                                                'Games',
                                                textAlign: TextAlign.center,
                                                 style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 28,
                                        wordSpacing: 3,
                                        color:Color.fromARGB(255, 0, 0, 0),
                                    
                                      ),
                                    ),
                                          ]),
                                    //             SizedBox(height: 5,),
                                    //                Text(
                                    //             'SLIDEORY',
                                    //             textAlign: TextAlign.center,
                                    //              style: TextStyle(
                                             
                                    //     fontFamily: 'Playfair',
                                    //     fontSize: 55,
                                    //     fontWeight: FontWeight.bold,
                                    //    foreground: Paint()
                                    //       ..shader = LinearGradient(
                                    //         colors: [
                                    //           const Color.fromARGB(255, 255, 129, 188),
                                    //           const Color.fromARGB(255, 192, 159, 252),
                                    //         ],
                                    //       ).createShader(
                                    //         Rect.fromLTWH(0, 0, 200, 70),
                                    //       ),
                                    
                                    //   ),
                                    // ),
                                        SizedBox(height: 30,),
                                                  GestureDetector(
                                                             onTap: () {
                                                          Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => Onboarding(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
    
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  ),
);
                                    
                                                             },
                                                            
                                                             child: Container(
                                                               decoration: BoxDecoration(
                                        color:    Color.fromARGB(255, 255, 255, 255),
                                   //   border: Border.all(color: Color.fromARGB(255, 190, 156, 250), width: 2 ),
                                   boxShadow: [BoxShadow(color: Color.fromARGB(255, 190, 156, 250), blurRadius: 10)],
                                      borderRadius: BorderRadius.circular(30),
                                      
                                                               ),
                                                               height:  MediaQuery.of(context).size.height > 1000 ? 65 :50,
                                                               width: MediaQuery.of(context).size.width*0.7,
                                                               child:  Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          
                                          Text(
                                            'GET STARTED',
                                            style: TextStyle(
                                              color:     Color.fromARGB(255, 0, 0, 0),
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.height > 1000 ? 24 : 16,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Icon(Icons.arrow_forward, color:   Color.fromARGB(255, 250, 156, 241), size: 20,)
                                        ],
                                      ),
                                                               ),
                                                             ),
                                                         ),
                                                           SizedBox(height: 30,)
                                    ],
                                         ),
                                  ),
                                ),
                                   ),
                            ),
                              ),
                  ],
                ) 
    );
  }

    }