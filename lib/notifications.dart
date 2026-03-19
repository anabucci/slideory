
import 'package:fashion/details.dart';
import 'package:fashion/main.dart';
import 'package:flutter/cupertino.dart';
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
    home: Notifications(),
  ));
}


class Notifications extends StatefulWidget {
 final dynamic listen4Notifications;
  const Notifications({super.key, this.listen4Notifications,});


  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController lazyloading = ScrollController();
  bool hasMore = false;
  bool isLoading = true;
  @override
void initState(){
  fetchData();

   lazyloading.addListener((){

if (lazyloading.position.pixels >=  (lazyloading.position.maxScrollExtent)){
 if (hasMore) loadAfterScrolling();
}
    });
  super.initState();
}
  bool isBasic  = true;
  dynamic lastCreatedAt;
  void fetchData() async {
    
     await supabase.from('notifications').update({'seen':true}).not('seen', 'is', true).select();

    final id = supabase.auth.currentUser?.id;
    // final likeData = await supabase.from('likes').select().eq('target_user', id??0).order('created_at', ascending: false).limit(5);
    // final commentReply = await supabase.from('comments').select().eq('reply_author', id??0).order('created_at', ascending: false).limit(5);
    // final commentPost = await supabase.from('comments').select().eq('post_author', id??0).order('created_at', ascending: false).limit(5);
      final notifis = await supabase.from('notifications').select().eq('target_user', id??0).order('created_at', ascending: false).limit(10);
 
    //   commentReply.sort((a,b){
    //   final aCreatedAt = DateTime.parse(a['created_at']);
    //      final bCreatedAt = DateTime.parse(b['created_at']);
    //      return bCreatedAt.compareTo(aCreatedAt) ;
    // });
    // commentPost.sort((a,b){
    //   final aCreatedAt = DateTime.parse(a['created_at']);
    //      final bCreatedAt = DateTime.parse(b['created_at']);
    //      return bCreatedAt.compareTo(aCreatedAt) ;
    // });
    // lastCreatedAt = [likeData.first, commentReply.first, commentPost.first ];
    // final altLike = likeData.map((e)=>{'type':'like', 'id':e['id'], 'username':e['username']});
    // final altReply = commentReply.map((e)=>{'type':'cmnt_reply', 'id':e['id'], 'username':e['username']});
    // final altPost = commentPost.map((e)=>{'type':'cmnt_post', 'id':e['id'], 'username':e['username']});
    // data = [...altLike, ...altReply, ...altPost];
    // if (likeData.length <5 && commentReply.length<5 && commentPost.length <5){
    //   hasMore=false;
    // }
    lastCreatedAt = notifis.isEmpty ? [] : [notifis.last['created_at']];
     data = [...notifis,];
    if (notifis.length <10){
      hasMore=false;
    }
setState(() {
  isLoading=false;
});
  }
  loadAfterScrolling() async{
  final id = supabase.auth.currentUser?.id;
    // final likeData = await supabase.from('likes').select()
    // .lt('created_at', lastCreatedAt[0])
    // .eq('target_user', id??0)
    
    // .order('created_at', ascending: false)
    
    // .limit(5)
    
    // ;
    // final commentReply = await supabase.from('comments').select().eq('reply_author', id??0)
    // .lt('created_at', lastCreatedAt[1]).limit(5)
    // .order('created_at', ascending: false);
    // final commentPost = await supabase.from('comments').select().eq('post_author', id??0)
    // .lt('created_at', lastCreatedAt[2])
    // .order('created_at', ascending: false).limit(5);
     final notifis = await supabase.from('notifications').select()
    .lt('created_at', lastCreatedAt[0])
    .eq('target_user', id??0)
    .order('created_at', ascending: false)
    
    .limit(10)
    ;
    // likeData.sort((a,b){
    //   final aCreatedAt = DateTime.parse(a['created_at']);
    //      final bCreatedAt = DateTime.parse(b['created_at']);
    //      return bCreatedAt.compareTo(aCreatedAt) ;
    // });
    //   commentReply.sort((a,b){
    //   final aCreatedAt = DateTime.parse(a['created_at']);
    //      final bCreatedAt = DateTime.parse(b['created_at']);
    //      return bCreatedAt.compareTo(aCreatedAt) ;
    // });
    // commentPost.sort((a,b){
    //   final aCreatedAt = DateTime.parse(a['created_at']);
    //      final bCreatedAt = DateTime.parse(b['created_at']);
    //      return bCreatedAt.compareTo(aCreatedAt) ;
    // });
   
    // lastCreatedAt = [likeData.first, commentReply.first, commentPost.first ];
    // final altLike = likeData.map((e)=>{'type':'like', 'id':e['id'], 'username':e['username']});
    // final altReply = commentReply.map((e)=>{'type':'cmnt_reply', 'id':e['id'], 'username':e['username']});
    // final altPost = commentPost.map((e)=>{'type':'cmnt_post', 'id':e['id'], 'username':e['username']});
    // data = [...altLike, ...altReply, ...altPost];
    // if (likeData.length <5 && commentReply.length<5 && commentPost.length <5){
    //   hasMore=false;
    // }
    lastCreatedAt = notifis.isEmpty ? [] : [notifis.last['created_at']];
     data = [data, ...notifis];
    if (notifis.length <10){
      hasMore=false;
    }
setState(() {
  
});
  }
  final supabase = Supabase.instance.client;
  dynamic data = [{'type':'like', 'username':'audrey'}, {'type':'cmnt', 'username':'nina'}];
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
                      Positioned(
                          left: 0,
                          top: 10,
                          child: GestureDetector(
                            onTap: (){
                              if (Navigator.canPop(context)){
                                Navigator.pop(context);
                                if (widget.listen4Notifications != null){
                                  widget.listen4Notifications();
                                }
                              } else {
           Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 0,),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                              }
                            },
                            child:
                            
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
                                ),),
                        
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                     
                                  SizedBox(height: 70,),
                     
                     Text('Notifications', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0)
                                                   //     const Color.fromARGB(255, 195, 166, 246)
                                                        , fontWeight: FontWeight.bold,
                                                                                           fontSize: 35),),
                                                                                           
                                                                                           SizedBox(height: 20,),
                                isLoading ?
           Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 195, 166, 246)))
          
                                  :
                                  data.isEmpty ?  Center(child: Column(
                                
                     children: [
                      SizedBox(height: 70,),
                       Icon(Icons.search_off, color:const Color.fromARGB(255, 195, 166, 246), size: 60, ),
                       SizedBox(height: 10,),
                       Text('No Notifications Yet', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                          fontSize: 26))
                     ],
                   )) :
                                    RefreshIndicator(
                                     onRefresh: () async{
                                 
                                      fetchData();
                                    },
                                    child: SizedBox(
                                    height: MediaQuery.of(context).size.height*0.7,
                                    child: 
                                                                  
                                    ListView.builder(
                                                            
                                                              controller: lazyloading,
                                                              itemCount:data.length,
                                                              itemBuilder: (context, index){
                                                             return   
                                                                 Padding(
                                                                padding: const EdgeInsets.only(top: 20),
                                                                child:
                                      
                                      
                                      GestureDetector(
                                          onTap: () async {
                                            
                                          //                                    final slides = await supabase.from('slide').select().eq('story_id', cmntId);
                                          // final options = await supabase.from('options').select().eq('story_id', cmntId);
                                          //  final story = await supabase.from('story').select().eq('id', cmntId);
                                       
                                      final cmntId = data[index]['reply_id'];
                                             
                final hasLiked = await supabase.from('likes').select().eq('target_id', data[index]['target_id'])
                .eq('user_id', supabase.auth.currentUser?.id ??0);
                 final dataStory = await supabase.from('story').select().eq('id', data[index]['target_id']);
                final slideData = await supabase.from('slide').select().eq('story_id', data[index]['target_id']);
                final optionData = await supabase.from('options').select().eq('story_id', data[index]['target_id']);
                
                                              Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(
                                    optionData: optionData, slideData: slideData, data:dataStory[0],hasLiked: hasLiked.isNotEmpty,
                                      // {"id":3,
                                      // 'title':"POV: You're a teenager in the 2000s", 'tags':['ocean', 'beach'],
                                      // "username":"euphroic",
                                      // 'likes':14,
                                      // "lives":3, 'storytype':"Basic",
                                    
                                      // "authorid":'11',},
                                       cmnntId: data[index]['type'] == 'like' ? null: cmntId,
                                    
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                                          },
                                          child: Container(
                                          width: double.infinity, 
                                        
                                          decoration: BoxDecoration(
                                        
                                          color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                   Container(
                                                        width: 60,
                                                        height:60,
                                                        decoration: BoxDecoration(
                                                   shape: BoxShape.circle,
                                                      
                                                          color:  
                                                            data[index]['type'] == 'like' ?  const Color.fromARGB(255, 255, 218, 230):
                                                         //   const Color.fromARGB(255, 244, 237, 255),
                                                          const Color.fromARGB(255, 237, 249, 255),
                                                        ),
                                                        child: Center(child: Icon(data[index]['type'] == 'like' ? Icons.favorite_border : CupertinoIcons.ellipses_bubble,
                                                        color:     data[index]['type'] == 'like' ?  const Color.fromARGB(255, 246, 95, 145):
                                                        //  const Color.fromARGB(255, 190, 156, 250)
                                                      const Color.fromARGB(255, 156, 212, 250)      
                                                          
                                                          ,  size: 30,
                                                        ))),
                                                         
                                                           SizedBox(width: 25,),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width*0.6,
                                                    
                                                    child: Text('${data[index]['username']} ${data[index]['type'] == 'like' ? 'liked your post' : 
                                                    data[index]['type'] == 'comment_reply' ? 
                                                    'replied to your comment' : 'commented on your post'
                                                    }', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), 
                                                    fontSize: 19),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),
                                      
                                                                 
                                                                
                                                              );
                                             }),
                                                                  ),
                                  )
                                    ],
                                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}