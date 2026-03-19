
import 'package:fashion/details.dart';
import 'package:fashion/main.dart';
import 'package:fashion/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TagSearch(),
  ));
}
class TagSearch extends StatefulWidget {
  final dynamic tag;
  const TagSearch({super.key, this.tag,});

  @override
  State<TagSearch> createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {

List data = [
];

dynamic lastScore;
bool hasMore = true;
final supabase = Supabase.instance.client;
ScrollController lazyLoading = ScrollController();
@override
void dispose() {
   lazyLoading.dispose();
    super.dispose();
  }
@override
void initState(){
  loadTagData();
   lazyLoading.addListener((){
if (lazyLoading.offset >=  (lazyLoading.position.maxScrollExtent) && hasMore){
 loadDataAfterScrolling();
}
    });
    super.initState();
}
void loadDataAfterScrolling() async {
  final stories =  await supabase.from('story').select()
  
  .contains('tags', [widget.tag])
  .not('id', 'in', seenIDS)
  .lt('score', lastScore)
  .order('score', ascending: false)
  
  .limit(10);
  if (stories.length>1){
 lastScore =  stories.last;
 seenIDS.addAll(stories.map((e)=>e['id']));
  }
data.addAll(stories.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')}));
if (stories.length<10){
  hasMore = false;
}
setState(() {
  
});
}
List seenIDS= [];
bool isLoading = true;
void loadTagData() async {
  final stories =  await supabase.from('story').select().contains('tags', [widget.tag]).order('score', ascending: false).limit(10);
if (stories.length>1){
 lastScore = stories.last;
 seenIDS.addAll(stories.map((e)=>e['id']));
}

data =stories.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')}).toList();
if (stories.length<10){
  hasMore = false;
}
setState(() {
  
});
isLoading=false;
}
  @override
  Widget build (BuildContext context){

  return Scaffold(
  
// backgroundColor: const Color.fromARGB(255, 248, 248, 248)
// backgroundColor: Colors.white,

    body: Container(
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
                        top: 10,
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
                                  color:  const Color.fromARGB(255, 221, 201, 255)  ,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       SizedBox(height: 80,),
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
                          child: Text('#${widget.tag}',  style: TextStyle(
                            color:   const Color.fromARGB(255, 246, 95, 145),
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            fontFamily: 'Poppins',
                           )),
                        ),
                         SizedBox(height: 20,),
                     isLoading ?
         Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 195, 166, 246)))
        
                                  :       SizedBox(
                          height: MediaQuery.of(context).size.height*0.73,
                           child: GridView.builder(
                            controller: lazyLoading,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing:3,
                            childAspectRatio: 0.6
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index){
                           return   
                               Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child:
                                  
                                  
                                  GestureDetector(
                                       onTap: () async {
        
          
        final data2 = data[index];
        final results = await Future.wait([
        
        supabase.from('slide').select().eq('story_id',data2['id']),
        supabase.from('options').select().eq('story_id', data2['id']),
        if (supabase.auth.currentUser == null)  Future.value([]) else supabase.from('likes').select().eq('target_id', data2['id'])
                                              .eq('user_id', supabase.auth.currentUser?.id ??0),
                                              supabase.from('story').select('comments, likes').eq('id', data2['id']),
                                              ]
                                              
                                              );
                                            Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(
                         data:{...data[index], 'likes':results[3][0]['likes'], 'comments':results[3][0]['comments']}, 
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
                                      child:Container(
                                      width: double.infinity, 
                                    
                                      decoration: BoxDecoration(
                                        image:
                                        !(data[index]['hasCover']??false) ?null: 
                                         DecorationImage(image:  NetworkImage(data[index]['cover']), fit: BoxFit.cover),
                                      border: Border.all(color: const Color.fromARGB(255, 195, 166, 246)),
                                      color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: 
                                          (data[index]['hasCover']??false) ? SizedBox.shrink():
                                          Text(data[index]['title'] ?? '', style: 
                                          TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                          fontSize: 23, overflow: TextOverflow.ellipsis), maxLines: 3,),
                                        ),
                                      ),
                                      ),
                                    ),
                                  
                               
                              
                            );
                                         }),
                         ),
                          //  Padding(
                        
                       ],),
                     ],
                   )
          ),
        ),
      ),
    ));}}