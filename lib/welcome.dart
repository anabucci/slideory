import 'package:fashion/main.dart';
import 'package:flutter/material.dart';
import 'package:fashion/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdksoyldefecnizqotwp.supabase.co',    
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',               
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Welcome(),
  ));
}
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late AnimationController _animController;

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
         
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
//            colors: [
             
//              Color(0xFFFFE2F0),
//               Color.fromARGB(255, 255, 248, 219),
// ]
          colors: [
            
              Color.fromARGB(255, 188, 172, 253).withAlpha(50),
             
                                                       const Color.fromARGB(255, 240, 145, 212).withAlpha(50)
               

                // Color.fromARGB(255, 255, 140, 227),
]
)
            ),
                     
                  child:  Container(
                   
            //         padding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                    decoration: BoxDecoration(
                     
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withAlpha(0), const Color.fromARGB(255, 248, 248, 248)],
            stops: [0.2,1.0])
                    
          
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                           const Text(
                                    'Interactive Slideshows',
                                    textAlign: TextAlign.center,
                                     style: TextStyle(
                                 
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            wordSpacing: 3,
                            color:Color.fromARGB(255, 0, 0, 0),
                        
                          ),
                        ),
                                    SizedBox(height: 5,),
                                       Text(
                                    'SLIDEORY',
                                    textAlign: TextAlign.center,
                                     style: TextStyle(
                                 
                            fontFamily: 'Poppins',
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
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
                                    SizedBox(height: 50,),
                           
                            GestureDetector(
                                                   onTap: () {
                                                  
                           Navigator.of(context).push(
                                                    PageRouteBuilder(
                           pageBuilder: (context, animation, secondaryAnimation) => 
                           SignUp(),
                           transitionDuration: Duration.zero,
                           reverseTransitionDuration: Duration.zero,
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
                                                     height: 50,
                                                     width: MediaQuery.of(context).size.width*0.7,
                                                     child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                
                                Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color:     Color.fromARGB(255, 0, 0, 0),
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
                                               SizedBox(height: 25,),
                           GestureDetector(
                              onTap: () {
                                 Navigator.of(context).push(
                                                    PageRouteBuilder(
                           pageBuilder: (context, animation, secondaryAnimation) => 
                                                     LogIn(),
                           transitionDuration: Duration.zero,
                           reverseTransitionDuration: Duration.zero,
                                                    ),
                                                  );
                              },
                             
                              child: Container(
                                decoration: BoxDecoration(
                                   color:    Color.fromARGB(255, 255, 255, 255),
                         //   border: Border.all(color: Color.fromARGB(255, 190, 156, 250), width: 2 ),
                         boxShadow: [BoxShadow(color:   Color.fromARGB(255, 255, 178, 234), blurRadius: 10)],
                            borderRadius: BorderRadius.circular(30),
                            
                                  
                                ),
                                height: 50,
                                 width: MediaQuery.of(context).size.width*0.7,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      
                                      Text(
                                        'LOG IN',
                                        style: TextStyle(
                                          color:     Color.fromARGB(255, 0, 0, 0),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Icon(Icons.arrow_forward, color:      Color.fromARGB(255, 255, 178, 234), size: 20,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                                                  
                                               const SizedBox(height: 25),
                               GestureDetector(
                                                   onTap: () async {
                                                  final pref = await SharedPreferences.getInstance();
                                               pref.setBool('Guest', true);
                                               await Supabase.instance.client.auth.signOut();
                           Navigator.of(context).push(
                                                    PageRouteBuilder(
                           pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 0, guest: true,),
                           transitionDuration: Duration.zero,
                           reverseTransitionDuration: Duration.zero,
                                                    ),
                                                  );
                                                   },
                                                  
                                                   child: Container(
                                                    
                                                     decoration: BoxDecoration(
                           color:    Color.fromARGB(255, 244, 237, 255),
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
                                  'Continue as Guest',
                                  style: TextStyle(
                                    color:     Color.fromARGB(255, 190, 156, 250),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                               
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
                    ),
    );
  }

    }