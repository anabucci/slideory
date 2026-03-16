
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
    home: TermsofServices(),
  ));
}


class TermsofServices extends StatefulWidget {
 
  const TermsofServices({super.key,});


  @override
  State<TermsofServices> createState() => _TermsofServicesState();
}

class _TermsofServicesState extends State<TermsofServices> {
    final section = {'Eligibility':"You must be at least 13 years old to use the Service. By using the Service, you represent and warrant that you meet this requirement.",
    'User Accounts':"To access certain features, you may need to create an account. You agree to: Provide accurate information, Maintain the security of your account, and Be responsible for all activity under your account. We reserve the right to suspend or terminate accounts that violate these Terms.",
 'User Content':r'Our Service allows users to create and share content including: Stories, Photos, Comments and Other media (“User Content”). You retain ownership of the content you create. However, by posting content on the Service, you grant Slideory a worldwide, non-exclusive, royalty-free license to: host, store, display, reproduce, distribute and promote your user content for the purpose of operating and improving the Service.',
'Content Responsibility': "You are solely responsible for the content you post. You agree not to post content that: \n •    Is illegal or promotes illegal activity\n •    Harasses, threatens, or abuses others\n •    Contains hate speech\n •    Is sexually explicit or exploitative\n •    Violates intellectual property rights\n •    Contains spam or malicious software\n •    Violates the privacy of others. \nWe reserve the right to remove or restrict content at our discretion.",
'Content Moderation':"To maintain a safe community, we may: Review content, Remove content, Restrict accounts, or Suspend or terminate users However, we do not guarantee that all content will be monitored.",
'Reporting Violations':"Users may report content that violates these Terms. If you believe content violates these Terms or your rights, please contact: slideory@gmail.com",
'Intellectual Property':'All content and materials provided by Slideory, including: software, branding, design and logos are owned by Slideory and protected by intellectual property laws. You may not: Copy, modify, distribute, or reverse engineer any part of the service without our permission',
'Copyright Policy (DMCA)':'If you believe that content on the Service infringes your copyright, you may submit a takedown request including: identification of the copyrighted work , identification of the infringing material, your contact information , and a statement of good faith belief. Requests should be sent to: slideory@gmail.com',
'Termination':"We may suspend or terminate your access to the Service if you: violate these terms, post harmful or illegal content, abuse the platform. You may stop using the Service at any time.",
"Disclaimer of Warranties":"The Service is provided “as is” and “as available.” We do not guarantee that: the service will always be available the service will be error-free and that user content will be accurate or reliable",
'Limitation of Liability':'To the maximum extent permitted by law, Slideory shall not be liable for any indirect, incidental, or consequential damages arising from your use of the Service.',
'Changes to These Terms':'We may update these Terms from time to time. When we do, we will update the Effective Date. Continued use of the service after changes means you accept the updated terms.',
'Contact Information':'If you have any questions about the terms, contact us at slideory@gmail.com'









   };
   @override

  // final sections = {
  //   'Eligibility':'', 'User Accounts', 'User Content',
  // 'Content Responsibility', 'Content Moderation',
  //  'Reporting Violations',
  // 'Intellectual Property', 'Copyright Policy (DMCA)', 
  // 'Termination', 'Disclaimer of Warranties',
  // 'Limitation of Liability', 'Changes to These Terms', 
  // 'Contact Information' };
  
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                       Text('Terms of Service', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                     //     const Color.fromARGB(255, 195, 166, 246)
                                                          fontWeight: FontWeight.bold,
                                                                                             fontSize: 35),),
                                                                                              SizedBox(height: 20,),
                                                                                             Text('Effective Date: April 15th, 2026.\n\nWelcome to Slideory (“we,” “our,” or “us”). These Terms of Service (“Terms”) govern your access to and use of the Slideory mobile application and related services (the “Service”). By accessing or using the Service, you agree to be bound by these Terms.'
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
                                                );
                                              })
                                        ]),
                    )])))
    ))));
  }
  
}