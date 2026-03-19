import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:fashion/profile.dart';
import 'package:fashion/storiesforyou.dart';
import 'package:fashion/tagsearch.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DetailsPage(),
  ));
}
class DetailsPage extends StatefulWidget {
  
final dynamic data;
final dynamic slideData;
final dynamic optionData;
final dynamic cmnntId;
final dynamic hasLiked;
  const DetailsPage({super.key, this.data, this.slideData, this.optionData, this.hasLiked, this.cmnntId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final supabase = Supabase.instance.client;
int? lives;
void preLoadImgs(){
//dynamic nextSlide =   widget.slideData.where((e)=> e['slide'] == currentSlide).first['next_slide_id']; 
List nextSlide =   widget.optionData.where((e)=> e['slide_id'] == currentSlide).map((e)=>e['next_slide_id']).toList(); 

// if (nextSlide.any((e)=> int.tryParse(e.toString()) == null)){
 if (widget.data['storytype'] == 'Basic'){
 
  final next = widget.slideData.where((e)=>e['slide'] == currentSlide).toList()[0]['id'];
 
  List subslides = widget.optionData.where((e)=>e['slide_id'] ==  currentSlide && e['type'] == 'img').map((e)=>e['id']).toList();

  for (final nextslide in nextSlide.where((e)=> int.tryParse(e.toString()) == null)){

  dynamic subslide = widget.slideData.where((e)=>e['slide'] ==  currentSlide && e['subslide'] == nextslide).toList();
  if (subslide == null || subslide.isEmpty ){

  } else {
   
  precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/${subslide[0]['id']}.png')), context);
  
  }
  }

  precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/$next.png')), context);
  for (final img in subslides){

    precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/$img.png')), context);
  }
} else {
 
  final nextSlideId= widget.slideData.where((e)=>e['slide']==currentSlide).toList()[0]['next_slide_id'];
  
  if (nextSlideId != null){
    final next = widget.slideData.where((e)=>e['slide']==int.tryParse(nextSlideId.toString())).toList()[0]['id'];
precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/${next}.png')), context);

 for (final option in widget.optionData.where((e)=>e['slide_id'] ==next).toList()){
    if (option['type']=='img'){
    precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/${option['id']}.png')), context);
    }
    }
  } else {
 for (final opts in nextSlide){
   final next = widget.slideData.where((e){ 
    return e['slide'] ==int.tryParse(opts);}).toList();

      precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/${next[0]['id']}.png')), context);
  
  for (final option in widget.optionData.where((e)=>e['slide_id'] == int.tryParse(opts.toString()))){
    
    if (option['type']=='img'){
    precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/${option['id']}.png')), context);
    }
  }}
  }
// if (nextSlide.any((e)=> int.tryParse(e.toString()) != null)){

//  }
}
// if (nextSlide.any((e)=> int.tryParse(e.toString()) != null)){
// if (nextSlide.any((e)=> int.tryParse(e.toString()) != null)){
//  for (final opts in nextSlide.where((e)=>int.tryParse(e.toString()) != null)){
//   for (final option in widget.optionData.where((e)=>e['slide_id'] == nextSlide)){
    
//   final next = widget.slideData.where((e){ 
//     return e['slide'] ==int.tryParse(option['next_slide_id']);}).toList();

//       precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/${next[0]['id']}.png')), context);
  
//   for (final option in widget.optionData.where((e)=>e['slide_id'] ==int.tryParse(option['next_slide_id'])).toList()){
//     if (option['type']=='img'){
//     precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/${option['id']}.png')), context);
//     }}
// }
//  }
// }
// if (int.tryParse(nextSlide.toString()) == null ){
 
//   final next = widget.slideData.where((e)=>e['slide'] == currentSlide+1).toList().first['id'];
//   List subslides = widget.optionData.where((e)=>e['slide_id'] ==  currentSlide+1 && e['type'] == 'img').map((e)=>e['id']).toList();

//   precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/$next.png')), context);
//   for (final img in subslides){
    
//     precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/$img.png')), context);
//   }
 
// } else {
//   for (final option in widget.optionData.where((e)=>e['slide_id'] == nextSlide)){
    
//   final next = widget.slideData.where((e){ 
//     return e['slide'] ==int.tryParse(option['next_slide_id']);}).toList();

//       precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('slides/${next[0]['id']}.png')), context);
  
//   for (final option in widget.optionData.where((e)=>e['slide_id'] ==int.tryParse(option['next_slide_id'])).toList()){
//     if (option['type']=='img'){
//     precacheImage(NetworkImage(supabase.storage.from('stories').getPublicUrl('options/${option['id']}.png')), context);
//     }}
// }
// }
}
bool hasSaved = false;
int commentsAdded = 0;
bool reachedEnding = false;  
final user = Supabase.instance.client.auth.currentUser?.id;
Map replyMap = {};  
String convertAmnt(int value){
  if (value >= 1000000) {
    double result = value / 1000000;
    return result % 1 == 0
        ? '${result.toInt()}M' : '${result.toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    double result = value / 1000;
    return result % 1 == 0
        ? '${result.toInt()}K' : '${result.toStringAsFixed(1)}K';
  } else {
    return value.toString();
  }
}

int latestId =9;

bool canComment = true;
ScrollController lazyLoading = ScrollController();
bool loadingDel = false;
//  void delStory(){
//     showDialog(context: context, builder: (context) {
      
//       return AlertDialog(
//         insetPadding: EdgeInsets.zero,
//         backgroundColor: Colors.transparent,
//         content: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
//             child: SizedBox(
//               width: width*0.9,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//               children: [
              
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color.fromARGB(255, 255, 184, 179)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Center(child: Icon(Icons.error, color: Colors.red, size: 30,),),
//                   ),
                
//                 ),
//                 SizedBox(height: 10,),
//                 Text('Delete Story', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),),
//                 SizedBox(height: 10,),
//                 Text('Are you sure you want to delete this story? This action cannot be undone.',
//               textAlign: TextAlign.center,
//                  style: TextStyle(
//                   fontSize: 15,
//                   fontFamily: 'Poppins', color: const Color.fromARGB(255, 107, 107, 107)),),
//                 SizedBox(height: 25,),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                                 child: Padding(
//                   padding: const EdgeInsets.all(11),
//                   child: Center(
//                     child: Text('Cancel',style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), ),),
//                   ),
//                                 ),
//                   ),
//                 ),
                                 
//                                  SizedBox(height:  10,),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     if (loadingDel){
//                                       loadingDel=true;
//                                   await supabase.from('story').delete().eq('id', widget.data['id']);
//                                   await supabase.from('options').delete().eq('story_id', widget.data['id']);
//                                   await supabase.from('slide').delete().eq('story_id', widget.data['id']);
//                                    await supabase.from('comments').delete().eq('story_id', widget.data['id']);
//                                    Toast.show(context, 'Story deleted sucessfully.', false);
//                                      Navigator.of(context).push(
//                                       PageRouteBuilder(
//                                         pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 0,),
//                                         transitionDuration: Duration.zero,
//                                         reverseTransitionDuration: Duration.zero,
//                                       ),
//                                                             );
//                                     }
// loadingDel=false;
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                     color: Colors.red,
//                                                   borderRadius: BorderRadius.circular(10)
//                                     ),
//                                                             child: Padding(
//                                   padding: const EdgeInsets.all(11),
//                                   child: Center(
//                                     child: 
//                                     loadingDel ? CircularProgressIndicator(color: Colors.white,) :
//                                     Text('Delete',style: TextStyle(fontFamily: 'Poppins', color: Colors.white),),
//                                   ),
//                                                             ),
//                                   ),
//                                 ),
//               ],
              
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//  void delCmnt(id, hasReplies, repliedTo){
//     showDialog(context: context, builder: (context) {
      
//       return AlertDialog(
//         insetPadding: EdgeInsets.zero,
//         backgroundColor: Colors.transparent,
//         content: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
//             child: SizedBox(
//               width: width*0.9,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//               children: [
              
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color.fromARGB(255, 255, 184, 179)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Center(child: Icon(Icons.warning, color: Colors.red, size: 30,),),
//                   ),
                
//                 ),
//                 SizedBox(height: 10,),
//                 Text('Delete Comment', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),),
//                 SizedBox(height: 10,),
//                 Text('Are you sure you want to delete this comment?',
//               textAlign: TextAlign.center,
//                  style: TextStyle(
//                   fontSize: 15,
//                   fontFamily: 'Poppins', color: const Color.fromARGB(255, 107, 107, 107)),),
//                 SizedBox(height: 20,),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: Text('Cancel',style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), ),),
//                   ),
//                                 ),
//                   ),
//                 ),
                                 
//                                  SizedBox(height:  10,),
//                                 GestureDetector(
//                                   onTap: () async {
                                    
//                                     if (hasReplies){
                                    
// await supabase.from('comments').update({'author_id':null, 'username':null, 'content':null}).eq('id', id);
// int index = cmnts.indexWhere((e)=>e['id']==id);
// cmnts[index] = {...cmnts.where((e)=>e['id']==id).first, 'author_id':null, 'username':null, 'content':null};
// for (final value in replyMap.values){
//   for (int i=0; i<value.length; i++){
//     if (value[i]['id'] == id){
//       replyMap[value][i] =  {...value[i], 'author_id':null, 'username':null, 'content':null};
//     }
//   }
// }


//                                     } else {
//                                      await supabase.from('comments').delete().eq('id', id); 
                    
//                       if (repliedTo != null){
//                          await supabase.from('comments').update({'hasReplies':false}).eq('id', repliedTo);
//                                     }}
// Navigator.pop(context);
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                     color: Colors.red,
//                                                   borderRadius: BorderRadius.circular(10)
//                                     ),
//                                                             child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Center(
//                                     child: Text('Delete',style: TextStyle(fontFamily: 'Poppins', color: Colors.white),),
//                                   ),
//                                                             ),
//                                   ),
//                                 ),
//               ],
              
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
List cmnts = [];

  FocusNode openKeyboard = FocusNode();
  void report(type, id){
  String selectedCat = 'Select...';
List categories=['Select...', 'Harrasment', 'Violence', 'Sexual content', 'Promoting illegal activity', 'Spam', 'Copyright violation'] ;
     showModalBottomSheet(context: context,
                               
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
                                             Text('Please select a reason for reporting this $type.', 
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
                                        try {
                                        // final prefs = await SharedPreferences.getInstance();
                                      await supabase.from('report').insert({'type':type, 'target_id':id.toString(),
                                      //  'user_id':prefs.getString(
                                      //   'device_id'
                                      // )
                                   
                                      // , 
                                      'issue':selectedCat
                                      });
                                        Navigator.pop(context);
                                            Toast.show(context, 'Thank you. We will look into this issue shortly.',false)   ;  
                                      } 

                                       catch (e){
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

  @override
 
void dispose(){
  openKeyboard.dispose();
  lazyLoading.dispose();
  super.dispose();
}
void loadMainReplies(replyMap, index, root, useState) async{
                    if (!replyMap.keys.contains(root[index]['id'])){
                      List replies = cmnts.where((e)=>  e['replied_to'] == root[index]['id']).toList();
                     final repleid = await supabase.from('comments').select().eq('replied_to', root[index]['id']) ;
                  replyMap[root[index]['id']] =replies.isEmpty ? repleid : replies;
            if (replies.isEmpty){
              cmnts.addAll(repleid);
            }
                  } else {
                    replyMap.removeWhere((key, value)=> key == root[index]['id']);
                  }
                useState(() {
                   
                 });
                  }
                  
void openComments(){
  

  
void addComment(isReply, cmntController, cmntid, replyMap, useState) async  {
  
  if (user==null || !canComment || cmntController.isEmpty){
    return;
  }
       canComment = false;
        Timer(const Duration(seconds: 2), () {
          canComment = true;
        });
  //  List rep2 = replies;
   
  //                                       rep2.sort((a,b)=> b['id'].compareTo(a['id']) );
                                        
  //                                         List cmnt2 = cmnts;
  //                                       cmnt2.sort((a,b)=> b['id'].compareTo(a['id']));
                                      final id = supabase.auth.currentUser!.id;
                                      final getUsername = await supabase.from('profile').select('username').eq('user_id', id).maybeSingle();
                                    
                                    
                                     final insertCmnt = await supabase.from('comments').insert({
  'content':cmntController, 

  'story_id':widget.data['id'],
'hasReplies':false,
 'username':getUsername?['username'],
 'author_id':id,
//  'post_author':widget.data['author'],
//   "reply_author": isReply ? null : cmnts.where((e)=>e['id']==isReply).single['author'],
'replied_to':isReply == null ? null : int.tryParse(isReply), 
 }).select().single(); 
if ((((id != widget.data['author']) && (isReply== null || ( (cmnts.where((e)=>e['id']==int.tryParse(isReply)).singleOrNull?['author_id']) != id ))) ||
(id == widget.data['author'] && isReply != null &&( (cmnts.where((e)=>e['id']==int.tryParse(isReply)).singleOrNull?['author_id']) != id ))
)){
await supabase.from('notifications').insert({
'username':getUsername?['username'],
 'target_user': isReply == null ? widget.data['author'] :
  cmnts.where((e)=>e['id']==int.parse(isReply)).single?['author_id'],
  'reply_id':insertCmnt['id'],
  'target_id':widget.data['id'],
  'type':isReply == null ? 'comment_post' : 'comment_reply',
 });
}             
 print('ih2');
                 
                                          cmnts = [ {'content':cmntController,  'author_id':id,
                                          'username':getUsername?['username'] , 
                                          'hasReplies':false, 
                                        'id':insertCmnt['id'], 'replied_to':isReply == null ? null : int.tryParse(isReply)}, ...cmnts, 
                                          ];
                                          commentsAdded+=1;
                                      

                                        //    } 
                                        //    else
                                        //    { replies.insert(0,{'content':cmntController, 'story_id':3, 'author_id':5, 'cmnt_id':cmntid,
                                        // 'id':rep2.first['id']+1, 'replied_to': isReply == 'Main' ? null : int.parse(isReply!)
                                        
                                        //   });
                                          // supabase.from('comments').insert({'content':cmntController, 'story_id':widget.data['id'],
                                          // 'replied_to': int.parse(isReply!)
                                          //  });
                                        
latestId += 1;                              
if (isReply != null  && replyMap[cmntid] != null){

if (!(replyMap[cmntid].map((e)=>e['id']).contains(isReply))){
replyMap[cmntid].map((e)=>e['id'] == int.parse(isReply) ? {...e, 'hasReplies':true} :e).toList();
  int repliedToIdx = ((replyMap[cmntid]).toList().indexWhere((e) {
   
    return e['id'] == int.parse(isReply);
    }));
          cmnts =  cmnts.map((e){ 
           
           return e['id'] == int.parse(isReply) ? {...e, 'hasReplies':true} :e;}).toList();               
               replyMap[cmntid] = 
        repliedToIdx==-1 ? [    {'content':cmntController,'cmnt_id':cmntid, 'username':getUsername?['username'],
        'author_id':user,
                                        'id':insertCmnt['id'], 'replied_to': int.parse(isReply)
                                          }, ...replyMap[cmntid],]:
               [...replyMap[cmntid].take(repliedToIdx+1), 
                                    {'content':cmntController,  'cmnt_id':cmntid, 'username':getUsername?['username'],
                                        'id':insertCmnt['id'], 'replied_to':int.parse(isReply), 'author_id':user,
                                          }, ...replyMap[cmntid].skip(repliedToIdx+1)];
                    
             
}


} else if (replyMap[cmntid] == null && isReply!= null) {

replyMap[cmntid] = [ {'content':cmntController,'cmnt_id':cmntid,'author_id':user,
                                        'id':insertCmnt['id'], 'username':getUsername?['username'], 'replied_to': int.parse(isReply)
                                          }];
                                            cmnts =  cmnts.map((e){ 
           
           return e['id'] == int.parse(isReply) ? {...e, 'hasReplies':true} :e;}).toList();        
}

useState(() {
  
});
setState(() {
  
});
}

TextEditingController cmntController = TextEditingController();
bool hasListener = false;
String? isReply;
                                                 

int? cmntid;

  showModalBottomSheet(
  sheetAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 500)),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
     builder: (context){
          final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
return SizedBox(
    height: height*0.85,
  width: double.infinity,
  child: Padding(
 padding: EdgeInsets.only(
  bottom: MediaQuery.of(context).viewInsets.bottom ,
),
    child: StatefulBuilder(
      builder: (context, useState) {
        
          void loadCommentsAfterScrolling(useState) async{
         
    List newComments = await supabase.from('comments').select().eq('story_id',3).filter('replied_to',
                                                               'is', null).not('id', 'in', cmnts.map((e)=>e['id'])).limit(50);
  cmnts.addAll(newComments);
  if (newComments.length < 50){
    moreComments = false;
  }
  //     lazyLoading.removeListener((){if ((lazyLoading.offset >=(lazyLoading.position.maxScrollExtent))){
  
  //  if (moreComments) loadCommentsAfterScrolling(useState);
  // }
  //     });
   useState(() {
     
   });                                                           
  }
  
  if (!hasListener){
    hasListener=true;
  lazyLoading.addListener((){
  if ((lazyLoading.offset >=(lazyLoading.position.maxScrollExtent))){
  
   if (moreComments) loadCommentsAfterScrolling(useState);
  }
  });
    
  }
        return GestureDetector(
            onTap:(){
  isReply = null;
  useState((){});
    },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:  ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: height * 0.85,
    ),      child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                 Text('Comments', style: TextStyle(fontFamily: 'Poppins', color: 
                                                           const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                              fontSize: 22),),
                                                                                              SizedBox(height: 40,),
                SizedBox(
                  height: height*0.6,
                  child: ListView.builder(
                    controller: lazyLoading,
                    itemCount: cmnts.where((e)=>e['replied_to'] == null).toList().length,
                    itemBuilder:(context, index) {
                      List onlyRootCmnts = cmnts.where((e)=>e['replied_to'] == null).toList();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                                    color:     const Color.fromARGB(255, 195, 166, 246).withAlpha(30)
                            ),
                                    child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: SizedBox(
                            width: double.infinity,
                          
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                                GestureDetector(
                   onTap: () async {
                    final data = await supabase.from('profile').select().eq('user_id', onlyRootCmnts[index]['author_id']??2).maybeSingle();
                   String banner =supabase.storage.from('profile').getPublicUrl('banner/${onlyRootCmnts[index]['author_id']}');
                  String picture = supabase.storage.from('profile').getPublicUrl('picture/${onlyRootCmnts[index]['author_id']}');
                                            Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
                                          
                                          // data: usernames[onlyRootCmnts[index]['author_id']]
                                          data: data, banner: banner, picture: picture,
                                          
                                          ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                                        },                                              
                                                  child: Text( 
                                                    onlyRootCmnts[index]['username']== null ? 'Comment Deleted' :
                                                    '@${onlyRootCmnts[index]['username']}', style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                   color:    const Color.fromARGB(255, 0, 0, 0) ),),
                                                ),
                                                 SizedBox(height: 5,),
                                      SizedBox(
                                        width: width-100,
                                        child: Text(onlyRootCmnts[index]['content'] == null ? 'This comment was deleted.' : '${onlyRootCmnts[index]['content']}', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, color:    const Color.fromARGB(255, 176, 138, 241) ),)),
                                      
                                    ],
                                  ),
                                  
                                  // Spacer(),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8),
                                  //   child: Icon(Icons.favorite),
                                  // )
                                ],
                              ),
                            ),
                          ),
                                    ),
                          ),
                         SizedBox(height: 10,),
                                      Row(
                                       
                                        children: [
                                          // if (cmnts.any((e)=>e['replied_to'] == onlyRootCmnts[index]['id']))
                                            if ((onlyRootCmnts[index]['hasReplies'] ?? false))
                                           SizedBox(width: 10,), 
                                              // if (cmnts.any((e)=>e['replied_to'] == onlyRootCmnts[index]['id']))
                                                   if ((onlyRootCmnts[index]['hasReplies'] ?? false))
                                         GestureDetector(
                                          onTap: (){
                                            useState((){
                  loadMainReplies(replyMap, index, onlyRootCmnts, useState);                 
                           });
                             useState((){});
                                          },
                                           child: Row(
                                           
                                            children: [
                                            Text('View Replies', style: TextStyle(fontFamily: 'Poppins',  fontSize: 15),),
                                            SizedBox(width: 2,)
                                            , Icon(replyMap.keys.contains(onlyRootCmnts[index]['id'])? Icons.keyboard_arrow_down : Icons.chevron_right, )
                                            ]),
                                         ),
                                           user == null ? SizedBox.shrink():
                                          SizedBox(width: 20,),
                                           user == null ? SizedBox.shrink():
                                          GestureDetector(
                                            onTap: (){
                                            
                                              FocusScope.of(context).requestFocus(openKeyboard);
                                              isReply=onlyRootCmnts[index]['id'].toString();
                                              cmntid=onlyRootCmnts[index]['id'];
                                               useState((){});
                                            },
                                            child: Text('Reply', style: TextStyle(fontFamily: 'Poppins',  color: const Color.fromARGB(255, 246, 95, 145), fontSize: 15),)),
                    
             if        (onlyRootCmnts[index]['author_id'] != user)
                    SizedBox(width: 20,),
                     if        (onlyRootCmnts[index]['author_id'] != user)
                                                 GestureDetector(
                                                  onTap: (){
                                                    report('comment', onlyRootCmnts[index]['id']);
                                                  },
                                                  child: Icon(Icons.flag_outlined, color: Colors.grey.shade400,))
                                        ],
                                      ), 
                                      
                      SizedBox(height: 10,),
                                      if (replyMap.keys.contains(onlyRootCmnts[index]['id'])) 
                                      IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 2,               
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                            SizedBox(width: 20,),
                                            Column(
                                              children: [
                                        ...replyMap[onlyRootCmnts[index]['id']].map((e) {
                                     
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                        e['replied_to'] == onlyRootCmnts[index]['id'] ? SizedBox.shrink() : Text('Replying to ${
                                        //  usernames[e['replied_to']]
                                        cmnts.where((er)=>e['replied_to']==er['id']).single['username'] 
                                          }',style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color:    const Color.fromARGB(255, 246, 95, 145) ),),
                                                                SizedBox(height: 10,),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                        color:     const Color.fromARGB(255, 195, 166, 246).withAlpha(30)
                                                            ),
                                        child: Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                            child: SizedBox(
                                                         width: width-111,
                                                          
                                                              child: Row(
                                                                // mainAxisAlignment: MainAxisAlignment.end,
                                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                                                
                                            
                                                    GestureDetector(
                  onTap: () async {
                    if (e['author_id'] != null){
                     final data = await supabase.from('profile').select().eq('user_id', e['author_id']??1).maybeSingle();
                   String banner =supabase.storage.from('profile').getPublicUrl('banner/${ e['author_id']}');
                  String picture = supabase.storage.from('profile').getPublicUrl('picture/${e['author_id']}');
                                            Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
                                        //  data: usernames[cmnts[index]['author_id']]
                                        banner: banner,
                                        picture: picture,
                                        data: data,
                                          ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                  }},                                                     
                                                      child: Text(e['username'] == null ? 'Comment Deleted' : '@${e['username']}', style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                       color:    const Color.fromARGB(255, 0, 0, 0) ),),
                                                    ),
                                                     SizedBox(height: 5,),
                                          SizedBox(
                                            width: width-111,
                                            child: Text(e['content'] == null ? 'This comment was deleted.' : '${e['content']}', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, color:    const Color.fromARGB(255, 176, 138, 241) ),)),
                                          
                                        ],
                                                                  ),
                                                                  
                                                                  // Spacer(),
                                                                  // Padding(
                                                                  //   padding: const EdgeInsets.only(bottom: 8),
                                                                  //   child: Icon(Icons.favorite),
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                        ),
                                                          ),
                                                          SizedBox(height: 10,),
                                        Row(
                                           
                                            children: [
                                        if (cmnts.where((em)=>em['id']==e['id']).singleOrNull?['hasReplies']??false)SizedBox(width: 10,),
                                            //  if (cmnts.any((er) => er['replied_to'] == e['id']))
                                            if (cmnts.where((em)=>em['id']==e['id']).singleOrNull?['hasReplies']??false)
                                             GestureDetector(
                                              onTap: () async {
                                               
                                               if (replyMap[onlyRootCmnts[index]['id']].map((e) => e['replied_to']).contains(e['id'])){
                                              
                                                List raw =  (replyMap[onlyRootCmnts[index]['id']] as List).toList();
                                              
                                            
                                               List replyChain = [];
                                               void removeCmmnts(reply){
                                               
                  List matches = raw.where((rawE) => rawE['replied_to']== reply).toList();
                  
                  if (matches.isNotEmpty){
                  for (final match in matches){
                    
                    replyChain.add(match['id']);
                    removeCmmnts(match['id']);
                    
                  }} else {
                     (replyMap[onlyRootCmnts[index]['id']] as List).removeWhere((er)=> replyChain.contains(er['id']));
                                          
                  }}
                                     
                                        removeCmmnts(e['id']);                                  
                    
                                               } else {
                                        int repliedToIdx =  (replyMap[onlyRootCmnts[index]['id']] as Iterable).toList().indexOf(e)+1;
                                     if ((cmnts.where((entry)=> entry['replied_to'] == e['id']).isEmpty)){
                                      final fetchCmnts = await supabase.from('comments').select().eq('replied_to', e['id']);
                                        replyMap[onlyRootCmnts[index]['id']] = [...(replyMap[onlyRootCmnts[index]['id']]).take(repliedToIdx), 
                                          ...(fetchCmnts
                                          ),
                                           ...(replyMap[onlyRootCmnts[index]['id']])
                                          .skip(repliedToIdx)
                                               
                                         ];
                                       cmnts.addAll(fetchCmnts);  
                                     } else {
                                        replyMap[onlyRootCmnts[index]['id']] = [...(replyMap[onlyRootCmnts[index]['id']]).take(repliedToIdx), 
                                          ...( 
                                          cmnts.where((entry)=> entry['replied_to'] == e['id'])
                                          
                                          ),
                                           ...(replyMap[onlyRootCmnts[index]['id']])
                                          .skip(repliedToIdx)
                                               
                                         ];
                                     }

                                    
                                      
                                          // replyMap[cmnts[index]['id']] = [...replyMap[cmnts[index]['id']], 
                                          // ...replies.where((entry)=> entry['replied_to'] == e['id'])
                                               
                                         // ];
                                          
                                          }
                                               useState((){  });
                                              },
                                              
                                               child: Row(
                                                children: [
                                                Text('View Replies', style: TextStyle(fontFamily: 'Poppins',  fontSize: 15),),
                                                SizedBox(width: 2,)
                                                , Icon(replyMap[onlyRootCmnts[index]['id']].map((e) => e['replied_to']).contains(e['id'])
                                                
                                                 ? Icons.keyboard_arrow_down : Icons.chevron_right, )
                                                ]),
                                             ),
                                             
                                               user == null   || e['author_id'] == null ? SizedBox.shrink():
                                              SizedBox(width: 20,),
                                            user == null || e['author_id'] == null ? SizedBox.shrink():
                                              GestureDetector(
                                                onTap: (){
                                                 FocusScope.of(context).requestFocus(openKeyboard);
                                                    isReply=e['id'].toString();
                                                    cmntid=onlyRootCmnts[index]['id'];
                                                     useState((){});
                                                },
                                                child: Text('Reply', style: TextStyle(fontFamily: 'Poppins',  color: const Color.fromARGB(255, 246, 95, 145), fontSize: 15),)),
 if        (e['author_id'] != user && e['author_id'] != null)
                                                 SizedBox(width: 20,),
                                                  if        (e['author_id'] != user)
                                               GestureDetector(
                                                  onTap: (){
                                                 
                                                    report('comment', e['id']);
                                                  },
                                                  child: Icon(Icons.flag_outlined, color: Colors.grey.shade400,))
                                                  
                                            ],
                                          ),  ]),
                                        );
                                        })
                                          ])
                                                      ],
                                                    ),
                                      )]),
                    );
                  },),
                    
                ),
                Spacer(),
                        if (user != null)
                Row(children: [
                     GestureDetector(
                      onTap: (){
                 isReply=null;
                                        
                      },
                       child: Container(
                                               height: 55,
                                              width:width *0.7,
                                              decoration: BoxDecoration(
                                               border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                               borderRadius: BorderRadius.circular(10) 
                                              ),
                                              
                                              child:  TextField(
                                              onSubmitted: (value){
                                                if (cmntController.text.isNotEmpty){
                                                String cmnt = cmntController.text;
                                         
                                                cmntController.clear();
                                               if (canComment ){
                                             
                                                addComment(isReply, cmnt, cmntid, replyMap, useState);
                                               }
                                                  
                                                useState(() {
                                                 isReply = null;
                  },);
                                                 }   },
                                                 maxLength: 150,
                                             maxLines: 1,
                                            // maxLength: 80,
                                            focusNode: openKeyboard,
                                            controller: cmntController,
                                            decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hint: Text(
                                              isReply != null ?'Reply...' :
                                              'Comment...', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                                           const Color.fromARGB(255, 111, 111, 111),
                                                                                                              fontSize: 15)),
                                            ),
                                            style: TextStyle(fontFamily: 'Poppins', color: 
                                                                           const Color.fromARGB(255, 0, 0, 0),
                                                                                                              fontSize: 16)
                                              ),
                                            ),
                     ) ,
                                          SizedBox(width: 20,),
                                          GestureDetector(
                                            
                                            onTap: (){
                                              if (cmntController.text.isNotEmpty){
                                              String cmnt = cmntController.text;
                                                cmntController.clear();
                                                 if ( canComment ){
                                        addComment(isReply, cmnt, cmntid, replyMap, useState);
                                                 }
                                        useState(() {
                                              isReply = null;
                                              },);
                                             } },
                  
                                            child: Container(
                                              
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(255, 255, 209, 224),
                                              ),
                                              child: Center(
                                                child: Padding(padding: EdgeInsets.all(12),
                                                child: Center(child: Icon(Icons.send_rounded, color:  const Color.fromARGB(255, 246, 95, 145),)),
                                                ),
                                              ),
                                            ),
                                          )
                    
                ],)
                
                ],
                ),
    ),
            ),
          ),
        );
      }
    ),
  ),
);
     }
     
     );
}
  int currentSlide = 1;
 
  String? subslide;
  bool hasLiked = true;
