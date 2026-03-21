
import 'package:fashion/storiesforyou.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PreviewStory(),
  ));
}
class PreviewStory extends StatefulWidget {
final dynamic data;
final dynamic slideData;
final dynamic optionData; 
final dynamic tags;
  const PreviewStory({super.key, this.data, this.slideData, this.optionData, this.tags});

  @override
  State<PreviewStory> createState() => _PreviewStoryState();
}

class _PreviewStoryState extends State<PreviewStory> {
 
int? lives;
bool reachedEnding = false;  
  int currentSlide = 1;

  String? subslide;
    dynamic currentImg;
  dynamic currentID;
  dynamic currentPath;
bool gameOVer = false;
  bool hasLiked = false;
  bool gameOverShowEnding = false;
  @override
  Widget build (BuildContext context){
  final containerHeight = 500.00;
    final containerWidth = 370.00;
   final match = widget.slideData.firstWhere(
  (e) => e['slide'] == currentSlide && subslide == e['subslide'],
  orElse: () =><String, dynamic>{},
);

currentImg = match['img'];
currentID = match['id'];
currentPath =match['path'];
  return Scaffold(
  
// backgroundColor: const Color.fromARGB(255, 248, 248, 248)
  backgroundColor: const Color.fromARGB(255, 248, 248, 248)
  ,
   body:  SafeArea(
     child: SingleChildScrollView(
        
        child: Container(
          height: MediaQuery.of(context).size.height > 880 ?  MediaQuery.of(context).size.height : 880,
               width: double.infinity,
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
                              color: const Color.fromARGB(255, 178, 178, 178).withAlpha(50),
                              shape: BoxShape.circle
                            ),
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.close, size: 30, color: const Color.fromARGB(255, 72, 71, 71), ),
                            )),
                          ),
                        )),
                        Positioned(
                      left: 0,
                      top: 20,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: 
                            Align(
        alignment: Alignment.center,
                              child: 
        Text('Preview Story', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145)
                                                        //     const Color.fromARGB(255, 195, 166, 246)
                                                             , fontWeight: FontWeight.bold,
                                                                                                fontSize:24),),
                          
                            )
                      )),
                       Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                                     SizedBox(height: 55,),
                                         Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                           child: SizedBox(
                                               width: containerWidth,
                                             child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text('${widget.data['title']}', style: TextStyle(fontFamily: 'Poppins', color: 
                                                 const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                                                                fontSize: MediaQuery.of(context).size.height*0.028),),
                                                                                      SizedBox(height: 10,),
widget.data['tags'] == null || widget.data['tags'].isEmpty ? SizedBox.shrink() :
                                                                                  
                                           SizedBox(
                                         
                                               child: Column(
                                                 children: [
                                                    SizedBox(height: 10,),
Align(
   alignment:  MediaQuery.of(context).size.width>700? Alignment.center:Alignment.centerLeft,
  child: SizedBox(
     width:   MediaQuery.of(context).size.width>700?containerWidth:MediaQuery.of(context).size.width-40,
                                                                                      height: 38,
                                                                                      child: ListView.builder(
                                                                                       scrollDirection: Axis.horizontal,
                                                                                        itemCount: widget.data['tags'].length,
                                                                                        itemBuilder: (context, index){
                                                                                        return Padding(
                                                                                                                 padding:  EdgeInsets.only(right: index == widget.data['tags'].length +1 ? 0 :10),
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
                                                                                                               );
                                                                                      }),
                                                                                    ),
),
                                                                    
                                                 ],
                                               ),
                                                                 
                                             ),
                                             SizedBox(height: 10,),
                                                                                Text("@${widget.data['username']}",
                                                                                
                                                                                style: TextStyle(fontFamily: 'Poppins', color: 
                                             const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                fontSize: 16),
                                                                                 ),
                                             ],
                                             ),
                                           ),
                                         ),
        SizedBox(height: 10,),
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
              
        
            } else {
             setState(() {
            currentSlide = currentSlide+1;
            subslide=null;
            });
            
            }
                                }
                                 if (vel<0 && widget.data['storytype'] != 'Basic' && widget.slideData.where((e) => e['slide'] == currentSlide && e['subslide'] == subslide).single['type'] != 'choice'){
                               
                              int? nextSlide =    currentSlide = widget.slideData.where((e)=> e['slide'] == currentSlide).first['next_slide_id']; 
                                  if (nextSlide ==null ){
                                     Toast.show(context, 'Ending reached!', false);
               reachedEnding=true;
                                           setState(() {
                                             
                                           });  
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
            //  await Supabase.instance.client.from('completion').insert({'story_id':widget.data['id']});
            }
                                }
                                }
                              },
                            child: Container(
                                width: containerWidth, 
                                               
                                height: containerHeight,
                            
                                decoration: BoxDecoration(
                                  
                               image:  currentImg == null && currentPath == null  ? null : DecorationImage(image:
                             currentPath != null ? 
                             NetworkImage
                             (
                         Supabase.instance.client.storage.from('stories').getPublicUrl
                             ('slides/${currentPath}${currentID}.png'))
                             :
                             FileImage
                             (
                          currentImg
                             
                               )),
                                color:
                                
                                gameOVer ? Colors.red.withAlpha(100):
                                 const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                child:
                                gameOVer ? 
                               
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Game Over', style: TextStyle(fontFamily: 'Poppins', color: 
                                               const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                  fontSize: 22),),
                                    SizedBox(height: 10,),
        
                                    Text('Oops! You ran out of lives.', style: TextStyle(fontFamily: 'Poppins', color: 
                                               const Color.fromARGB(255, 49, 49, 49), fontWeight: FontWeight.bold,
                                                                                  fontSize: 17), ),
                                    SizedBox(height: 20,),
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
                                    
                                        
                                      ...widget.optionData.where((e){
                                      
                                         return e['slide_id'] == currentSlide;}).map((e) 
                                                    {
                                   return subslide != null && widget.data['storytype'] == 'Basic' ? SizedBox.shrink(): Positioned(
                                     left: ((e['left']).toDouble() ),
                                     top: ((e['top'] ).toDouble()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: GestureDetector(
                                         onTap: () {
                                     if (int.tryParse(e['next_slide_id'].toString()) == null){
                                            
                                         subslide = widget.slideData.where((entry) => entry['subslide'] == e['next_slide_id'] &&
                                          (entry['slide'] == (currentSlide))).first['subslide'];
                                         if (currentSlide==widget.slideData.where((e)=>e['subslide']==null).length){
                                          Toast.show(context, 'Ending reached!', false);
                                          reachedEnding=true;
                                          setState(() {
                                            
                                          });
                                     
                                         }
                                            } else {
                                            
   if (e['next_slide_id']!=null){
                        if (e['next_slide_id'].runtimeType == String){
e['next_slide_id'] = int.parse(e['next_slide_id']);
                                              }                        
final compare = widget.slideData.where((er){
                                               

                                          return   er['subslide'] == null && er['slide']==e['next_slide_id'];}).toList();

                                              if (compare == null ? false : (compare[0]['next_slide_id'] != null || compare[0]['type'] == 'choice')){
                                           currentSlide = (e['next_slide_id']);
                                              } else {
                                                currentSlide =(e['next_slide_id']);
                                           
                                                if (widget.data['storytype'] != 'Basic' || widget.slideData.where((e)=>e['subslide']==null).length>=currentSlide+(
                                                  
                                             widget.data['storytype'] == 'Basic'? 0:     1)){
                                                
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
                                          
                                           
                                         },
                                         child: e['type'] == 'text' ? Text('${e['text']}', style: TextStyle(fontSize: e['size'].toDouble()),) : Container(
                                           
                                          width: e['type'] == 'img' ? e['width'].toDouble()  : null,
                                                 height:  e['type'] == 'img' ? e['height'].toDouble() : null, 
                                        decoration: BoxDecoration(
                                          image: e['type'] == 'text'?null: DecorationImage(image: e['path'] == null ? FileImage(e['img'] ) :
                             NetworkImage
                             (
                         Supabase.instance.client.storage.from('stories').getPublicUrl
                             ('options/${e['path']}${e['id']}.png'))
                          
                             ),
                                        ),
                                        
                                         )),
                                      ),
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
                                   widget.data['lives'] != null ?  Positioned(
                                     top: 10,
                                       right: 20,
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
                                   ],
                                 ),
                                ),
                          ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                        SizedBox(height: 10,),
                               
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                      child:                   
                                        Row(
                                          
                                            mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                        
                                                                    
                                                                    Container(
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
                                                                                SizedBox(width: 10),
                                                                                Text('0', style: TextStyle(
                                                                                   fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Poppins',
                                                                                 color: const Color.fromARGB(255, 246, 95, 145),
                                                                                 fontSize: 17
                                                                                 ),)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    SizedBox(width: 20,),
                                                                  Container(
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
                                                                              Icon(CupertinoIcons.ellipses_bubble, size: 25,
                                                                               color: const Color.fromARGB(255, 246, 95, 145),
                                                                          
                                                                              ),
                                                                               SizedBox(width: 10),
                                                                              Text('0', style: TextStyle(fontFamily: 'Poppins',
                                                                               color: const Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold,
                                                                               fontSize: 17
                                                                               ),)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  
                                                                  
                                                                 
                                        ],),
                                    ),
                                
                                  ],
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
