
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fashion/details.dart';
import 'package:fashion/editprofile.dart';
import 'package:fashion/login.dart';
import 'package:fashion/main.dart';
import 'package:fashion/settings.dart';
import 'package:fashion/signup.dart';
import 'package:fashion/toast.dart';
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
    home: ProfilePage(),
  ));
}
class ProfilePage extends StatefulWidget {
  final dynamic data;
  final dynamic banner;

  final dynamic picture;
  const ProfilePage({super.key, this.data, this.banner, this.picture});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    dynamic bannerFile;
  dynamic pictureFile;
  ScrollController lazyLoading = ScrollController();
    ScrollController likedLoading = ScrollController();
String bio = 'No bio yet.';

String username = 'user';
String? banner;
String? picture;
int colorIndex = 9;
 final supabase = Supabase.instance.client;
dynamic user = Supabase.instance.client.auth.currentUser?.id;
dynamic userData;
void reportUser(){
  String selectedCat = 'Select...';
List categories=['Select...', 'Harrasment', 'Violence', 'Sexual content', 'Promoting illegal activity', 'Spam', 'Copyright violation'] ;
     showModalBottomSheet(context: context,
                                 constraints: BoxConstraints(
    maxWidth: double.infinity
  ),
                                builder:(context) {
                                 return StatefulBuilder(
                                   builder: (context, setState) {
                                     return Container(
                                           decoration: BoxDecoration(
                                             color: Colors.white,
                                             borderRadius: BorderRadius.circular(10)
                                           ),
                                           child: Padding(
                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                             child: Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                              Center(
                                                child: Text('Report', 
                                                                     textAlign: TextAlign.center,
                                                                     style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                             
                                                                      fontWeight: FontWeight.bold,
                                                                                                        fontSize: 20),),
                                              ),
                                                  SizedBox(height: 10,),
                                             Text('Please select a reason for reporting this user.', 
                                                                   textAlign: TextAlign.center,
                                                                   style: TextStyle(fontFamily: 'Poppins', color: Colors.black
                                                                                           ,
                                                                                                      fontSize: 17),),
                                                                          SizedBox(height: 30,),
                                           SizedBox(
                                            width: double.infinity,
                                             child: DropdownButtonHideUnderline(
                                               child: DropdownButton2(
                                                
                                                onChanged: (value) {setState(() {
                                                  selectedCat = value.toString();
                                                },);},
                                                value: selectedCat,
                                                items: categories.map((e) => DropdownMenuItem(
                                                                                        value: e,   
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    child: Text(e, style: TextStyle(fontFamily: 'Poppins', color: Colors.black),),
                                                  )))).toList(),
                                                  iconStyleData: IconStyleData(icon: Icon( Icons.keyboard_arrow_down_rounded),), menuItemStyleData: const MenuItemStyleData( overlayColor: WidgetStatePropertyAll( Color.fromARGB(255, 244, 236, 255),), ),
                                                 buttonStyleData: ButtonStyleData( height: 45,
                                                  width: MediaQuery.of(context).size.width-40, 
                                                  padding: EdgeInsets.symmetric(horizontal: 0), decoration: 
                                                  BoxDecoration( color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100), 
                                                  borderRadius: BorderRadius.circular(10), ),), 
                                                  dropdownStyleData: DropdownStyleData( 
                                                    maxHeight: 200,
                                                     decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(10), ), 
                                                  offset: const Offset(0, 5), scrollbarTheme: ScrollbarThemeData( thumbColor: WidgetStatePropertyAll( Color.fromARGB(255, 204, 191, 216),),
                                                   radius: const Radius.circular(8), thickness: WidgetStatePropertyAll(4), trackVisibility: WidgetStatePropertyAll(false), mainAxisMargin: 10, ), ),
                                               ),
                                             ),
                                           ),
                                          SizedBox(height: 20,),
                                           GestureDetector(
                                     onTap: () async {
                                      if (selectedCat != 'Select...'){
                                        try{
                                                                                // final prefs = await SharedPreferences.getInstance();

                                      await supabase.from('report').insert({'type':'user', 'target_id':widget.data['user_id'].toString(),
                                      //  'user_id':prefs.getString(
                                      //   'device_id'
                                      // )
                                      // ,
                                       'issue':selectedCat
                                      });
                                        Navigator.pop(context);
                                            Toast.show(context, 'Thank you. We will look into this issue shortly.',false)   ;  
                                      } catch (e){
  // Toast.show(context, 'Report already submitted. Slideory will continue to look into this issue',true)   ;  
                                      }
                                      }   
                                     },
                                             child: Container(
                                                      width:  double.infinity,
                                                      height: 50,
                                                   decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 221, 239),
                                                   borderRadius: BorderRadius.circular(10),
                                                   
                                                   ),
                                                   child: Center(child: 
                                              
                                                    
                                                   Text('Report',                                                                                                                  
                                                   style: 
                                                   TextStyle(fontFamily: 'Poppins', 
                                                   color: const Color.fromARGB(255, 251, 140, 194),
                                                   fontWeight: FontWeight.bold,
                                                   fontSize: 18)),),
                                                   ),
                                           ),                      
                                          SizedBox(height: 10,)
                                           ],
                                             ),
                                           ),
                                     );
                                   }
                                 );
                               },);
}
 
 void blockUser(){
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
                        child: Center(child: Icon(Icons.block, color: Colors.red, size: 30,),),
                      ),
                    
                    ),
                    SizedBox(height: 10,),
                    Text('Block User', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),),
                    SizedBox(height: 10,),
                    Text('If you block this user, they will no longer be able to see your posts, comments, or your account. Are you sure you want to proceed with this action?',
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
                                       
                                         
                                        final id = supabase.auth.currentUser!.id;
                                                    
            
            await supabase.from('block').insert({'blocker_id':id, 'blocked_id':widget.data['user_id'], 'username':widget.data['username']});
                                            Toast.show(context, 'User blocked successfully.', false);
            
                                     Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 0,),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                                                );
                                     
            
                                      
                                        
            
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
                                   
                                        Text('Block User',style: TextStyle(fontFamily: 'Poppins', color: Colors.white),),
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

 void showMore() {

    showModalBottomSheet(
      context: context,
        constraints: BoxConstraints(
    maxWidth: double.infinity
  ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user != null)
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
blockUser();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.block, color:  Colors.red, size: 25,),
                      SizedBox(width: 10),
                      Text('Block', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color:  Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16
                      )),
                    ],
                  ),
                ),
                  if (user != null)
                     SizedBox(height: 15,),
                        if (user != null)
                  Container(width: double.infinity, height: 2, color: const Color.fromARGB(255, 167, 167, 167),),
                     if (user != null)
                    SizedBox(height: 15,),
                GestureDetector(
                  onTap: () async {
                  Navigator.pop(context);
               reportUser();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.flag, color:  Colors.red, size: 25,),
                      SizedBox(width: 10),
                      Text(
                        'Report',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color:  Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
    void loadOwnData() async {
   
       if (user == null) return;
  
final data = await supabase.from('profile').select().eq('user_id', user).maybeSingle();

userData=data;
username = data?['username'] ?? '';
colorIndex = data?['theme'] ?? 9;
bio = data?['bio'];

if (data?['banner'] ?? false){
 banner = supabase.storage.from('profile').getPublicUrl('banner/$user.png');
}
if (data?['picture']??false){
 picture = supabase.storage.from('profile').getPublicUrl('picture/$user.png');

}
 setState(() {
   
 });
      
    }
     void loadOtherData() async {
      
bio = widget.data?['bio'] ??'No bio yet.';
username = widget.data?['username'];

colorIndex = widget.data?['theme'] ??0;
if (!(widget.data['liked'] ?? true)){
  cats.remove('Liked');
}
if (!(widget.data['completed'] ?? true)){
  cats.remove('Completed');
}

 banner =supabase.storage.from('profile').getPublicUrl('banner/${widget.data['user_id']}.png');
 picture = supabase.storage.from('profile').getPublicUrl('picture/${widget.data['user_id']}.png');
 setState(() {
   
 });
    }
    ScrollController completedLoading = ScrollController();

@override 
void initState() {
if (widget.data == null){

  
  loadOwnData();
  
} else {
  loadOtherData();
}
if (user!=null || widget.data!= null){
  loadOwnStories();
}
    lazyLoading.addListener((){
if (lazyLoading.offset >=  (lazyLoading.position.maxScrollExtent) && storyHasMore){
  loadOwnStoriesAfterScrolling();
}
    
    });

   likedLoading.addListener(likedlistn);
    super.initState();
       completedLoading.addListener(likedlistn);
    super.initState();
  }

    void complistn(){
if (completedLoading.offset >=  (likedLoading.position.maxScrollExtent) && completedHasMore){
 loaCompletedAfterScrolling();
}}

    void likedlistn(){
if (likedLoading.offset >=  (likedLoading.position.maxScrollExtent) && likedHasMore){
  loadLikedAfterScrolling();
}}


List ownStoryData=[];
dynamic lastCreatedAt;
dynamic lastCompletedAt;
bool completedHasMore = true;
bool storyHasMore = true;
bool likedHasMore = true;




bool continueHasMore = true;
void loadOwnStoriesAfterScrolling() async{

   List posts = await supabase.from('story').select().not('draft', 'is', true)
    .eq('author', widget.data == null ?supabase.auth.currentUser?.id : widget.data['user_id'] ?? supabase.auth.currentUser?.id)
  .lt('created_at', lastCreatedAt)
  .limit(50).order('created_at', ascending: false);
  if (posts.isNotEmpty){
  lastCreatedAt = posts.last['created_at'];
  }

ownStoryData = [...ownStoryData, ...posts.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}')})];
if (posts.length < 50){
  storyHasMore=false;
}
setState(() {
  
});
}
void loadLikedAfterScrolling() async{
  
   List posts = await supabase.from('likes').select()
    .eq('user_id', widget.data == null ?supabase.auth.currentUser?.id : widget.data['user_id'] ?? supabase.auth.currentUser?.id)
   .eq('type','story')
   .lt('created_at', lastLikedCreatedAt)
  .limit(50).order('created_at', ascending: false);
  List getCorrespondingPosts =  await supabase.from('posts').select()
   .contains('id',posts.map((id)=>id['target_id']));
   Map postMap = {};
   for (final post in posts){
postMap[post['target_id']]=getCorrespondingPosts.where((e)=>e['id']==postMap['target_id']);
   }
 if (posts.isNotEmpty){
 lastLikedCreatedAt= posts.last['created_at'];
 }
likedStoryData = [...likedStoryData, ...postMap.values.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}')})];
if (posts.length < 50){
  likedHasMore=false;
  likedLoading.removeListener(likedlistn);

}
setState(() {
  
});
}
void loaCompletedAfterScrolling() async{
  
   List posts = await supabase.from('completion').select()
 
   .lt('created_at', lastCompletedAt)
    .eq('user_id', widget.data == null ?supabase.auth.currentUser?.id : widget.data['user_id'] ?? supabase.auth.currentUser?.id)
  .limit(50).order('created_at', ascending: false);
  List getCorrespondingPosts =  await supabase.from('posts').select()
   .contains('id',posts.map((id)=>id['story_id']));
   Map postMap = {};
   for (final post in posts){
postMap[post['story_id']]=getCorrespondingPosts.where((e)=>e['id']==postMap['story_id']);
   }
 if (posts.isNotEmpty){
  lastCompletedAt = posts.last['created_at'];
 }
  completedStoryData = [...completedStoryData, ...postMap.values.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}')})];
if (posts.length < 50){
completedHasMore=false;
 completedLoading.removeListener(complistn);

}
setState(() {
  
});
}
  void loadOwnStories()  async {
  final posts =  await supabase.from('story').select().not('draft', 'is', true)
  .eq('author', widget.data == null ? supabase.auth.currentUser!.id : widget.data['user_id'])
  
  .limit(50).order('created_at', ascending: false)
  ;

ownStoryData= posts.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')}).toList();
if (posts.isNotEmpty){
lastCreatedAt = posts.last['created_at'];
}
setState(() {
  
});

  }
List likedStoryData = [];
dynamic lastLikedCreatedAt;
dynamic lastContinueCreatedAt;
List completedStoryData = [];

  loadOthers() async{
    if (selected == 'Liked'){
 
  final posts = await supabase.from('likes').select().eq('type', 'story')
  
   .eq('user_id', widget.data == null ?supabase.auth.currentUser?.id : widget.data['user_id'] ?? supabase.auth.currentUser?.id)
  
  .limit(50).order('created_at', ascending: false)
  ;
 List getCorrespondingPosts =  await supabase.from('story').select()
   .filter('id', 'in',posts.map((id)=>id['target_id']).toList());
   List postMap = [];
   for (final post in posts){
postMap=[...getCorrespondingPosts.where((e)=>e['id']==post['target_id']), ...postMap];
   }
 if (posts.isNotEmpty){
  lastLikedCreatedAt = posts.last['created_at'];
 }
likedStoryData = [ ...postMap.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')})];
if (posts.length<50){
  likedLoading.removeListener(likedlistn);
}
setState(() {
  
});

    } else { 
  final posts = await supabase.from('completion').select()
  
   .eq('user_id', widget.data == null ?supabase.auth.currentUser?.id : widget.data['user_id'] ?? supabase.auth.currentUser?.id)
  
  .limit(50).order('created_at', ascending: false)
  ;
 List getCorrespondingPosts =  await supabase.from('story').select()
   .filter('id', 'in',posts.map((id)=>id['story_id']).toList());
   List postMap = [];
   for (final post in posts){
postMap=[...getCorrespondingPosts.where((e)=>e['id']==post['story_id']), ...postMap];
   }
 if (posts.isNotEmpty){
  lastCompletedAt = posts.last['created_at'];
 }
completedStoryData = [ ...postMap.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')})];
if (posts.length<50){
 completedLoading.removeListener(complistn);
}
setState(() {
  
});
    }}
  @override
void dispose(){
  lazyLoading.dispose();
  likedLoading.dispose();
  super.dispose();
}
Color lightBlue =  Color.fromARGB(255, 89, 162, 240);
Color darkBlue =   Color(0xFF5988F0);
final tags = ['books', 'charger', 'clothes'];
dynamic returnedBio;
dynamic returnedTheme;
List cats = ["Stories", 'Liked', 'Completed'];

dynamic selected = 'Stories';
final listings = [{'name': 'charger1', 'status': 'For Trade'}, {'name': 'book', 'status': 'For Borrowing'}];
  TextEditingController myController =   TextEditingController();

List<String> todoList = [];
String current = 'Home';
List digits = ['', '', '', '', ''];
bool market = true;

final data = [
  {"id":3,
  'title':"POV: You're a teenager in the 2000s", 
  "username":"euphroic",
  "lives":3, 'storytype':"Basic",
  "authorid":'11',}
  , {"id":3,
  "lives":null,
  'title':"Go camping", 
  "username":"sweetlittlebunny",
   'storytype':"Basic",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"You're invited to a beach bonfire!", 
   'storytype':"Basic",
  "username":"seasalt",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"Live as a ghost", 
   'storytype':"Basic",
  "username":"ghostlybunny",
  "authorid":'11',},
  

];
List<Color> colors = [Colors.red, const Color.fromARGB(255, 246, 95, 145),  const Color.fromARGB(255, 255, 177, 203),  Colors.orange, Colors.yellow, Colors.green, Colors.blue,
 const Color.fromARGB(255, 172, 216, 248),  const Color.fromARGB(255, 144, 80, 255),
const Color.fromARGB(255, 195, 166, 246),Colors.grey,
Colors.black, 
 ];
  @override
  Widget build (BuildContext context){
           final width = MediaQuery.of(context).size.width;
    final color = colors[widget.data == null ? colorIndex : widget.data['theme'] ?? colorIndex];
  return Scaffold(
     backgroundColor:  const Color.fromARGB(255, 246, 246, 246),
    body: 
    user == null && widget.data == null? Container(
      decoration: BoxDecoration(

      
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [    const Color.fromARGB(255, 195, 166, 246),  const Color.fromARGB(255, 246, 246, 246),  const Color.fromARGB(255, 246, 246, 246),])
      ),
      child: Center(
        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                  
                      
                      Text('SLIDEORY', style: TextStyle(fontFamily: 'Poppins', 

                        foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 255, 129, 188),
                                  const Color.fromARGB(255, 192, 159, 252),
                                ],
                              ).createShader(
                                Rect.fromLTWH(0, 0, 200, 70),
                              )
                                                          //     const Color.fromARGB(255, 195, 166, 246)
                                                               , fontWeight: FontWeight.bold,
                                                                                                  fontSize: 35),),
                                                                                                  SizedBox(height: 10,),
                                                                                                Padding(
      
                                                           padding: const EdgeInsets.symmetric(horizontal: 20),
                                                           child: Text('Create an account to unlock new features such as creating stories, commenting, and customizing your profile!', 
                                                           textAlign: TextAlign.center,
                                                           style: TextStyle(fontFamily: 'Poppins',  color: const Color.fromARGB(255, 0, 0, 0),
                                                                                            fontWeight: FontWeight.bold    ,
                                                                                              fontSize: 20),),
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
                                                                                                                                   
                                                                                                                    color:  const Color.fromARGB(255, 255, 209, 224),
                                                                                                                    border: Border.all(color:    const Color.fromARGB(255, 246, 95, 145), width: 2, ), 
                                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                                  ), child: Padding(
                                                                                                                    padding: const EdgeInsets.all(10),
                                                                                                                    child: Center(
                                                                                                                      child:Text('Sign Up', 
                                                                                                                           style: TextStyle( color: const Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold, 
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
                                           
                            color:  const Color.fromARGB(255, 255, 209, 224),
                            border: Border.all(color: const Color.fromARGB(255, 246, 95, 145), width: 2, ), 
                            borderRadius: BorderRadius.circular(25),
                                                ), child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child:Text('Log In', 
                                   style: TextStyle( color: const Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold, 
                                   fontFamily: "Poppins", fontSize: 19
                                   ),
                            ),)
                                                ),
                                                ),
                          ),
                                                                                            ]
        ),
      ),
    ):
    Center(
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
             
          
                          
                          Column(
                            children: [
(widget.banner ?? banner) == null || (widget.banner ?? banner)!.contains('null')?
                              Container(
                                width: width,
                                height: 130,
                                decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 199, 217), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(20))),
                                           
                              )
                             :
                               Container(
                                width: width,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 199, 217),
                                  image: banner == null && bannerFile==null? null : DecorationImage(
                                 
                                    image: bannerFile == null ? NetworkImage(banner??'') : FileImage(bannerFile), fit: BoxFit.cover),
                                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(20))),
                                           
                              )  
                              ,
                          

                          SizedBox(height: 70,),
                             Padding(
                               padding: const EdgeInsets.all(20),
                               child: Align(
                                alignment: Alignment.topLeft,
                                 child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text(
                                     
                                 widget.data == null ?  bio : widget.data['bio'] ?? 'No bio yet.',
                                        style: TextStyle(
                                                         color: Colors.black87,
                                                       
                                                         fontSize: 16,
                                                         fontFamily: 'Poppins',
                                                        )),
                                                         SizedBox(height: 25,),
                                                       
                                                         Column(
                                                          children: [
Row(
  mainAxisAlignment: cats.length ==3 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
                          children:cats.map((entry){
                return Padding(
                  padding:  EdgeInsets.only(right:  cats.length ==3  ? 10 : 20 ),
                  child: GestureDetector(
onTap: (){
  setState(() {

  selected = entry;
  if (entry != 'Stories' && ((entry == 'Liked' ? likedStoryData.isEmpty  : false) || (entry == 'Completed' ? completedStoryData.isEmpty: false)) ){
    
    loadOthers();
  }
  });
},
                    child: Container(
                      width:107,
                    decoration: BoxDecoration(
                 
                      color: entry == selected ? color.withAlpha(90) : null,
                      border: Border.all(color:   colors[widget.data == null ?  returnedTheme ??colorIndex : widget.data['theme'] ?? colorIndex], width: 2, ), 
                      borderRadius: BorderRadius.circular(25),
                    ), child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child:Text(entry, 
                             style: TextStyle( color: color, fontWeight: FontWeight.bold, 
                             fontFamily: "Poppins", fontSize: 12
                             ),
                      ),)
                    ),
                    ),
                  ),
                );
                            }).toList()),
                       RefreshIndicator(
                        onRefresh: () async {
                        
selected != 'Stories' ? loadOthers() : loadOwnStories();
                        },
                         child: SizedBox(
                          height: MediaQuery.of(context).size.height-(widget.data == null ? 450 : 375),
                           child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing:3,
                            childAspectRatio: 0.6,
                            ),
                            controller:  selected == 'Stories' ? lazyLoading : likedLoading,
                            itemCount: selected == 'Stories' ? ownStoryData.length : selected == 'Liked' ? likedStoryData.length : completedStoryData.length,
                            itemBuilder: (context, index){
                           return   
                               Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child:
                                  
                                  
                                  GestureDetector(
                                           onTap: () async {
      dynamic useThisOne;
  useThisOne = selected == 'Stories' ? ownStoryData[index]:
      selected == 'Liked' ?
      likedStoryData[index] : completedStoryData[index];
   
      final results = await Future.wait([

supabase.from('slide').select().eq('story_id',useThisOne['id']),
supabase.from('options').select().eq('story_id', useThisOne['id']),
if (user == null)  Future.value([]) else supabase.from('likes').select().eq('target_id', useThisOne['id'])
                                            .eq('user_id', supabase.auth.currentUser?.id ??0),
                                            supabase.from('story').select('comments, likes').eq('id', useThisOne['id']),
                                            ]
                                            
                                            );
                                        
                                          Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(
                       data:{...useThisOne, 'likes':results[3][0]['likes'], 'comments':results[3][0]['comments']}, 
                       slideData: results[0], optionData: results[1], hasLiked: 
                        results[2].isNotEmpty 
                       ,
                      // data: stories[index],  slideData: slides, optionData: options, hasLiked: hasLiked.isNotEmpty,
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                                          );
                                      },
                                      child: Container(
                                    
                                      decoration: BoxDecoration(
                                        
                                            image: (
                                              (selected=='Stories' ? ownStoryData[index]['hasCover'] : 
                                              selected == 'Liked' ?
                                              likedStoryData[index]['hasCover'] : completedStoryData[index]['hasCover'])??false) ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: 
                                           NetworkImage((selected == 'Stories' ? ownStoryData[index]['cover']:
                                           
                                       selected == 'Liked' ?
                                              likedStoryData[index]['cover'] : completedStoryData[index]['cover']))): null,
                                          border: Border.all(color: colors[colorIndex], width: 1.5),
                                          color: 
                                            Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                          child:   ((selected=='Stories' ? ownStoryData[index]['hasCover'] :
                                          selected == 'Liked' ?
                                              likedStoryData[index]['hasCover'] : completedStoryData[index]['hasCover']
                                          )??false)?  null :
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child:  Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text((selected=='Stories'?ownStoryData[index]['title']:
                                              selected == 'Liked' ?
                                              likedStoryData[index]['title'] : completedStoryData[index]['title']
                                            ), style: TextStyle(fontFamily: 'Poppins', color: 
                                               colors[colorIndex],
                                                 fontWeight: FontWeight.bold,
                                                 
                                                 overflow: TextOverflow.ellipsis,
                                                fontSize: 25), maxLines: 3,
                                              ),
                                            ),
                                          ),
                                      //   image: DecorationImage(image: NetworkImage((selected == 'Stories' ? ownStoryData[index]['cover']:likedStoryData[index]['cover'])),
                                      //   fit: BoxFit.cover
                                      //   ),
                                      // border: Border.all
                                      
                                      // (
                                      //   width: 1.5,
                                      //   color: color),
                                      // color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                      // child: Padding(
                                      //   padding: const EdgeInsets.all(15),
                                      //   // child: Align(
                                      //   //   alignment: Alignment.bottomLeft,
                                      //   //   child: Text(data[index]['Title'] ?? '', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold,
                                      //   //   fontSize: 26),),
                                      //   // ),
                                      // ),
                                      ),
                                    ),
                                  
                               
                              
                            );
                                         }),
                         ),
                       ),
                                         ])      ],
                                 ),
                               ),
                             ),
                          ],
                          ),
                   
              
                             Positioned(
                            left: 20,
                            top: 100,
                            child:     Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              
                           //   (widget.picture ?? picture) == null || (widget.picture ?? picture)!.contains('null') ?
                                Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(25),
                                                   border: Border.all(color: Colors.white),
                                                    image: picture == null && pictureFile==null ? null :DecorationImage(
                                                     
                                                      image: pictureFile == null ? NetworkImage(picture??'') : FileImage(pictureFile), fit: BoxFit.cover),
                                                    color:   const Color.fromARGB(255, 196, 163, 254)
                                                  ),
                                                  // child: Center(child: 
                                                  // Text(widget.data == null ? username[0].toUpperCase() :  
                                                  // (widget.data['username']??username)[0].toUpperCase(), style: TextStyle(fontSize: 50, color: Colors.white, fontFamily: 'Poppins'),)
                                                  // ),
                                                     ),
                                                   
                                                     
                         SizedBox(width: 20),
                         Column(
                           children: [
                            SizedBox(height: 30,),
                            
                                 Text('@${widget.data == null ? username : widget.data['username'] ?? username}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold,
                                 fontSize: 22, color: Colors.black),),
                               
                               
                           ],
                         ),
                              ],
                            ),),
                          widget.data == null 
                         && user != null 
                          ?
                            SafeArea(
                              
                              child: Stack(
                                children: [
                                  Positioned(
                                              right: 30,
                                             
                                              child: Row(
                                                children: [
                                                    GestureDetector(
                                                        onTap: () async {
                                                          final userData = await supabase.from('profile').select().eq('user_id', supabase.auth.currentUser?.id??0);
                                                                                     final result = await Navigator.of(context).push(
                                                                                      PageRouteBuilder(
                                                                                      pageBuilder: (context, animation, secondaryAnimation) => EditProfile(
                                                                                        data: userData.toList(),
                                                                                        
                                                                                         banner: banner,
                                                                                         picture: picture,
                                                                                         bannerFile: bannerFile,
                                                                                         pictureFile: pictureFile
                                                                                         )
                                                                                         ,
                                                                                        transitionDuration: Duration.zero,
                                                                                        reverseTransitionDuration: Duration.zero,
                                                                                      ),
                                                              );
                                                              if (result != null &&result.isNotEmpty){
                                                                
                                                                setState(() {
                                                                
                                                              returnedBio = result[0] ?? 'No bio yet.';
                                                              bio = returnedBio;
                                                               
                                                              colorIndex = result[1] ?? colorIndex ;
                                                            
                                                           
if ((result[2]!=null)&&banner==null){
bannerFile = result[2];
    banner =supabase.storage.from('profile').getPublicUrl('banner/${user}.png');
}
                                                              
                                                              if ((result[3]!=null)&&picture==null){
                                                                pictureFile = result[3];
                                                                
 picture = supabase.storage.from('profile').getPublicUrl('picture/${user}.png');
                                                              }

                                                                });
                                                              }
                                                          },
                                                        
                                                    child:   Container(
                                                                
                                                                                      decoration: BoxDecoration(
                                                                                        color: color.withAlpha(120) ,
                                                                                        shape: BoxShape.circle
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: Center(child: Icon(Icons.edit, size: 26, 
                                                                                        color: const Color.fromARGB(255, 255, 255, 255), )),
                                                                                      ),
                                                                                    ),
                                                    
                                                    ),
                                                    SizedBox(width: 20,),
                                                  GestureDetector(
                                                        onTap: () async{
                                                                           final datas = await          Navigator.of(context).push(
                                                                                      PageRouteBuilder(
                                                                                        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(data: userData),
                                                                                        transitionDuration: Duration.zero,
                                                                                        reverseTransitionDuration: Duration.zero,
                                                                                      ),
                                                              );
                                                              if (datas!= null){
                                                                username=datas  ;
                                                                setState(() {
                                                                  
                                                                });
                                                              }
                                                          },
                                                    child:   Container(
                                                                
                                                                                      decoration: BoxDecoration(
                                                                                        color: color.withAlpha(120)  ,
                                                                                        shape: BoxShape.circle
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: Center(child: Icon(Icons.settings, size: 26, 
                                                                                        color: const Color.fromARGB(255, 255, 255, 255), )),
                                                                                      ),
                                                                                    ),
                                                    
                                                    ),
                                                    
                                                ],
                                              ) 
                                                , 
                                             ),
                                ],
                              ),
                            ) 
           : widget.data != null  ?  SafeArea(

             child: Stack(
               children: [
             if   ( widget.data['user_id'] != user )
                 Positioned(
                 
                  right: 30,
                  child: GestureDetector(
                        onTap: (){
                        showMore();
                          },
                    child:   
                        
                                    
                          Container(
                                    
                                        decoration: BoxDecoration(
                                          color: color.withAlpha(100) ,
                                          shape: BoxShape.circle
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Center(child: Icon(Icons.more_horiz, size: 26, 
                                          color: const Color.fromARGB(255, 255, 255, 255), )),
                                        ),
                                      ),              
                     
                    
                    ) ,),
                 Positioned(
               
                  left: 30,
                  child: GestureDetector(
                        onTap: (){
                          if (Navigator.canPop(context)){
                            Navigator.pop(context);
                          } else {
                                   Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => MyApp(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                                          );
                          }
                          },
                    child:   
                        Container(
                                    
                                        decoration: BoxDecoration(
                                          color: color.withAlpha(100) ,
                                          shape: BoxShape.circle
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Center(child: Icon(Icons.arrow_back, size: 26, 
                                          color: const Color.fromARGB(255, 255, 255, 255), )),
                                        ),
                                      ),
                                    
                                     
                     
                    
                    ) ,),
               ],
             ),
           ) : SizedBox.shrink(),
           
          ],
        ),
      ),
    ),
        );
  }
}
// import 'package:flutter/material.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // await Supabase.initialize(
//   //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
//   //   anonKey:
//   //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
//   // );

