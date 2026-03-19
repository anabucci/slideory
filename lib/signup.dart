import 'package:fashion/main.dart';
import 'package:fashion/privacy.dart';
import 'package:fashion/terms.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fashion/login.dart';
import 'package:fashion/welcome.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUp(),
  ));
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
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
  String? errorText;
  void signUp() async {
    setState(() {
      isLoading=true;
    });
    if (nameController.text.trim().length<=3)
    {
      errorText = 'Username too short. Must be more than 3 characters';
      setState(() {
  
});
return;
    } 
   else if (nameController.text.trim().length>15){
      errorText = 'Username too long. Must be less than 15 characters.';
      setState(() {
  
});
return;
    } 
   else if (RegExp(r'\s').hasMatch(nameController.text.trim())){
      errorText = 'Username cannot have empty spaces';
      setState(() {
  
});
return;
    }
  else  if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nameController.text.trim())){
      errorText = 'Username contains invalid characters';
      setState(() {
  
});
return;
    } else if (!RegExp(r'[a-zA-Z]').hasMatch(nameController.text) ) {
errorText='Username must contain letters';
setState(() {
  
});
return;
    }

    
    
     final addUser =  await Supabase.instance.client.from('profile').select().eq('username', nameController.text.trim());
     if (addUser.isNotEmpty){
      setState(() {
        errorText = 'Username already in use.';
      });
return;
     }        
try{
   await Supabase.instance.client.auth.signOut();
await Supabase.instance.client.auth.signUp(
  password: passController.text, 
  email: emailController.text,
  );
await Supabase.instance.client.from('profile').insert({'username':nameController.text.trim(), 'theme':9});
HapticFeedback.mediumImpact();
        Navigator.of(context).push(
          
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => 
   MyApp(selectedIndex: 0,),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  ),
);
 final prefs =await SharedPreferences.getInstance();
                    prefs.setBool('Guest', false);
                    
} catch (e){
   setState(() {
   final reg = RegExp(r'message: (.*?) statusCode:');
   String capitalizeFirst(String text){

return '${text[0].toUpperCase()}${text.split('').toList().skip(1).join('')}';
   }
    errorText = capitalizeFirst(reg.firstMatch(e.toString())?.group(1).toString().replaceAll(',', '.')?? 'Error. Try again.' );
  });

}
setState(() {
  isLoading=false;
});
  }
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
   


    return Scaffold(
      body: 
         
          SizedBox(
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
             Color.fromARGB(255, 255, 117, 163)
                  ],
                  begin: Alignment.topLeft,
            end: Alignment.bottomRight
                ),
              ),
                       
            
                 
                    child:  Container(
                     
                      padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                      decoration: BoxDecoration(
                       
            borderRadius: BorderRadius.circular(25),
                      
            
                      ),
                      child: Stack(
            children: [
                       
              SingleChildScrollView(
          scrollDirection: Axis.vertical,
                child: SizedBox(
                  
                  height: MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).size.height-35: 550,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                           
                     Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color:        
                  Color.fromARGB(255, 246, 95, 145),
                      ),
                    ),
                  if (errorText != null)
                  Column(
                    children: [
                       const SizedBox(height: 13),
                        Text(
                     errorText!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:        
                              const Color.fromARGB(255, 253, 94, 82),
                      ),
                    ),
                    ],
                  ),
                      const SizedBox(height: 13),
                     
                  
                      const SizedBox(height: 25),
                            
                      _buildTextField(
                          controller: nameController,
                          hint: 'Username',
                          icon: Icons.person,),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: emailController,
                        hint: 'Email',
                        icon: Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: passController,
                        hint: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                                   SizedBox(height: 20,),
                     Text.rich(
                      TextSpan(text:"By clicking the Sign Up button, I confirm to be at least 13 years of age and accept the",
                       style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: Colors.grey.shade800,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap =(() async {
                final Uri url =  Uri.parse('https://anabucci.github.io/slideorypolicy/terms-of-service');
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication,)){
                                Toast.show(context, 'Error loading terms of service', true);
                              }
                                }),
                                text:" Terms of Service",
                                style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:   Color.fromARGB(255, 246, 95, 145),
                              ),
                              ),
                              TextSpan(text:" and",
                       style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: Colors.grey.shade800,
                            ),),
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap =(() async{
                final Uri url =  Uri.parse('https://anabucci.github.io/slideorypolicy/privacy-policy');
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication,)){
                                Toast.show(context, 'Error loading terms of service', true);
                              }
                                }),
                                text:" Privacy Policy",
                                style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:   Color.fromARGB(255, 246, 95, 145),
                              ),
                              )
                                  
                            ]
                       ), 
                     ),
                        
                        
                      const SizedBox(height: 30),
                            
                     
                     GestureDetector(
                        onTap: () async{
                         signUp();
                        },
                       
                        child:Container(
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
                            colors: [
                                    Color.fromARGB(255, 190, 156, 250),
                          Color.fromARGB(255, 224, 205, 255)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          
                        ),
                        height: 50,
                        width: double.infinity,
                        child:  Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10,),
                           
                            isLoading ? SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color:   Color.fromARGB(255, 244, 237, 255), strokeWidth: 2,)) : 
                              Icon(Icons.arrow_forward, color: Colors.white, size: 20,)
                            ],
                          ),
                        ),
                      ),
                      ),
                      const SizedBox(height: 20),
                            
                            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(width: 5,),
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
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:   Color.fromARGB(255, 246, 95, 145),
                            ),
                          ),
                        ),
                      ],
                    )
                    ],
                  ),
                ),
              ),
               Positioned(
top: 20,
                child: GestureDetector(
                  onTap: (){
                    if (Navigator.canPop(context)){
                      Navigator.pop(context);
                    } else {
                     Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, nimation, secondaryAnimation) => 
                Welcome(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:   const Color.fromARGB(255, 255, 208, 224).withAlpha(100),
                      shape: BoxShape.circle
                    ),
                    child: Center(child: Icon(Icons.arrow_back_ios_new,),),
                  ),
                ),
              ),
            ],
                      ),
                    ),
                      ),
          ),
    );
  }
Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:   Color.fromARGB(255, 244, 237, 255),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withAlpha(127),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Theme(
           data: Theme.of(context).copyWith(
    textSelectionTheme: TextSelectionThemeData( 
      selectionColor: Color.fromARGB(255, 244, 237, 255),
      selectionHandleColor:  Color.fromARGB(255, 244, 237, 255),
      cursorColor: const Color.fromARGB(255, 0, 0, 0),
    ),),
          child: TextField(
            cursorColor: Colors.black,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color:        Color.fromARGB(255, 190, 156, 250)
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                color:       Color.fromARGB(255, 190, 156, 250),
                fontSize: 16
                
              ),
              prefixIcon: Icon(
                icon,
                size: 22,
                color:       Color.fromARGB(255, 190, 156, 250)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
