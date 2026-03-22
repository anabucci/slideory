

import 'dart:async';

import 'package:fashion/details.dart';
import 'package:fashion/notifications.dart';
import 'package:fashion/search.dart';
import 'package:fashion/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StoriesForYou(),
  ));
}
class StoriesForYou extends StatefulWidget {
  const StoriesForYou({super.key});

  @override
  State<StoriesForYou> createState() => _StoriesForYouState();
}

class _StoriesForYouState extends State<StoriesForYou> {
  ScrollController lazyLoading = ScrollController();
 PageController lazyloading = PageController();
 bool hasNotification = false;
 final supabase = Supabase.instance.client;
 void listen4Notifications() async {

   final id = supabase.auth.currentUser?.id;
 final awaitInsert = supabase.channel('notifications');

 awaitInsert.onPostgresChanges(event: PostgresChangeEvent.insert,
 schema: 'public',
 filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'target_user', value: id ?? 0),
 table: 'notifications',
  callback:(event){
    setState(() {
     hasNotification=true;
    
    });
    awaitInsert.unsubscribe();
  }).subscribe();

 }
 Timer? timer;
 List viewedStories = [];
 void viewStories()  {
timer = Timer.periodic(Duration(seconds: 30), (timer) async {

  if (viewedStories.isNotEmpty){
final viewedstories2 = viewedStories;
viewedStories = [];
List insertList = viewedstories2.map((e)=> {'story_id':e['id']}).toList();

 await supabase.from('history').insert(insertList);
  }
});
 }
 void onscroll(){
  if (lazyloading.position.pixels >=  (lazyloading.position.maxScrollExtent)){
  
 if (hasMore) loadStoriesAfterScrolling();
}
    
 }
@override 
void initState() {
 loadStories();
 checkNotifis();
 if (user != null){
viewStories();
 }
  listen4Notifications();
//     lazyLoading.addListener((){
// if (lazyLoading.offset >=  (lazyLoading.position.maxScrollExtent-10)){
//  if (hasMore) loadStoriesAfterScrolling();
// }
//     });
 lazyloading.addListener(onscroll);
    super.initState();
  }
  @override
void dispose(){
  lazyloading.dispose();
  timer?.cancel();
  super.dispose();
}
bool isLoading = true;
  List alrdySeenIds = [];
List data = [
 {"id":3,
  'title':"POV: You're a teenager in the 2000s", 'tags':['ocean', 'beach'],
  "username":"euphroic",
  'likes':14,
  "lives":3, 'storytype':"Basic",

  "authorid":'11',}
  , {"id":3,
  'likes':2301,
  "lives":null,
  'title':"Go camping", 'tags':['ocean', 'beach'],
  "username":"sweetlittlebunny",
   'storytype':"Basic",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"You're invited to a beach bonfire!", 'tags':['ocean', 'beach'],
   'storytype':"Basic",
  "username":"seasalt",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"Live as a ghost", 
  'likes':111,
   'storytype':"Basic",'tags':['ocean', 'beach'],
  "username":"ghostlybunny",
  "authorid":'11',},
    {"id":3,
  'title':"POV: You're a teenager in the 2000s", 'tags':['ocean', 'beach'],
  "username":"euphroic",
  'likes':1000,
  "lives":3, 'storytype':"Basic",
  "authorid":'11',}
  , {"id":3,
  "lives":null,
  'likes':29,
  'title':"Go camping", 'tags':['ocean', 'beach'],
  "username":"sweetlittlebunny",
   'storytype':"Basic",
  "authorid":'11',},


  

];