//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: ProfilePage(),
//   ));
// }
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

// Color lightBlue =  Color.fromARGB(255, 89, 162, 240);
// Color darkBlue =   Color(0xFF5988F0);
// final tags = ['books', 'charger', 'clothes'];
// final listings = [{'name': 'charger1', 'status': 'For Trade'}, {'name': 'book', 'status': 'For Borrowing'}];
//   TextEditingController myController =   TextEditingController();

// List<String> todoList = [];
// String current = 'Home';
// List digits = ['', '', '', '', ''];
// bool market = true;
// final data = ['test'];
//   @override
//   Widget build (BuildContext context){
//   return Scaffold(
//      backgroundColor: Colors.white,
//     body: Padding(
//       padding: const EdgeInsets.all(20),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 14,),
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 199, 217)),

//             ),
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//             )
//         //    Container(
//         // width: 90,
//         // height: 90,
//         // decoration: BoxDecoration(
//         //   shape: BoxShape.circle,
//         //   color: lightBlue
//         // ),
//         //    ),
//         //    SizedBox(height: 10),
//         //    Text('@username', style: TextStyle(fontFamily: 'Inter',
//         //    fontSize: 20),),
//         //    SizedBox(height: 20,),
//           //  Text('Your Listings', style: TextStyle(fontFamily: 'Inter',
//           //  color: darkBlue, fontSize: 27),),
//               SizedBox(height: 10),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   crossAxisAlignment: CrossAxisAlignment.center,
//               // children: [
//             //     GestureDetector(
//             // onTap: () {
//             //   market = true;
//             //   setState(() {});
//             // },
//             // child: Column(
//             //   children: [
//             //     Text(
//             //       'Market',
//             //       style: TextStyle(
//             //         fontFamily: 'Inter',
//             //         color: market ? lightBlue : Colors.grey.shade500,
//             //       ),
//             //     ),
//             //     const SizedBox(height: 5),
//             //     SizedBox(
//             //       width: 50,
//             //       height: 5,
//             //       child: AnimatedContainer(
//             //         duration: const Duration(milliseconds: 300),
//             //         curve: Curves.easeInOut,
//             //         width: market ? 50 : 0,
//             //         height: market ? 5 : 0,
//             //         decoration: BoxDecoration(
//             //           shape: BoxShape.circle,
//             //           color: market ? lightBlue : Colors.transparent,
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             //     ),
//             //     const SizedBox(width: 20),
//             //     GestureDetector(
//             // onTap: () {
//             //   market = false;
//             //   setState(() {});
//             // },
//             // child: Column(
//             //   children: [
//             //     Text(
//             //       'Looking For',
//             //       style: TextStyle(
//             //         fontFamily: 'Inter',
//             //         color: !market ? lightBlue : Colors.grey.shade500,
//             //       ),
//             //     ),
//             //     const SizedBox(height: 5),
//             //     SizedBox(
//             //        width: 50,
//             //       height: 5,
//             //       child: AnimatedContainer(
//             //         duration: const Duration(milliseconds: 300),
//             //         curve: Curves.easeInOut,
//             //         width: !market ? 50 : 0,
//             //         height: !market ? 5 : 0,
//             //         decoration: BoxDecoration(
//             //           shape: BoxShape.circle,
//             //           color: !market ? lightBlue : Colors.transparent,
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             //     ),
//             //   ],
//             // ),
//             // SizedBox(height: 10),
//             // Expanded(
//             //        child: Padding(
//             //          padding: const EdgeInsets.only(bottom: 40),
//             //           child:
//             //          // FutureBuilder(
//             //          //   future: supabase.from('product').select(),
//             //          //   builder: (context, asyncSnapshot) {
                 
