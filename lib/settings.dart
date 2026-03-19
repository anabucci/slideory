
import 'package:fashion/main.dart';
import 'package:fashion/manageprofile.dart';

import 'package:fashion/toast.dart';
import 'package:fashion/welcome.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SettingsPage(),
  ));
}
class SettingsPage extends StatefulWidget {
  final dynamic data;
  const SettingsPage({super.key, this.data});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool loadingDel = false;
  bool showContactInfo = false;
  dynamic returnusername;
   final supabase = Supabase.instance.client;
 void delAcc(){
    showDialog(context: context, builder: (context) {
      
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 184, 179)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(child: Icon(Icons.error, color: Colors.red, size: 30,),),
                      ),
                    
                    ),
                    SizedBox(height: 10,),
                    Text('Delete Account', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),),
                    SizedBox(height: 10,),
                    Text('Are you sure you want to delete your account? This action cannot be undone.',
                  textAlign: TextAlign.center,
                     style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins', color: const Color.fromARGB(255, 107, 107, 107)),),
                    SizedBox(height: 25,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context, );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: Center(
                        child: Text('Cancel',style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), ),),
                      ),
                                    ),
                      ),
                    ),
                                     
                                     SizedBox(height:  10,),
                                    GestureDetector(
                                      onTap: () async {
                                        if (!loadingDel){
                                          setState(() {
                                              loadingDel=true;
                                          });
                                        
                                                                                final session = supabase.auth.currentSession;
                            
                                          final res = await supabase.functions
            
                                          
                                          .invoke('delete-account', 
                                            headers: {
                'Authorization': 'Bearer ${session!.accessToken}',
              },
                                          body: {'name': 'Functions'});
            
      
            if (res.status == 200){
            
            
                                          loadingDel=false;
                                            Toast.show(context, 'Account deleted sucessfully.', false);
            
                                     Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                                                );
                                     
            }
                                      
                                        }
            
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                        color: Colors.red,
                                                      borderRadius: BorderRadius.circular(10)
                                        ),
                                                                child: Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: Center(
                                        child: 
                                        loadingDel ? SizedBox(
                                          width: 23, height: 23,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) :
                                        Text('Delete',style: TextStyle(fontFamily: 'Poppins', color: Colors.white),),
                                      ),
                                                                ),
                                      ),
                                    ),
                  ],
                  
                  ),
                ),
              ),
            );
          }
        ),
      );
    });
  }
Map sections = { "Account":['Manage Account', ],
"App":["Privacy Policy", 'Terms of Service', 'Contact Us'],
"Actions":
['Logout', 'Delete Account', ]};
Map sectionIcon = {
  'Manage Account':Icons.person,
  'Security':Icons.security,
  'Contact Us':Icons.help,
  "Notifications":Icons.notifications,
  'Help Center': Icons.help,
  'Privacy Policy':Icons.privacy_tip,
  "Terms of Service":Icons.article,
  "Logout":Icons.logout,
 "Delete Account": Icons.delete
};
final id = Supabase.instance.client.auth.currentUser!.id;
@override
void initState() {
   
    super.initState();
  }
  @override
  Widget build (BuildContext context){
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
    body: SafeArea(
      child: Stack(
        children: [
           Positioned(
                    left: 20,
                    top: 20,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                      
                        children: [
                          Align(
      alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: (){
                                if (Navigator.canPop(context)){
                                  Navigator.pop(context, returnusername);
                                } else {
                                Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>MyApp(selectedIndex: 2,),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                                }
                                
                              },
                              child:Container(
                            
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 205, 205, 205).withAlpha(50),
                                  shape: BoxShape.circle
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Center(child: Icon(Icons.arrow_back, size: 23, 
                                  color: const Color.fromARGB(255, 0, 0, 0), )),
                                ),
                              ),
                            ),
                          ),
                       
                        ],
                      ),
                    )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30 ),
            child: Center(
              child: Column(
                
                children: [
              Text('Settings', style: TextStyle(fontFamily: 'Poppins', color: 
                                                                 const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                                    fontSize: 22),),
                      SizedBox(height: 50,),
                        Text('@${widget.data['username']}', style: TextStyle(fontFamily: 'Poppins', color: 
                                             const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                                                                fontSize: 22),),     
                      SizedBox(height: 20,),                  
        ...sections.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 209, 224),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  children: [
                     ...( entry.value as Iterable).toList().map((e) {
              return 
              
              GestureDetector(
                onTap: () async {
                
                      if (e == 'Manage Account'){
                    final data =  await supabase.from('profile').select('username, liked, completed').eq('user_id',id).maybeSingle();
 returnusername =   await   Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => ManagePage(completed: data?['completed'], liked: data?['liked'], username: data?['username'],),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                                                            if (returnusername != null){
                                                              widget.data['username'] = returnusername;
                                                              setState(() {
                                                                
                                                              });
                                                            }
            } else if (e=='Privacy Policy'){
           final Uri url =  Uri.parse('https://anabucci.github.io/slideorypolicy/privacy-policy');
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication,)){
                                Toast.show(context, 'Error loading terms of service', true);
                              }
            } else if (e=='Terms of Service'){
             final Uri url =  Uri.parse('https://anabucci.github.io/slideorypolicy/terms-of-service');
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication,)){
                                Toast.show(context, 'Error loading terms of service', true);
                              }
            }
            
             else if (e=='Logout'){
              supabase.auth.signOut();
                Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
            } else if (e == 'Delete Account'){
              delAcc();
            } else if (e=='Contact Us'){
              showContactInfo=!showContactInfo;
              setState(() {
                
              });
            }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: entry.value.indexOf(e) == entry.value.length-1 ? BorderSide.none : BorderSide(width: 1,  color:  const Color.fromARGB(255, 246, 95, 145),))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                                    Icon(
                                    sectionIcon[e], color:   const Color.fromARGB(255, 246, 95, 145),
                                    ),
                            SizedBox(width: 10,),
                            Text(e, style: TextStyle(fontFamily: 'Poppins', 
                            fontWeight: FontWeight.bold, color:  const Color.fromARGB(255, 246, 95, 145),
                            ),),
                            Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                        
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Center(child: Icon(
                                           e=='Contact Us' && showContactInfo ? Icons.keyboard_arrow_down :
                                       
                                          Icons.chevron_right, color: const Color.fromARGB(255, 195, 166, 246),)),
                                      ))
                          ],
                        ),
                        AnimatedSize(
                           duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
                          child:  e=='Contact Us' && showContactInfo ?SizedBox(
                              height:130,
                               child:   Column(
                                 children: [
                               
                                                                                                       SizedBox(height: 25,),
                                                          Text('Use the following email to contact us:', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                            SizedBox(height: 20,),
                                              Container(
                                               
                                                decoration: BoxDecoration(
                                                                             color:    Color.fromARGB(255, 244, 237, 255),
                                                                              border: Border.all(color: Color.fromARGB(255, 190, 156, 250), width: 2 ),
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              
                                                ),
                                                height: 45,
                                                width: double.infinity,
                                                child: const Center(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  
                                                                                  Text(
                                                                                    'slideory@gmail.com',
                                                                                    style: TextStyle(
                                                                                      color:     Color.fromARGB(255, 190, 156, 250),
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                 
                                                                                ],
                                                                              ),
                                                ),
                                              ),              
                                                 ]) ) : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                
                ),
              );}
              )
              ]),
            ),
          );
        })
                ],
              ),
            ),
          ),
        ],
      ),
    ),
        );
  }
}