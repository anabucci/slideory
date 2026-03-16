
import 'package:fashion/welcome.dart';
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
    home: PrivacyPolicy(),
  ));
}


class PrivacyPolicy extends StatefulWidget {
 
  const PrivacyPolicy({super.key,});


  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
 final section = {
  "Information We Collect":
    "We collect the following information when you use the app: "
    "Email address used to create and manage your account, "
    "username used to identify your account within the app, "
    "photos or images that you upload or share through the app, "
    "and activity data generated while using the app such as likes, story completion history, comments, and other interactions within the app. "
    "We do not collect other personal information such as your real name, phone number, or location.",

  "How We Collect Information":
    "Information is collected when you create an account, upload content, interact with stories, post comments, or otherwise use features of the app. "
    "Activity data such as likes, story completion, and interactions is automatically recorded as part of normal app functionality.",

  "How We Use Your Information":
    "We use the information we collect to create and manage your account, "
    "display your username and uploaded photos within the app, "
    "record interactions such as likes, comments, and story progress, "
    "send notifications related to app activity, "
    "maintain the functionality and security of the platform, "
    "and improve the app experience.",

  "Data Retention and Deletion":
    "We retain your data only for as long as your account remains active. "
    "You may delete your account at any time through the app's Settings page. "
    "When an account is deleted, the associated user data including account information, uploaded photos, comments, and activity data is permanently removed from our systems.",

  "Data Storage and Security":
    "Your account information, uploaded photos, and activity data are stored securely using Supabase, "
    "our backend service provider. We use reasonable security measures to protect "
    "your data from unauthorized access, loss, or misuse.",

  "Third-Party Services":
    "We use Supabase to store and manage user account information and uploaded content. "
    "These services only process data as necessary to provide app functionality.",

  "Children and Age Restriction":
    "This app is intended for users who are at least 13 years old. "
    "We do not knowingly allow individuals under the age of 13 to create accounts or use the app.",

  "Account and Data Requests":
    "Users may revoke consent for data storage by deleting their account through the app's Settings page, "
    "which permanently removes their associated data. "
    "If you have questions about your account or the data associated with it, "
    "you may contact us using the email listed below.",

  "Changes to This Policy":
    "We may update this Privacy Policy from time to time. "
    "If changes are made, the updated version will be posted in the app with a revised effective date.",

  "Contact Us":
    "If you have any questions about this Privacy Policy, contact us at: slideory@gmail.com"
};
   @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          bottom: false,
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
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                     
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                       
                                        SizedBox(height: 20,),
                       GestureDetector(
                            onTap: (){
                              if (Navigator.canPop(context)){
                                Navigator.pop(context);
                               
                              } else {
           Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                              }
                            },
                            child:
                            
                             Align(
                                alignment: Alignment.topLeft,
                               child: Row(
                                 children: [
                                   Container(
                                    
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 221, 201, 255) ,
                                          shape: BoxShape.circle
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(child: Icon(Icons.arrow_back, size: 26, fontWeight: FontWeight.bold, 
                                          color: const Color.fromARGB(255, 255, 255, 255), )),
                                        ),
                                      ),
                                      Spacer(),
                                 ],
                               ),
                             ),),
                        SizedBox(height: 30,),
                       
                       Text('Privacy Policy', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0)
                                                     //     const Color.fromARGB(255, 195, 166, 246)
                                                          , fontWeight: FontWeight.bold,
                                                                                             fontSize: 35),),
                                                                                              SizedBox(height: 20,),
                                                                                               Text('Effective Date: April 15th, 2026.\n\nSlideory (“we”, “our”, or “us”) respects your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our app.'
                                                                                               , style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 20),),
                                                                                              SizedBox(height: 50,),
                                                ...section.keys.map((e) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 20),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                             children: [
                                                                                              Text(e, style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                                                                                              SizedBox(height: 20,),
                                                                                               Text(section[e].toString(), style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 20),),
                                                                                             ], 
                                                          
                                                    ),
                                                  );})
                                        ]),
                    )])))
    ))));
  }
  
}