bool gameOVer = false;
bool gameOverShowEnding = false;

bool moreComments = true;

void handleNotification() async {
  List fullChain = [];
    
   void getChain(int currentId) async {
   
 final data = await supabase.from('comments').select().eq('id', currentId).maybeSingle();

 if ((data == null || data.isEmpty) || data['replied_to'] == null){
  fullChain.add(Map.from(data??{}));

   cmnts = cmnts.isEmpty ?  [...fullChain,...await supabase.from('comments').select().not('id', 'in', fullChain.map((e)=>e['id'])).eq('story_id', widget.data['id'])
                                                               //   .eq('story_id',3)
                                                                  .filter('replied_to',
                                                                   'is', null).limit(50)] : cmnts;

if (fullChain.length>1){
  int ogId = (fullChain.where((e)=> e['replied_to'] == null).single['id'] as int);
 replyMap[ogId] = fullChain.reversed.where((e)=> e['id'] != ogId).toList();
}

    openComments();
    setState(() {
      
    });
  return;
 } else {
   
      fullChain.add(Map.from(data));
 getChain(data['replied_to'] as int);
  
 }
    }  
 getChain(widget.cmnntId as int);
     
  
}
@override

void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
   preLoadImgs();
  });

  if (widget.cmnntId != null){
    handleNotification();
  
  }
  hasLiked = widget.hasLiked ?? false;

 
    super.initState();
  }
  @override
  Widget build (BuildContext context){
        final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final containerHeight = 500.00;
    final containerWidth = 370.00;
  

  return Scaffold(
  
  // backgroundColor: const Color.fromARGB(255, 248, 248, 248)
  backgroundColor: const Color.fromARGB(255, 248, 248, 248)
  ,
    body: SafeArea(
      child: SingleChildScrollView(
        
        child: Container(
          height: height > 880 ? height : 880,
           decoration: BoxDecoration(
              
                color: const Color.fromARGB(255, 248, 248, 248)
              ),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: 
                  Stack(
                    
                    children: [
                      
                      Positioned(
                        left: 20,
                       top: 20,
                        child: GestureDetector(
                          onTap: (){
                            if (Navigator.canPop(context)){
          Navigator.pop(context);
                            } else {
                                 Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => StoriesForYou(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                                        );
                            }
                          },
                          child: Container(
                              
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 205, 205, 205).withAlpha(50),
                                    shape: BoxShape.circle
                                  ),
                                  child: const Padding(
                                    padding:  EdgeInsets.all(6),
                                    child: Center(child: Icon(Icons.arrow_back, size: 23, 
                                    color:  Color.fromARGB(255, 0, 0, 0), )),
                                  ),
                                ),
                        )),
                         if        (widget.data['author'] != user)
                           Positioned(
                        right: 20,
                       top: 20,
                        child: GestureDetector(
                          onTap: (){
                          
                            report('story', widget.data['author']);
                          },
                          child: Container(
                              
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 205, 205, 205).withAlpha(50),
                                    shape: BoxShape.circle
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Center(child: Icon(Icons.flag_outlined, size: 23, 
                                    color:  Color.fromARGB(255, 0, 0, 0), )),
                                  ),
                                ),
                        )),
                       Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                                         Padding(
                                           padding: const EdgeInsets.only(left: 20, right: 20),
                                           child: SizedBox(
                                              
                                             child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Center(
                                                   child: SizedBox(
                                                    width: containerWidth,
                                                     child: Align(
                                                      alignment:  Alignment.topLeft,
                                                       child: Text('${widget.data['title']}', style: TextStyle(fontFamily: 'Poppins', color: 
                                                       const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                                                                          fontSize: height*0.028),),
                                                     ),
                                                   ),
                                                 ),
                                                 widget.data['tags'] == null || widget.data['tags'].isEmpty ? SizedBox.shrink() :
                                                                                  
                                           SizedBox(
                                         
                                               child: Column(
                                                 children: [
                                                    SizedBox(height: 10,),
Align(
   alignment:  width>700? Alignment.center:Alignment.centerLeft,
  child: SizedBox(
     width:   width>700?containerWidth:width-40,
                                                                                      height: 38,
                                                                                      child: ListView.builder(
                                                                                       scrollDirection: Axis.horizontal,
                                                                                        itemCount: widget.data['tags'].length,
                                                                                        itemBuilder: (context, index){
                                                                                        return Padding(
                                                                                                                 padding:  EdgeInsets.only(right: index == widget.data['tags'].length +1 ? 0 :10),
                                                                                                                 child: GestureDetector(
                                                                                                                                
                                                                                                                                   onTap: () {
                                                                                                                                 Navigator.of(context).push(
                                                                                                               PageRouteBuilder(
                                                                                                                 pageBuilder: (context, animation, secondaryAnimation) => TagSearch(tag: widget.data['tags'][index],),
                                                                                                                 transitionDuration: Duration.zero,
                                                                                                                 reverseTransitionDuration: Duration.zero,
                                                                                                               ),
                                                                                                );
                                                                                                                 },
                                                                                                                                
                                                                                                                               child: Container(
                                                                                                                               
                                                                                                                               decoration: BoxDecoration(
                                                                                                                                 border: Border.all(color: const Color.fromARGB(255, 190, 156, 250), width: 2),
                                                                                                                                 color:   const Color.fromARGB(255, 244, 237, 255),
                                                                                                                               
                                                                                                                                 borderRadius: BorderRadius.circular(20)
                                                                                                                               ),
                                                                                                                               child: Padding(
                                                                                                                                 padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                                                                                                                                 child: Center(child: Row(
                                                                                                                                   children: [
                                                                                                                                   
                                                                                                                                              Text('#${widget.data['tags'][index]}', style: TextStyle(fontFamily: 'Poppins', 
                                                                                                                                              decoration: TextDecoration.none,
                                                                                                                                              color:   const Color.fromARGB(255, 190, 156, 250), fontWeight: FontWeight.bold, fontSize: 14),),
                                                                                                                                              
                                                                                                                                   ],
                                                                                                                                 )),
                                                                                                                               ),
                                                                                        ),
                                                                                                                 ),
                                                                                                               );
                                                                                      }),
                                                                                    ),
),
                                                                    
                                                 ],
                                               ),
                                                                 
                                             ),
                                             SizedBox(height: 10,),
                                              
                                                                                GestureDetector(
                    onTap: () async {
                       final data = await supabase.from('profile').select().eq('user_id', widget.data['author']??1).maybeSingle();
       String banner =supabase.storage.from('profile').getPublicUrl('banner/${widget.data['author']}');
      String picture = supabase.storage.from('profile').getPublicUrl('picture/${widget.data['author']}');
                                            Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
                                       //   data: usernames[widget.data['author']]
                                         data: data, banner: banner, picture: picture, 
                                          ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                                            );
                                        },                                              
                                                                                  child: Center(
                                                                                    child: SizedBox(
                                                                                      width: containerWidth,
                                                                                      child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("@${widget.data['username'] ?? 'Anonymous'}",
                                                                                          
                                                                                          style: TextStyle(fontFamily: 'Poppins', color: 
                                                                                                                                   const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                          fontSize: 16),
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
          const SizedBox(height: 10,),
          
                          GestureDetector(
                            onHorizontalDragEnd: (details) async {
                              final vel = details.primaryVelocity ?? 0;
                              if (gameOVer || gameOverShowEnding || reachedEnding){} else {
                              if (vel > 0 && currentSlide>0 && widget.data['storytype'] == 'Basic' && widget.slideData.where((e)=>e['subslide']!=null).isEmpty ){
          
          setState(() {
          currentSlide--;
          });
                              }
          
                              if (vel<0 && widget.data['storytype'] == 'Basic' && widget.slideData.where((e) => e['slide'] == currentSlide && e['subslide'] == subslide).single['type'] != 'choice'){
      
          if ((currentSlide+1)==widget.slideData.where((e)=>e['subslide']==null).length && 
          widget.slideData.where((e)=>e['subslide']!=null && e['slide'] == currentSlide+1).isEmpty){
           
      
             currentSlide = currentSlide+1;
            subslide=null;
            reachedEnding=true;
            
            setState(() {
              
            });
            
          Toast.show(context, 'Ending reached!', false);
          try {
              await supabase.from('completion').insert({'story_id':widget.data['id']});
          } catch (e){
            
          }
      
          } else {
           setState(() {
          currentSlide = currentSlide+1;
          subslide=null;
          });
          
          }
        preLoadImgs();
                              }
                               if (vel<0 && widget.data['storytype'] != 'Basic' && widget.slideData.where((e) => e['slide'] == currentSlide && e['subslide'] == subslide).single['type'] != 'choice'){
        
             int? nextSlide =   widget.slideData.where((e)=> e['slide'] == currentSlide).first['next_slide_id']; 
                if (nextSlide ==null ){
                                     Toast.show(context, 'Ending reached!', false);
               reachedEnding=true;
                                           setState(() {
                                             
                                           });  
                                                    await supabase.from('completion').insert({'story_id':widget.data['id']});
                                           return;
                                  }
          if ( widget.slideData.where((er)=>er['slide']==nextSlide && er['type']!= 'choice' &&
                                               er['next_slide_id']==null).toList().isEmpty){
              
         
         
          setState(() {
          currentSlide =nextSlide;
          
          });
          
          } else {
            currentSlide=nextSlide;
            Toast.show(context, 'Ending reached!', false);
             reachedEnding=true;
                                         setState(() {
                                           
                                         });
         await supabase.from('completion').insert({'story_id':widget.data['id']});
          }
                             preLoadImgs();     }
                              }
                            },
                            child: Container(
                                width: containerWidth, 
                                               
                                height: containerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.black),
                             image: gameOVer ? null : DecorationImage(image: NetworkImage(supabase.storage.from('stories').getPublicUrl
                             ('slides/${widget.slideData.where((e)=>e['slide']==currentSlide && e['subslide']==subslide).single['id']}.png'))),
                                color:
                                
                                gameOVer ? Colors.red.withAlpha(100):
                                 const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                child:
                                gameOVer ? 
                               
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                 const   Text('Game Over', style: TextStyle(fontFamily: 'Poppins', color: 
                                               const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                  fontSize: 22),),
                                  const  SizedBox(height: 10,),
          
                                 const   Text('Oops! You ran out of lives.', style: TextStyle(fontFamily: 'Poppins', color: 
                                               const Color.fromARGB(255, 49, 49, 49), fontWeight: FontWeight.bold,
                                                                                  fontSize: 17), ),
                                const    SizedBox(height: 20,),
                                    GestureDetector(
                                      onTap: (){
                                        gameOVer=false;
                                        
                                        currentSlide=1;
                                        subslide=null;
                                        lives=widget.data['lives'];
                                        setState(() {
                                          
                                        });
                                      },
                                      child: Container(
                                        width: containerWidth-200,
                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text('Try Again', style: TextStyle(fontFamily: 'Poppins', color: 
                                                 const Color.fromARGB(255, 0, 0, 0),  fontWeight: FontWeight.bold,
                                                                                    fontSize: 16),),)
                                        ),
                                      ),
                                    )
                                  ],
                                 )
                                 
                                :
                                 Stack(
                                   children: [
                                    
                                  
                                       
                                   widget.data['lives'] != null ?  Positioned(
                                     top: 15,
                                       right: 15,
                                       child: 
                                   Row(
                                       children: [
                                         Icon(Icons.favorite_rounded, color: const Color.fromARGB(255, 255, 87, 75),),
                                         SizedBox(width: 10,),
                                         Text('${lives ?? widget.data['lives']}', style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                         fontSize: 18,
                                          color: const Color.fromARGB(255, 136, 74, 69)),)
                                       ],
                                     )
                                     ) : SizedBox.shrink(),
                                     
                                   
                                      ...widget.optionData.where((e) => e['slide_id'] == currentSlide).map((e) 
                                                      {
                                                     
                                   return subslide != null && widget.data['storytype'] == 'Basic' ? SizedBox.shrink(): Positioned(
                                     left: ((e['left'] ).toDouble() ),
                                     top: ((e['top']).toDouble()),
                                      child: GestureDetector(
                                       onTap: ()  async {
                                
                                           if (int.tryParse(e['next_slide_id'].toString()) == null){
                                           
                                        subslide = widget.slideData.where((entry) => entry['subslide'] == e['next_slide_id'] && (entry['slide'] == (currentSlide))).first['subslide'];
                                        if (currentSlide==widget.slideData.where((e)=>e['subslide']==null).length){
                                         Toast.show(context, 'Ending reached!', false);
                                         reachedEnding=true;
                                         setState(() {
                                           
                                         });
                                        await supabase.from('completion').insert({'story_id':widget.data['id']});
                                        }
                                           } else {
                                             if (e['next_slide_id']!=null){
                                              
final compare = widget.slideData.where((er){
                                               
                                            
                                          return   er['subslide'] == null && er['slide']==int.parse(e['next_slide_id']);}).toList();
                                        
                                              if (compare == null ? false : (compare[0]['next_slide_id'] != null || compare[0]['type'] == 'choice')){
                                           currentSlide = e['next_slide_id'].runtimeType == String ? int.tryParse(e['next_slide_id']) : e['next_slide_id'];
                                              } else {
                                                currentSlide = e['next_slide_id'].runtimeType == String ? int.tryParse(e['next_slide_id']) : e['next_slide_id'];
                                                if (widget.data['storytype'] != 'Basic' || widget.slideData.where((e)=>e['subslide']==null).length==currentSlide+(
                                                  widget.data['storytype']=='Basic' ? 0 :1
                                                )){
                                                
                                                  Toast.show(context, 'Ending reached!', false);
                                              
                                                     reachedEnding=true;
                                                }
                                         setState(() {
                                           
                                         });
                                              }
                                             } else {
                                           
                                                             Toast.show(context, 'Ending reached!', false);
                                                              reachedEnding=true;
                                         setState(() {
                                           
                                         });
                                                             await supabase.from('completion').insert({'story_id':widget.data['id']});
                                             }
                                           }
                                           if (e['lives'] != null && widget.data['lives'] != null){
                                         lives == null ? lives = widget.data['lives']+(e['lives'] as int) : lives = lives! + (e['lives'] as int);
                                         if (lives == 0){
                                         
                                     if     (int.tryParse(e['next_slide_id'].toString()) == null) {
                                           gameOverShowEnding=true;
                                           } else {
                                             gameOVer=true;}
                                          }
                                           }
                                         setState(() {
                                           
                                         });
                                         preLoadImgs();
                                       },
                                       child: e['type'] =='text' ? Text('${e['text']}', style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: e['size'].toDouble()),) : Container(
                                         
                                         width: (e['width'].toDouble()), height: (e['height'].toDouble() ),
                                         decoration: BoxDecoration(
                                         image:
                                          DecorationImage(image: NetworkImage(supabase.storage.from('stories').getPublicUrl('options/${e['id']}.png')))
                                         ),
                                         
                                       )),
                                    );
                                                      }
                                    ),
                                      !gameOverShowEnding ? SizedBox.shrink() :
                                     Positioned(
                                       bottom: 0,
                                       child: Container(
                                        
                                         width: containerWidth,
                                         decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 147, 140),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10) )
                                         ),
                                     
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     children: [
                                      SizedBox(width: 10,),
                                       Text('Game Over', style: TextStyle(fontFamily: 'Poppins', color: 
                                                const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                   fontSize: 16),),
                                     Spacer(),
                                      GestureDetector(
                                       onTap: (){
                                         gameOVer=false;
                                         gameOverShowEnding=false;
                                         currentSlide=1;
                                         subslide=null;
                                         lives=widget.data['lives'];
                                         setState(() {
                                           
                                         });
                                       },
                                       child: Container(
                                         width: 120,
                                         decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                           child: Center(child: Text('Try Again', style: TextStyle(fontFamily: 'Poppins', color: 
                                                  const Color.fromARGB(255, 0, 0, 0),  fontWeight: FontWeight.bold,
                                                                                     fontSize: 16),),)
                                         ),
                                       ),
                                     )
                                     ],
                                   ),
                                 ),
                                       )
                                       
                                       ),
                                      !reachedEnding ? SizedBox.shrink() :
                                     Positioned(
                                       bottom: 0,
                                       child: Container(
                                         width: containerWidth,
                                         decoration: BoxDecoration(
                                         color:const Color.fromARGB(255, 244, 237, 255),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10) )
                                         ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     children: [
                                      SizedBox(width: 10,),
                                       Text('Ending Reached', style: TextStyle(fontFamily: 'Poppins', color: 
      const Color.fromARGB(255, 190, 156, 250), fontWeight: FontWeight.bold,
                                                                                   fontSize: 16),),
                                     Spacer(),
                                      GestureDetector(
                                       onTap: (){
                                      
                                         currentSlide=1;
                                         reachedEnding=false;
                                         subslide=null;
                                         lives=widget.data['lives'];
                                         setState(() {
                                           
                                         });
                                       },
                                       child: Container(
                                         width: 120,
                                         decoration: BoxDecoration(color: const Color.fromARGB(255, 190, 156, 250), borderRadius: BorderRadius.circular(20)),
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                           child: Center(child: Text('Play Again', style: TextStyle(fontFamily: 'Poppins', color: 
                                           const Color.fromARGB(255, 244, 237, 255),  fontWeight: FontWeight.bold,
                                                                                     fontSize: 16),),)
                                         ),
                                       ),
                                     )
                                     ],
                                   ),
                                 ),
                                       )
                                       
                                       ),
                                   ],
                                 ),
                                ),
                          ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          SizedBox(height: 15,),
                                        
                                                         
                                      Row(
                                        
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      
                                                                  
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      if (user == null){
                                                                        return;
                                                                      } else {
                                                                      setState(() {
          
                                                                        hasLiked = !hasLiked;
          
          
                                                                      });
                                                                       final id = supabase.auth.currentUser!.id;
      final getUsername = await supabase.from('profile').select('username').eq('user_id', id).maybeSingle();
      if (id != widget.data['author'] ) {
      await supabase.from('notifications').insert({
      'username':getUsername?['username'],
       'target_user': widget.data['author'], 
       
        'target_id':widget.data['id'],
        'type':'like'
       });  
      } 
           hasLiked ?  await supabase.from('likes').insert({'target_id':widget.data['id'], 'type':'story', 
             
              }) :  await supabase.from('likes').delete().eq('target_id', widget.data['id']).eq('user_id', id);
                                                                      }
                                                                    },
                                                                  child:   Container(
                                                                    width: 130,
                                                                        decoration: BoxDecoration(
                                                                                                         borderRadius: BorderRadius.circular(10),
                                                                                                          color: const Color.fromARGB(255, 254, 189, 211).withAlpha(100)
                                                                                                         ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(15),
                                                                        child: Center(
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center, 
                                                                            children: [
                                                                              Icon(hasLiked ? Icons.favorite : Icons.favorite_border, size: 25,
                                                                               color: const Color.fromARGB(255, 246, 95, 145),
                                                                              ),
                                                                          const   SizedBox(width: 10),
                                                                              Text(convertAmnt((widget.data['likes'] ?? 0) + ((hasLiked && !widget.hasLiked) ? 1 : 0)
                                                                              - (!hasLiked && widget.hasLiked ? 1 :0)
                                                                              ), style: TextStyle(
                                                                                 fontWeight: FontWeight.bold,
                                                                                fontFamily: 'Poppins',
                                                                               color: const Color.fromARGB(255, 246, 95, 145),
                                                                               fontSize: 17
                                                                               ),)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )),
                                                                    // child: Container(
                                                                    //     decoration: BoxDecoration(
                                                                    //                                       shape: BoxShape.circle,
                                                                    //                                       color: const Color.fromARGB(255, 254, 189, 211).withAlpha(100)
                                                                    //                                      ),
                                                                    //   child: Padding(
                                                                    //     padding: const EdgeInsets.all(15),
                                                                    //     child: Icon(hasLiked ? Icons.favorite : Icons.favorite_border, size: 30,
                                                                    //      color: const Color.fromARGB(255, 246, 95, 145),
                                                                    //     ),
                                                                    //   )),
                                                                  ),
                                                                const  SizedBox(width: 20,),
                                                                GestureDetector(
          
                                                                  onTap: () async {


                                                                    cmnts = cmnts.isEmpty ?  await supabase.from('comments').select().eq('story_id', widget.data['id'])
                                                                 //   .eq('story_id',3)
                                                                    .filter('replied_to',
                                                                     'is', null).limit(50) : cmnts;
                                                                    
                                                                    openComments();
                                                                  },
                                                                  child: Container(
                                                                     width: 130,
                                                                        decoration: BoxDecoration(
                                                                                                         borderRadius: BorderRadius.circular(10),
                                                                                                         
                                                                                                        color: const Color.fromARGB(255, 254, 189, 211).withAlpha(100)
                                                                                                       ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(15),
                                                                        child: Center(
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                           const   Icon(CupertinoIcons.ellipses_bubble, size: 25,
                                                                               color: Color.fromARGB(255, 246, 95, 145),
                                                                          
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Text(convertAmnt((widget.data['comments']??0) + commentsAdded), style: const TextStyle(fontFamily: 'Poppins',
                                                                               color: Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold,
                                                                               fontSize: 17
                                                                               ),)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                                
                                                                
                                                               
                                      ],),
                                  
                                    ],
                                  ),
                                ),
                              )
          
                          
                         
                                   
                                     
                         
                       ],),
                       
                     ],
                   )
          ),
        ),
      ),
    ));}
}