//             //          //     final data = asyncSnapshot.data ?? [];
//             //          //     final filteredQuery = currentcat == 'All'
//             //          // ? data
//             //          // : data.where((entry) {  
//             //          //   List lister = entry['category'];
//             //          //   return lister.contains(currentcat.toLowerCase());});
//             //          // final searchFilter = myController.text.isEmpty ? filteredQuery : 
//             //          // filteredQuery.where((entry) => entry['name'].contains(myController.text));
//             //              // return
//             //               Align(
//             //                 alignment: Alignment.centerLeft,
//             //                 child: GridView.builder(
//             //                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //                                   crossAxisCount: 2, 
//             //                                   crossAxisSpacing: 12,
//             //                                   mainAxisSpacing: 8,
//             //                                   childAspectRatio: 0.75, 
//             //                                 ),
//             //                                 padding: EdgeInsets.all(10),
//             //                                 itemCount: listings.length,
//             //                                itemBuilder: (context, index) {
//             //                                 // final url = data[index]['path'] == null ? '' :supabase.storage.from('clothing').getPublicUrl(data[index]['path']);
//             //                 return 
//             //                  GestureDetector(
//             //                                        onTap: (){
//             //                                //          Navigator.of(context).push(
//             //                                //           PageRouteBuilder(
//             //                                //         pageBuilder: (context, animation, secondaryAnimation) => ProductDetails(
//             //                                //  data: data[index],
//             //                                //  url: url,
//             //                                //         ),
//             //                                //         transitionDuration: Duration.zero,
//             //                                //         reverseTransitionDuration: Duration.zero,
//             //                                //           ),
//             //                                //         );
//             //                                        },
//             //                                        child: Container(
//             //                  decoration: BoxDecoration(
//             //                    boxShadow: [
//             //                      BoxShadow(       color: Colors.black.withAlpha(13),
//             //                   blurRadius: 8,
//             //                   offset: const Offset(0, 2),)
//             //                    ],
//             //                    borderRadius: BorderRadius.circular(10),
//             //                  ),
//             //                  child: Column(
//             //                    children: [
//             //                      Expanded(
//             //                                 flex: 5,
//             //                                 child: 
//             //                                 // data[index]['path'] == null 
//             //                                 // ?
//             //                                  Container(
//             //                                   decoration: BoxDecoration(
                                                
