

import 'package:fashion/main.dart';
import 'package:fashion/terms.dart';
import 'package:fashion/toast.dart';
import 'package:fashion/welcome.dart';
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
    home: ManagePage(),
  ));
}
class ManagePage extends StatefulWidget {
  final dynamic username;
  final dynamic completed;
  final dynamic liked;
  const ManagePage({super.key, this.username, this.completed, this.liked});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  bool loadingDel = false;
bool liked = false;
final supabase = Supabase.instance.client;
 final id = Supabase.instance.client.auth.currentUser!.id;
bool completed = false;
bool showUsername = false;
Map sections = { "Account":['Change Username',],
"Privacy":["Liked stories visible to others", 'Completed stories visible to others',], 'Security':['Blocked Accounts']
};
List? blocked;
bool showBlockedAccs = false;
Map sectionIcon = {
  'manage account':Icons.person,
  'Security':Icons.security,
  "Notifications":Icons.notifications,
  'Help Center': Icons.help,
  'Privacy Policy':Icons.privacy_tip,
  "Terms of Service":Icons.article,
  "Logout":Icons.logout,
 "Delete Account": Icons.delete
};
String? saved;
 void blockUser(blockedID){
    showDialog(context: context, builder: (context) {
      
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content:  Container(
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
                        child: Center(child: Icon(Icons.block, color: Colors.red, size: 30,),),
                      ),
                    
                    ),
                    SizedBox(height: 10,),
                    Text('Unblock User', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),),
                    SizedBox(height: 10,),
                    Text('If you unblock this user, they will be able to see your posts, comments, or your account. Are you sure you want to proceed with this action?',
                  textAlign: TextAlign.center,
                     style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins', color: const Color.fromARGB(255, 107, 107, 107)),),
                    SizedBox(height: 25,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
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
                                       
                                         
                                       
                                                    
            
            await supabase.from('block').delete().eq('blocker_id', id).eq('blocked_id', blockedID);
              blocked!.removeWhere((e)=>e['blocked_id'] == blockedID);
              Navigator.pop(context);
              setState((){});
                                            Toast.show(context, 'User unblocked successfully.', false);
            
                                
                                     
            
                                      
                                        
            
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
                                   
                                        Text('Unblock User',style: TextStyle(fontFamily: 'Poppins', color: Colors.white),),
                                      ),
                                                                ),
                                      ),
                                    ),
                  ],
                  
                  ),
                ),
              ),
            )
          
        
      );
    });
  }
