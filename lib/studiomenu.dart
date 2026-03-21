import 'package:fashion/advancededitor.dart';
import 'package:fashion/basiceditor.dart';
import 'package:fashion/draft.dart';
import 'package:fashion/login.dart';

import 'package:fashion/signup.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StudioMenu(),
  ));
}


class StudioMenu extends StatefulWidget {
 
  const StudioMenu({super.key, });


  @override
  State<StudioMenu> createState() => _StudioMenuState();
}
  bool isBasic  = true;
   final supabase = Supabase.instance.client;
class _StudioMenuState extends State<StudioMenu> {
   @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          
          Container(
            
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
          
              colors: [
                
                  Color.fromARGB(255, 188, 172, 253).withAlpha(50),
                 
                                                           const Color.fromARGB(255, 240, 145, 212).withAlpha(50)
                   
          ]
          )
          ),
            child: Container(
                      decoration: BoxDecoration(
            
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withAlpha(0), const Color.fromARGB(255, 248, 248, 248)],
                stops: [0.0,0.6])
            ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child:
                              supabase.auth.currentUser == null ?  
                      Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                      
                  
                      
                            Text('Story Studio', style: TextStyle(fontFamily: 'Poppins', color:  const Color.fromARGB(255, 255, 127, 170)
                                                          //     const Color.fromARGB(255, 195, 166, 246)
                                                               , fontWeight: FontWeight.bold,
                                                                                                  fontSize: 35),),
                                                                                                  SizedBox(height: 20,),
                                                                                                      Padding(
                                                                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                 child: Text('Easily create interactive stories and share them with the world. Create an account to unlock this feature!', 
                                                                 textAlign: TextAlign.center,
                                                                 style: TextStyle(fontFamily: 'Poppins', color: Colors.black
                                                                                                           //     const Color.fromARGB(255, 195, 166, 246)
                                                                ,
                                                                                                    fontSize: 18),),
                                                               ),
                                                                                                  SizedBox(height: 40,),
                                                                                                  GestureDetector(
                                                                                                    onTap: (){
                                       Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => SignUp(
                                          
                                          
                                                ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                                                  );
                                                                                                    },
                                                                                                    child: Container(
                                                                                                                          width: 250,
                                                                                                                        decoration: BoxDecoration(
                                                                                                                                   
                                                                                                                          color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                                                                          border: Border.all(color:Color.fromARGB(255, 203, 179, 244), width: 2, ), 
                                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                                        ), child: Padding(
                                                                                                                          padding: const EdgeInsets.all(10),
                                                                                                                          child: Center(
                                                                                                                            child:Text('Sign Up', 
                                                                                                                                 style: TextStyle( color:const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold, 
                                                                                                                                 fontFamily: "Poppins", fontSize: 19
                                                                                                                                 ),
                                                                                                                          ),)
                                                                                                                        ),
                                                                                                                        ),
                                                                                                  ),
                              SizedBox(height: 20,),
                                GestureDetector(
                                    onTap: (){
                                       Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => LogIn(
                                          
                                          
                                                ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                                                  );
                                                                                                    },
                                  child: Container(
                                  width: 250,
                                                      decoration: BoxDecoration(
                                           
                                  color: const Color.fromARGB(255, 225, 208, 255).withAlpha(100),
                                  border: Border.all(color:Color.fromARGB(255, 203, 179, 244), width: 2, ), 
                                  borderRadius: BorderRadius.circular(25),
                                                      ), child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child:Text('Log In', 
                                         style: TextStyle( color:const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold, 
                                         fontFamily: "Poppins", fontSize: 19
                                         ),
                                  ),)
                                                      ),
                                                      ),
                                ),
                                                                                                  ]
                      )
                      
                              :
                     Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                  
                      
                      Text('Story Studio', style: TextStyle(fontFamily: 'Poppins', color:  const Color.fromARGB(255, 255, 127, 170)
                                                    //     const Color.fromARGB(255, 195, 166, 246)
                                                         , fontWeight: FontWeight.bold,
                                                                                            fontSize: 35),),
                                                                                            SizedBox(height: 20,),
                                                         Padding(
                                                           padding: const EdgeInsets.symmetric(horizontal: 20),
                                                           child: Text('Easily create interactive stories and share them with the world.', 
                                                           textAlign: TextAlign.center,
                                                           style: TextStyle(fontFamily: 'Poppins', color: Colors.black
                                                                                                     //     const Color.fromARGB(255, 195, 166, 246)
                                                           , fontWeight: FontWeight.bold,
                                                                                              fontSize: 18),),
                                                         ),
                                                                                            SizedBox(height: 40,),
                                                                                            GestureDetector(
                                                                                                      onTap: (){
                                                                                                      setState(() {
                                                                                                        isBasic ?
                                                                                                            Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: Duration(milliseconds:500),
    pageBuilder: (context, animation, secondaryAnimation) => BasicEditor(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  ),
                                                                                                            ) :
                                                                                                         isBasic = true;
                                                                                                      });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        width: MediaQuery.of(context).size.width-80,
                                                                                                           decoration: isBasic ?  BoxDecoration(
                                                                                                          border: Border.all( color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                          width: 2
                                                                                                          ),
                                                                                                            borderRadius: BorderRadius.circular(12),
                                                                                                            
                                                                                                          ) : null,
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.all(3),
                                                                                                          child: Container(
                                                                                                          
                                                                                                            decoration: BoxDecoration(
                                                                                                              gradient: LinearGradient(
                                                                                                                begin: Alignment.topLeft,
                                                                                                                end: Alignment.bottomRight,
                                                                                                            
                                                                                                                colors: [const Color.fromARGB(255, 210, 184, 254).withAlpha(50), const Color.fromARGB(255, 165, 122, 241).withAlpha(110), ]
                                                                                                                
                                                                                                                ),
                                                                                                             
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                              
                                                                                                            ),
                                                                                                            child: Padding(
                                                                                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 23),
                                                                                                              child: Center(child: 
                                                                                                              Column(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  Text('Basic Editor', style: 
                                                                                                                  TextStyle(fontFamily: 'Poppins', 
                                                                                                                    color: const Color.fromARGB(255, 141, 116, 185),
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                                                                                              fontSize: 20)),
                                                                                                                  SizedBox(height: 15,),
                                                                                                                    Text('Best for stories where user options are not important.',
                                                                                                                    textAlign: TextAlign.center,
                                                                                                                     style: 
                                                                                                                  TextStyle(fontFamily: 'Poppins', 
                                                                                                                    color: const Color.fromARGB(255, 5, 5, 5), 
                                                                                                                     
                                                                                                                                                                                              fontSize: 16)),
                                                                                                                ],
                                                                                                              ),),
                                                                                                          
                                                                                                          
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                
                                                                                                    
                                                                                                    SizedBox(height: 20,),
                                                                                                     GestureDetector(
                                                                                                      onTap: (){
                                                                                                      setState(() {
                                                                                                        isBasic ? 
                                                                                                        isBasic = false :
                                                                                                        Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AdvancedEditor(),
    transitionDuration: Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  ),
);
                                                                                                         
                                                                                                      });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                                       width: MediaQuery.of(context).size.width-80,
                                                                                                           decoration: !isBasic ?  BoxDecoration(
                                                                                                          border: Border.all( color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                          width: 2
                                                                                                          ),
                                                                                                            borderRadius: BorderRadius.circular(12),
                                                                                                            
                                                                                                          ) : null,
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.all(3),
                                                                                                          child: Container(
                                                                                                          
                                                                                                            decoration: BoxDecoration(
                                                                                                               gradient: LinearGradient(
                                                                                                                begin: Alignment.topLeft,
                                                                                                                end: Alignment.bottomRight,
                                                                                                            
                                                                                                                 colors: [const Color.fromARGB(255, 195, 166, 246).withAlpha(50), const Color.fromARGB(255, 165, 122, 241).withAlpha(110), ]
                                                                                                                
                                                                                                                ),
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                              
                                                                                                            ),
                                                                                                            child: Padding(
                                                                                                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 23),
                                                                                                              child: Center(child: Column(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  Text('Advanced Editor',
                                                                                                                  
                                                                                                                   style: 
                                                                                                                  TextStyle(fontFamily: 'Poppins', 
                                                                                                                    color: const Color.fromARGB(255, 141, 116, 185),
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                                                                                              fontSize: 20)),
                                                                                                                                                                                                  SizedBox(height: 15,),
                                                                                                                    Text('Best for stories with branching options.',
                                                                                                                    textAlign: TextAlign.center,
                                                                                                                     style: 
                                                                                                                                                                                                                              TextStyle(fontFamily: 'Poppins', 
                                                                                                                    color: const Color.fromARGB(255, 5, 5, 5), 
                                                                                                                    
                                                                                                                                                                                              fontSize: 16)),
                                                                                                                                                                                            
                                                                                                                ],
                                                                                                              ),),
                                                                                                          
                                                                                                            ),
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
          ),
          if (supabase.auth.currentUser != null)
            Positioned(
                        left: 20,
                        top: 70,
                        child: GestureDetector(
                          onTap: (){
         Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Drafts(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                          },
                          child:
                          
                           Container(
                            
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 195, 166, 246) ,
                                 borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Drafts', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, 
                                      fontSize: 18
                                      ),)
                           ,                                    
                           SizedBox(width: 10,),
                             Icon(Icons.text_snippet, size: 22, 
                                      color: const Color.fromARGB(255, 255, 255, 255), ),
                                    ],
                                  )),
                                ),
                              ),),
                      
                      ),
        ],
      ),
    );
  }
  
}