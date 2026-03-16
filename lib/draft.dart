import 'package:fashion/advancededitor.dart';
import 'package:fashion/basiceditor.dart';

import 'package:fashion/main.dart';
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
    home: Drafts(),
  ));
}


class Drafts extends StatefulWidget {
 
  const Drafts({super.key,});


  @override
  State<Drafts> createState() => _DraftsState();
}

class _DraftsState extends State<Drafts> {
  ScrollController lazyloading = ScrollController();
  bool hasMore = false;
  bool isLoading = true;
  final supabase = Supabase.instance.client;
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
    
      final drafts = await supabase.from('story').select().eq('draft',true).order('created_at', ascending: false).limit(10);
   if (drafts.isNotEmpty){
    lastCreatedAt = [drafts.last];
  }
     data = [...drafts,];
    if (drafts.length <10){
      hasMore=false;
    }
setState(() {
  isLoading=false;
});
  }
  loadAfterScrolling() async{
  final id = supabase.auth.currentUser?.id;
  
     final drafts = await supabase.from('story').select()
    .lt('created_at', lastCreatedAt[0])
    .eq('author', id??0)
    .order('created_at', ascending: false)
    
    .limit(10)
    ;
    if (drafts.isNotEmpty){
    lastCreatedAt = [drafts.last];
    }
     data = [data, ...drafts];
    if (drafts.length <10){
      hasMore=false;
    }
setState(() {
  
});
  }
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
                             
           Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 1,),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                              }
                            ,
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
                     
                     Text('Drafts', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0)
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
                       Text('No Drafts Yet', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                          fontSize: 26))
                     ],
                   )) : 

                                  RefreshIndicator(
                                     onRefresh: () async{
                                 
                                      fetchData();
                                    },
                                    child: SizedBox(
                                    height: MediaQuery.of(context).size.height*0.75,
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
                                     
                final slideData = await supabase.from('slide').select().eq('story_id', data[index]['id']);
                final optionData = await supabase.from('options').select().eq('story_id', data[index]['id']);
                
                                       data[index]['storytype'] == 'Basic' ?
                                         Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => BasicEditor(
                                    optionData: optionData, slideData: slideData, isDraft: true, 
                                    
                                    
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              ):
                                              Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>AdvancedEditor(
                                    optionData: optionData, slideData: slideData, isDraft: true,
                                    
                                    
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
                                                
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width*0.6,
                                                    
                                                    child: Text('${data[index]['title']}', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), 
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