TextEditingController usernameController = TextEditingController();
@override
void initState() {
  if (widget.username != null){
    usernameController = TextEditingController(text: widget.username);
  }
   if (widget.completed!=null){
    completed = (widget.completed??true);

   }
   if (widget.liked!= null){

    liked = (widget.liked??true);
   }
    super.initState();
  }
  @override
  Widget build (BuildContext context){
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
    body: GestureDetector(
       onTap: (){
                 FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
              },
      child: SafeArea(
        child: SingleChildScrollView(
          child: FocusScope(
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
                                        Navigator.pop(context, saved);
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
                    Text('Manage Account', style: TextStyle(fontFamily: 'Poppins', color: 
                                                                       const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                                          fontSize: 22),),
                        
                            SizedBox(height: 20,),                  
              ...sections.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                            if (e == 'Change Username'){
                             setState(() {
                               showUsername=!showUsername;
                             });
                  } else if (e=='Blocked Accounts'){
                    
                    if (blocked == null ){
                    blocked = await supabase.from('block').select().eq('blocker_id', id);
                    }
                  setState(() {
                    showBlockedAccs=!showBlockedAccs;
                  });
                  } else if (e=='Terms of Service'){
                    Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => TermsofServices(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                                                  );  
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
                   }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: entry.value.indexOf(e) == entry.value.length-1 ? BorderSide.none : BorderSide(width: 1,  color:  const Color.fromARGB(255, 246, 95, 145),))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:20 , horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //         Icon(
                                  //         sectionIcon[e], color:   const Color.fromARGB(255, 246, 95, 145),
                                  //         ),
                                  // SizedBox(width: 10,),
                                  Text(e, style: TextStyle(fontFamily: 'Poppins',  fontSize: 13,
                                  fontWeight: FontWeight.bold, color:  const Color.fromARGB(255, 246, 95, 145),
                                  ),),
                                  Spacer(),
                              entry.key == 'Privacy' ?
                                Switch(
                                inactiveThumbColor: const Color.fromARGB(255, 195, 166, 246),
                                 activeThumbColor: const Color.fromARGB(255, 246, 95, 145),
             value:e == 'Completed stories visible to others' ? completed : liked, onChanged: (em) async {
                                              
            if (e == 'Completed stories visible to others'){
              completed=!completed;
              await supabase.from('profile').update({'completed':completed, 'user_id':id}).eq('user_id', id);
            } else {
              liked=!liked;
                await supabase.from('profile').update({'liked':liked, 'user_id':id}).eq('user_id', id);
            }
             setState(() {
                                  });
                                //  await supabase.from('story').update({'lives':null}).eq('id', widget.draftData['id']);
                                                                                                                          }):
                                          Container(
                                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                              
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Center(child:
                                              
                                            
                                               Icon(
                                                e=='Blocked Accounts' && showBlockedAccs ? Icons.keyboard_arrow_down :
                                                  e=='Change Username' && showUsername ? Icons.keyboard_arrow_down :
                                                Icons.chevron_right, color: const Color.fromARGB(255, 195, 166, 246),)),
                                            ))
                                ],
                              ),
                             
                              AnimatedSize(
                                 duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
                                child:  e=='Change Username' && showUsername ?SizedBox(
                                    height:160,
                                     child:   Column(
                                       children: [
                                     
                                                                                                             SizedBox(height: 25,),
                                                              Container(
                                                     
                                                    width:double.infinity,
                                                    decoration: BoxDecoration(
                                                     border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                                     borderRadius: BorderRadius.circular(10) 
                                                    ),
                                                    
                                                    child:  TextField(
                                                 
                                                 controller: usernameController,
                                                  decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                  hint: Text('Username', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                                                 const Color.fromARGB(255, 111, 111, 111),
                                                                                                                    fontSize: 15)),
                                                  ),
                                                  style: TextStyle(fontFamily: 'Poppins', color: 
                                                                                 const Color.fromARGB(255, 0, 0, 0),
                                                                                                                    fontSize: 16)
                                                    ),
                                                  ) ,        
                                                  SizedBox(height: 20,),
                                                    GestureDetector(
                                                             onTap: () async {
                                                              try {
                                                            if (usernameController.text.trim().length<=3)
                                    {
                                    Toast.show(context, 'Username too short. Must be more than 3 characters', true);
                                      
                                return;
                                    } 
                                   else if (usernameController.text.trim().length>15){
                                        Toast.show(context, 'Username too long. Must be less than 15 characters.', true);
                                    
                                return;
                                    } 
                                   else if (RegExp(r'\s').hasMatch(usernameController.text.trim())){
                                      Toast.show(context, 'Username cannot have empty spaces', true);
                                
                                return;
                                    }
                                  else  if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(usernameController.text.trim())){
                                    Toast.show(context, 'Username contains invalid characters', true);
                                  
                                return;
                                    } else if (!RegExp(r'[a-zA-Z]').hasMatch(usernameController.text) ) {
                                 Toast.show(context, 'Username has to contain letters', true);
                                  
                                
                                return;
                                    }
                                                       await supabase.from('profile').update({'username':usernameController.text.trim(), 'user_id':id}).eq('user_id', id);
                                                       saved = usernameController.text.trim();
                                                       Toast.show(context, 'Username updated', false);
                                                              } catch (e){
                                                       Toast.show(context, 'Update failed. Try another username', true);
                                
                                                              }
                                                             },
                                                            
                                                             child: Container(
                                                              
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
                                            'Save Username',
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
                                                         ),              
                                                       ]) ) : SizedBox.shrink(),
                              ),
                              AnimatedSize(
                                     duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
                           child:  e=='Blocked Accounts' && showBlockedAccs ?
                              Container(
                                child: 
                                blocked!.isEmpty ? 
                                 Padding(
                                   padding: const EdgeInsets.all(25),
                                   child: Center(child:
                                   
                                    Text('You have not blocked anyone.', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                      fontSize: 18))),
                                 ) 
                                 :  SizedBox(
                                  height:250,
                                   child: ListView.builder(
                                                             
                                    scrollDirection: Axis.vertical,
                                    
                                    itemCount: blocked!.length,
                                    itemBuilder: (context, index){
                                   return   
                                       Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child:
                                          
                                          
                                          Container(
                                          width: double.infinity, 
                                                                              
                                          decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(255, 195, 166, 246)),
                                          color: const Color.fromARGB(255, 255, 255, 255).withAlpha(150), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  //  Container(
                                                  //       width: 50,
                                                  //       height: 50,
                                                  //       decoration: BoxDecoration(
                                                  //        borderRadius: BorderRadius.circular(25),
                                                  //        border: Border.all(color: Colors.white),
                                                  //         color:    const Color.fromARGB(255, 246, 95, 145)
                                                  //       ),
                                                  //       child: Center(child: Text('A', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Poppins'),)),
                                                  //          ),
                                                  //          SizedBox(width: 20,),
                                                  Text('@${blocked![index]['username'] ?? ''}', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                  fontSize: 17),),
                                                  Spacer(),
                                                    GestureDetector(
                                                           onTap: () async {
                                                         blockUser(blocked![index]['blocked_id']);
                                                           },
                                                          
                                                           child: Container(
                                                            
                                                             decoration: BoxDecoration(
                                   color:    Color.fromARGB(255, 244, 237, 255),
                                    border: Border.all(color: Color.fromARGB(255, 190, 156, 250), width: 2 ),
                                    borderRadius: BorderRadius.circular(30),
                                    
                                                             ),
                                                             height: 45,
                                                             width: 135,
                                                             child: const Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        
                                        Text(
                                          'Unblock user',
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
                                                       ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ),
                                          
                                       
                                      
                                    );
                                                 }),
                                 )
                              // SizedBox(height: 5,),
                              // Container(
                              //   width: double.infinity,
                              //   height: 2,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     color:  const Color.fromARGB(255, 246, 95, 145),
                              //   ),
                              // )
                              ) : SizedBox.shrink())
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
        ),
      ),
    ),
        );
  }
}