//             //                                     color:    Colors.grey.shade300,
//             //                                     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//             //                                   ),
                                 
                              
//             //                                   child: Center(
//             //                                     child: Icon(Icons.image, size: 60, color: Colors.grey)
//             //                                   ),
//             //                                 ) 
//             //                                 // :Container(
                                              
//             //                                 //   decoration: BoxDecoration(
//             //                                 //     image: DecorationImage(image: 
                                                
//             //                                 //     NetworkImage(url),
//             //                                 //       fit: BoxFit.cover,
//             //                                 //     ),
//             //                                 //     color:    Colors.grey.shade300,
                                                
//             //                                 //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//             //                                 //   ),
                                 
                              
                                             
//             //                                 // ) ,
//             //                      ),
//             //                      Expanded(
//             //                                 flex: 2, 
//             //                                 child: Container(
//             //                                   width: double.infinity,
//             //                                   decoration: BoxDecoration(
//             //                                     color: Colors.white,
//             //                                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
//             //                                   ),
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(left: 15),
//             //                                     child: Column(
//             //                                       mainAxisAlignment: MainAxisAlignment.start,
//             //                                       crossAxisAlignment: CrossAxisAlignment.start,
//             //                                       children: [
//             //                 SizedBox(height: 6,),
//             //                 Text(
//             //                  '${listings[index]['name']}',
//             //                   // data[index]['name'], 
//             //                 overflow: TextOverflow.ellipsis,
//             //                 style: TextStyle(fontFamily: 'Inter',
//             //                 ),),
//             //                                 SizedBox(height:3,),
//             //                                 Text(
                                              
//             //                                 // '  data[index]['price'] == null ?'N/A' : data[index]['price'],'
//             //                                     '${listings[index]['status']}',
//             //                                    style: TextStyle(
//             //                                   fontFamily: 'Inter',
//             //                                   fontWeight: FontWeight.bold,
//             //                                   color:darkBlue
//             //                                 ),)
//             //                                       ],
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                      ),
//             //                    ],
//             //                  ),
//             //                  ));
//             //                                }),
//             //               )
//             //                ),
//             //                )
//               ],
//               ),
//       ),
//     ),
//         );
//   }
// }