final dataRaw = [
  {"id":3,
  'title':"POV: You're a teenager in the 2000s", 'tags':['ocean', 'beach'],
  "username":"euphroic",
  'likes':14,
  "lives":3, 'storytype':"Basic",

  "authorid":'11',}
  , {"id":3,
  'likes':2301,
  "lives":null,
  'title':"Go camping", 'tags':['ocean', 'beach'],
  "username":"sweetlittlebunny",
   'storytype':"Basic",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"You're invited to a beach bonfire!", 'tags':['ocean', 'beach'],
   'storytype':"Basic",
  "username":"seasalt",
  "authorid":'11',},
  {"id":3,
    "lives":null,
  'title':"Live as a ghost", 
  'likes':111,
   'storytype':"Basic",'tags':['ocean', 'beach'],
  "username":"ghostlybunny",
  "authorid":'11',},
    {"id":3,
  'title':"POV: You're a teenager in the 2000s", 'tags':['ocean', 'beach'],
  "username":"euphroic",
  'likes':1000,
  "lives":3, 'storytype':"Basic",
  "authorid":'11',}
  , {"id":3,
  "lives":null,
  'likes':29,
  'title':"Go camping", 'tags':['ocean', 'beach'],
  "username":"sweetlittlebunny",
   'storytype':"Basic",
  "authorid":'11',},


];


void loadStoriesAfterScrolling() async {

  //  DateTime oneDayAgo = DateTime.now().subtract(Duration(days: 1)) ;
    DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 31));
    DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
final recentPosts = await supabase.from('story').select()
.not('id', 'in', alrdySeenIds)
.not('draft', 'is', true)
.order('created_at', ascending: false)
.limit(5);
alrdySeenIds.addAll(recentPosts.map((e)=>e['id']));
final risingPosts = await supabase.from('story').select().lt('created_at', oneWeekAgo)
.not('draft', 'is', true)
.not('id', 'in', alrdySeenIds)
.lt('score', 80)
.limit(5);
alrdySeenIds.addAll(risingPosts.map((e)=>e['id']));
final popularPosts = await supabase.from('story').select()
// .lt('created_at', oneDayAgo)
.not('draft', 'is', true)
.not('id', 'in', alrdySeenIds)
.gt('created_at', oneMonthAgo).gte('score', 80)
.order('score', ascending: false)
.limit(5);
List story = [...recentPosts, ...popularPosts, ...risingPosts];
story.shuffle();
story=story.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}')}).toList();
stories.addAll(story);

if (recentPosts.length <5 && popularPosts.length <5 && risingPosts.length <5){
  hasMore=false;
  lazyloading.removeListener(onscroll);
}

if (user != null){
await supabase.from('history').insert({'story_id':story.first['id']});
}
alrdySeenIds.addAll([...popularPosts.map((e)=>e['id']), ]);
setState(() {
  
});
// lastScore = popularPosts.last['score'];
// recentPosts.sort((a, b){
//   DateTime aCreated = DateTime.parse(a['created_at']);
//   DateTime bCreated = DateTime.parse(b['created_at']);
//   return bCreated.compareTo(aCreated);
// });
// print('sorted recent posts $recentPosts');
// lastCreated = recentPosts.last['created_at'];
// setState(() {
  
// });

}
List stories = [];
int lastScore = 0;
DateTime? lastCreated;
bool hasMore = true;
   final user = Supabase.instance.client.auth.currentUser;
   void checkNotifis() async {
      final unseen= await supabase.from('notifications').select().not('seen', 'is', true).limit(1);
    if  (unseen.isNotEmpty){
    setState(() {
      
      hasNotification=true;

      
    });
    }

   }
  void loadStories() async {
 
     DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 31));

 List aldySeenIds= user == null ? []: await supabase.from('history').select().gt('created_at', oneMonthAgo);

 alrdySeenIds = aldySeenIds.map((e)=>e['story_id']).toList();

    // DateTime oneDayAgo = DateTime.now().subtract(Duration(days: 1));
      DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
   
final recentPosts = await supabase.from('story').select()

