import 'package:flutter/material.dart';
import 'package:fashion/main.dart';
import 'package:fashion/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Supabase.initialize(
    url: 'https://dzajkwfgeizqrlenutuu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6YWprd2ZnZWl6cXJsZW51dHV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3NTQzMDMsImV4cCI6MjA3NDMzMDMwM30.as3LxsUK5a2D2V9oz8F1-inqtz5rkMAMzsbjKJpmZl4',
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LogIn(),
  ));
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn>
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
  bool isLoading = false;
   void logIn() async {
    isLoading=true;
    setState(() {
      
    });
      try{
                   await Supabase.instance.client.auth.signOut();
                    await Supabase.instance.client.auth.signInWithPassword(password: passController.text, email: emailController.text);
                               
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

  @override

  Widget build(BuildContext context) {
  

    return Scaffold(
      body: 
         
          Container(
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
                    color:     const Color.fromARGB(255, 254, 189, 211).withAlpha(100),
                    shape: BoxShape.circle
                  ),
                  child: Center(child: Icon(Icons.arrow_back_ios_new,),),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
                Text(
                  'Log In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 34,
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
              
                const SizedBox(height: 35),
                      
              
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
                const SizedBox(height: 30),
                      
               
               GestureDetector(
                  onTap: ()  {
            logIn();
                 
                  },
                 
                  child: Container(
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
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          Text(
                            'Log In',
                            style: TextStyle(
                              color:   Color.fromARGB(255, 244, 237, 255),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10,),
                       isLoading ? SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color:   Color.fromARGB(255, 244, 237, 255), strokeWidth: 2,)) :  Icon(Icons.arrow_forward, color: Colors.white, size: 20,)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
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
                SignUp(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
                      },
                      child: const Text(
                        "Sign Up",
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
          ],
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