//.gt('created_at', oneDayAgo)
.not('id', 'in', alrdySeenIds)
.not('draft', 'is', true)
.order('created_at', ascending: false)
.limit(5); 
alrdySeenIds.addAll(recentPosts.map((e)=>e['id']).toList());
final risingPosts = await supabase.from('story').select()
.not('draft', 'is', true)
.lt('created_at', oneWeekAgo)
.not('id', 'in', alrdySeenIds)
.lt('score', 80).limit(5);
//.range(20, 80,referencedTable: 'score' );
alrdySeenIds.addAll(risingPosts.map((e)=>e['id']));
final popularPosts = await supabase.from('story')
.select()
.not('draft', 'is', true)
//.lt('created_at', oneDayAgo)
.gt('created_at', oneMonthAgo).not('id', 'in', alrdySeenIds).gte('score', 80)

.limit(5);
List story = [...recentPosts, ...popularPosts, ...risingPosts];
story.shuffle();
story=story.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')}).toList();

stories = story;
if (user != null && story.isNotEmpty) {
await supabase.from('history').insert({'story_id':story.first['id']});
}

alrdySeenIds.addAll(popularPosts.map((e)=>e['id']));
if (recentPosts.length <5 && popularPosts.length <5 && risingPosts.length <5){
  hasMore=false;
  lazyloading.removeListener(onscroll);
}

// lastScore = popularPosts.last['score'];
// recentPosts.sort((a, b){
//   DateTime aCreated = DateTime.parse(a['created_at']);
//   DateTime bCreated = DateTime.parse(b['created_at']);
//   return bCreated.compareTo(aCreated);
// });
// lastCreated = recentPosts.last['created_at'];


setState(() {
  isLoading=false;
});
// print('done');
// print('recent: $recentPosts');
// print('pop: $popularPosts');
// print('rising: $risingPosts');
// print('stories: $stories');
  }

  @override
  Widget build (BuildContext context){


// final slideData = [
//   {'slide':1, "story_id":3 , "type":"start", 'id':1,  'subslide':null , 
// 'next_slide_id':2},

//     {'slide':2, "story_id":3, "type":"choice", 'id':2 , 
//   'subslide':null},
    
//               {'slide':3,"story_id":3 , "type":"text", 'next_slide_id':4,
//               'id':7 ,
//               'text':'testing'},
//                {'slide':4,"story_id":3 , "type":"text", 'id':3, 'subslide':null, },
//                   {'slide':4,"story_id":3 , "type":"text", 'id':3, 'subslide':null},
      
//                     {'slide':5,"story_id":3 , "type":"text", 
//               'id':7 , 
//            },
//   ];

//   final optionData = [
//     { 
//       'slide_id':2, 'story_id':3, 'next_slide_id':2, 'type':'text', 'text':'Option 1', 'left':0.1, 'top':0.3, 
//       "img":null, 'width':null, 'height':null, 'size':23, "lives":-3,
//     },
//      { 
//       'slide_id':2, 'story_id':3, 'next_slide_id':3, 'type':'text', 'text':'Option 2', 'left':0.1, 'top':0.6,
//        "img":null,  'width':null, 'height':null, 'size':23, "lives":null
//     },
//      { 
//       'slide_id':2, 'story_id':3, 'next_slide_id':4, 'type':'text', 'text':'Option 3', 'left':0.6, 'top':0.3,
//        "img":null,  'width':null, 'height':null, 'size':23, "lives":null
//     },
//      { 
//       'slide_id':2, 'story_id':3, 'next_slide_id':3, 'type':'text', 'text':'Option 4', 'left':0.6, 'top':0.6,
//        "img":null,  'width':null, 'height':null, 'size':23, "lives":null
//     },
//      { 
//       'slide_id':4, 'story_id':3, 'next_slide_id':5, 'type':'text', 'text':'Option 1', 'left':0.03, 'top':0.2, "lives":null ,
//       "img":'https://media-photos.depop.com/b1/28697598/3276349821_815a17b8ad60432e9af1421d6e9c9a8b/P0.jpg', 'width':140, 'height':140, 'size':23
//     },
//      { 
//       'slide_id':4, 'story_id':3, 'next_slide_id':5, 'type':'text', 'text':'Option 2', 'left':0.03, 'top':0.5,"lives":2,
//        "img":'https://media-photos.depop.com/b1/33899437/3277209918_e8877da6872440eeb08f8b27a6f3f305/P0.jpg',  'width':140, 'height':140, 'size':23
//     },
//      { 
//       'slide_id':4, 'story_id':3, 'next_slide_id':5, 'type':'text', 'text':'Option 3', 'left':0.5, 'top':0.2,"lives":null,
//        "img":'https://media-photos.depop.com/b1/28226893/3276531614_7526dd0834e94855802ba5287ac5cd6b/P0.jpg',  'width':140, 'height':140, 'size':23
//     },
//      { 
//       'slide_id':4, 'story_id':3, 'next_slide_id':5, 'type':'text', 'text':'Option 4', 'left':0.5, 'top':0.5,"lives":null,
//        "img":'https://media-photos.depop.com/b1/43038225/3268132790_2e33feac9cfd4c558f240bf056217058/P0.jpg',  'width':140, 'height':140, 'size':23
//     },
//   ];


  return Scaffold(
  
// backgroundColor: const Color.fromARGB(255, 248, 248, 248)
backgroundColor:  const Color.fromARGB(255, 248, 248, 248)
,
    body: RefreshIndicator(
      onRefresh: () async {
    loadStories();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: 
                    Stack(
                       children: [
                        Positioned(
                          left: 0,
                          child: GestureDetector(
                            onTap: (){
            Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
    transitionDuration: Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1, 0.0); 
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  ),
);
                            },
                            child:
                            
                         Container(
                              
                                  decoration:const  BoxDecoration(
                                    color: Color.fromARGB(255, 195, 166, 246) ,
                                    shape: BoxShape.circle
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: const Center(child: Icon(CupertinoIcons.search, size: 26, fontWeight: FontWeight.bold, 
                                    color:  Color.fromARGB(255, 255, 255, 255), )),
                                  ),
                                ),),
                        
                        ),
                          if (user != null)
                            Positioned(
                          right: 0,
                        
                          child: GestureDetector(
                            onTap: (){
                              hasNotification=false;
                              setState(() {
                                
                              });
         Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Notifications(
                                      listen4Notifications: listen4Notifications,
                                          
                                          ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                            },
                            child:
                            
                             Container(
                              
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 221, 201, 255) ,
                                    shape: BoxShape.circle
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                      
                                    const    Center(child: Icon(Icons.notifications, size: 26, fontWeight: FontWeight.bold, 
                                        color: Color.fromARGB(255, 255, 255, 255), )),
                                      hasNotification ?     Positioned(
                                          right: 3,
                                          top:1,
                                          child: 
      Container(
                                          width:8,
                                          height: 8,
                                          decoration: 
                                     BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle
              
                                     ),
                                        )) : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),),
                        
                        ),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    const     SizedBox(height: 60,),
                          GestureDetector(
                            onTap: (){
                                     Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                            },
                            child: Text('Stories For You',  style: TextStyle(
                              color:   const Color.fromARGB(255, 255, 127, 170),
                              fontWeight: FontWeight.bold,
                              fontSize: 34,
                              fontFamily: 'Poppins',
                             )),
                          ),
                           SizedBox(height: 20,),
                          Expanded(
                             child: 
                             isLoading ? Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 195, 166, 246)), ) :
                             stories.isEmpty ?
                              Center(child: Column(
                     
                     children: [
                      SizedBox(height: 100,),
                      
                       Text('No New Stories', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                          fontSize: 28)),
                                          SizedBox(height: 10,),
                                           Text('You have seen all the stories currently availible. Check again later.',
                                           textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: 'Poppins',
                                            color: const Color.fromARGB(255, 0, 0, 0), 
                                          fontSize: 18)),
                     ],
                   )) :
                             Padding(
                                 padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height * 0.095)),
                               child: PageView.builder(
                                onPageChanged: (value){
                                 viewedStories.add(stories[value]);
                                },
                               controller: lazyloading,
                                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing:3,
                                // childAspectRatio: 0.6
                                // ),
                                scrollDirection: Axis.vertical,
                                itemCount: stories.length,
                                itemBuilder: (context, index){
                               return   
                                   Padding(
                                                                     padding: const EdgeInsets.only(bottom: 20),
                                                                     child:
                                      
                                      
                                      GestureDetector(
                                          onTap: () async {
                                            
                                            
                                            // final hasLiked = user == null ? []: await supabase.from('likes').select().eq('target_id', stories[index]['id'])
                                            // .eq('user_id', supabase.auth.currentUser?.id ??0);
                                            // final slideData = await supabase.from('slide').select().eq('story_id', stories[index]['id']);
                                            // final optionData = await supabase.from('options').select().eq('story_id', stories[index]['id']);
                                            final results = await Future.wait([
                                   
                                   supabase.from('slide').select().eq('story_id', stories[index]['id']),
                                   supabase.from('options').select().eq('story_id', stories[index]['id']),
                                   if (user == null)  Future.value([]) else supabase.from('likes').select().eq('target_id', stories[index]['id'])
                                            .eq('user_id', supabase.auth.currentUser?.id ??0),
                                            supabase.from('story').select('comments, likes').eq('id', stories[index]['id']),
                                            ]
                                            
                                            );
                                              Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(
                                                     data:{...stories[index], 'likes':results[3][0]['likes'], 'comments':results[3][0]['comments']}, 
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
                                          child: Center(
                                            child: SizedBox(
                                              child: AspectRatio(
                                                aspectRatio:10/16,
                                                child: Container(
                                               // width: double.infinity, 
                                                                                        
                                                decoration: BoxDecoration(
                                                  image: (stories[index]['hasCover']??false) ? DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: 
                                                  
                                                  NetworkImage(stories[index]['cover'])) : null,
                                                border: Border.all(color: const Color.fromARGB(255, 195, 166, 246)),
                                                color: 
                                                  Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                                child: (stories[index]['hasCover']??false) ?  null :
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(stories[index]['title'] ?? '', style: TextStyle(fontFamily: 'Poppins', color: 
                                                     const Color.fromARGB(255, 246, 95, 145),
                                                     fontWeight: FontWeight.bold,
                                                    fontSize: 35),),
                                                  ),
                                                ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      
                                   
                                                                     
                                                                   );
                                             }),
                             ),
                           ),
                            //  Padding(
                            //     padding: const EdgeInsets.only(bottom: 20),
                            //     child: Column(
                            //       children: [
                            //         Expanded(
                            //           flex: 8,
                            //           child: GestureDetector(
                            //             onTap: () {
                            //                 Navigator.of(context).push(
                            //           PageRouteBuilder(
                            //             pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(),
                            //             transitionDuration: Duration.zero,
                            //             reverseTransitionDuration: Duration.zero,
                            //           ),
                            //                                 );
                            //             },
                            //             child: Container(
                            //             width: double.infinity, 
                                      
                            //             decoration: BoxDecoration(
                            //             border: Border.all(color: Colors.white),
                            //             color: const Color.fromARGB(255, 245, 205, 218), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                            //             child: Padding(
                            //               padding: const EdgeInsets.all(15),
                            //               // child: Align(
                            //               //   alignment: Alignment.bottomLeft,
                            //               //   child: Text(data[index]['Title'] ?? '', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold,
                            //               //   fontSize: 26),),
                            //               // ),
                            //             ),
                            //             ),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           flex: 2,
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            //               color: Colors.white
                            //             ),
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(left: 9.0),
                            //               child: Column(
                            //                 children: [
                            //               SizedBox(height: 10,),
                            //                     Align(
                            //                       alignment: Alignment.topLeft,
                            //                       child: Text(data[index]['Title'] ?? '', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                            //                                                        fontSize: 14),),
                            //                     ),
                            //                 ]),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   );
                                  
                         
                                         
                           
                         ],),
                       ],
                     )
            ),
          ),
        ),
      ),
    ));}}