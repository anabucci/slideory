
import 'package:fashion/draft.dart';
import 'package:fashion/main.dart';
import 'package:fashion/previewstory.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:nsfw_detector_flutter/nsfw_detector_flutter.dart';
import 'dart:io';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PublishStory(),
  ));
}
class PublishStory extends StatefulWidget {
  final dynamic storyType;
final dynamic slideData;
final dynamic optionData;
final dynamic draftData;
  const PublishStory({ super.key, this.storyType, this.slideData, this.optionData, this.draftData});

  @override
  State<PublishStory> createState() => _PublishStoryState();
}

class _PublishStoryState extends State<PublishStory> {
//  dynamic moderator;
//   void loadModerator() async {
//  moderator = await NsfwDetector.load();
//   }
  @override
void initState(){
  //loadModerator();
  if (widget.draftData != null){
    titleController = TextEditingController(text: widget.draftData['title'] ?? '');
    if (widget.draftData['tags'] != null && widget.draftData['tags'].isNotEmpty){

      tags.addAll(widget.draftData['tags']);
    }
    if (widget.draftData['lives'] != null){
      livesEnabled = widget.draftData['lives'] != null;
      startingLivs = widget.draftData['lives'];
    }
    setState(() {
      
    });
  }
  super.initState();
}
  List tags = [];
dynamic photo;
final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();
    Future<File?> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> pickFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
  void updateSlide(image) async {

                     await supabase.storage.from('stories').remove(['cover/${widget.draftData['path']}${widget.draftData['id']}.png']);
                                                                                                                            
  final insertDate = DateTime.now();
                                               
                                                   final path = 'cover/${insertDate}${widget.draftData['id']}.png';
                                                 
                                               await supabase.storage.from('stories').upload(path, image, fileOptions: FileOptions(upsert: true));
       await supabase.from('story').update({'path':insertDate.toString(), 'hasCover':true}).eq('id', widget.draftData['id']);
                                         widget.draftData['path']
                = insertDate.toString();    
                                          
}
   void showImagePickerOptions() {

    showModalBottomSheet(
        constraints: BoxConstraints(
    maxWidth: double.infinity
  ),
      context: context,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                   final image = await pickFromGallery();
                    // if (image != null) {
                    
                    //   setState(() => _pickedImage = image);
                    // }
                   // final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                   //    NsfwResult? result = await  moderator.detectNSFWFromFile(image);
//if (!(result?.isNsfw ?? false)){
              photo = image;
               setState(() {
                     
                   });
              //await image.readAsBytes();
              if (widget.draftData != null){
                 updateSlide(image);  
              }
                  
 //} 
 }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image, color:  const Color.fromARGB(255, 246, 95, 145)),
                      SizedBox(width: 10),
                      Text(
                        'Image from Gallery',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                 const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
  List alphabet = ['a','b','c','d','e','f','g','h','i','j','k', 'l', 'm', 'o', 'p'];
  bool isLoading = false;
  bool isSaving = false;
  bool settingsOpen = false;
  dynamic cover;
  bool livesEnabled = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController tagController = TextEditingController();
void addTag() async {
  setState(() {
       if (tags.length>=5){
Toast.show(context, 'Stories cannot have more than 5 tags', true);
return;
                }
    tags.add(tagController.text.toLowerCase());
    tagController.clear();
  });
    if (widget.draftData != null){
                                            await supabase.from('story').update({'tags':tags}).eq('id', widget.draftData['id']);
                                          }
}
  String getNextLtr(int idx){
return (alphabet[idx]).toUpperCase();
  }

int currentSlide = 1;
dynamic subslide;

   int startingLivs = 1;
   @override
   

  Widget build (BuildContext context){
           final width = MediaQuery.of(context).size.width;
  
  return Scaffold(
      body: Container(
        
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                    left: 20,
                    top: 20,
                    child: SizedBox(
                      width: width,
                      child: Row(
                      
                        children: [
                          Align(
          alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: (){
                                if (Navigator.canPop(context)){
                            Navigator.pop(context);
                                } else {
                                    //  Navigator.of(context).push(
                                    //   PageRouteBuilder(
                                    //     pageBuilder: (context, animation, secondaryAnimation) => StoriesForYou(),
                                    //     transitionDuration: Duration.zero,
                                    //     reverseTransitionDuration: Duration.zero,
                                    //   ),
                                    //                         );
                                }
                              },
                              child: Container(
                            
                                decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 178, 178, 178).withAlpha(50),
                                  shape: BoxShape.circle
                                ),
                                child: Center(child: Icon(Icons.chevron_left, size: 35, color: const Color.fromARGB(255, 72, 71, 71), )),
                              ),
                            ),
                          ),
                       
                        ],
                      ),
                    )),
                    Positioned(
                    left: 0,
                    top: 20,
                    child: SizedBox(
                      width: width,
                      child: 
                          Align(
          alignment: Alignment.center,
                            child: 
          Text('Publish Story', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145)
                                                      //     const Color.fromARGB(255, 195, 166, 246)
                                                           , fontWeight: FontWeight.bold,
                                                                                              fontSize:24),),
                        
                          )
                    )),
                    Center(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100, top: 100),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                            
                              mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              
                                                  GestureDetector(
                onTap: (){
          showImagePickerOptions();
                },
                                                  child: Container(
                                                                                width: (width-40)*0.6,
                                                                                height:  (MediaQuery.of(context).size.height * 0.59)*0.6,
                                                                                // height: 200,
                                                                                 decoration: BoxDecoration(
                                                                                  image: 
                                                                               
                                                                                  photo==null && ( widget.draftData== null ? true :(widget.draftData!= null && !(widget.draftData['hasCover'] ?? false)))  ? null : DecorationImage(image: 
                                                                                  
                                                                                photo==null?
                                                                                 NetworkImage(
                                                                                  supabase.storage.from('stories').getPublicUrl('cover/${widget.draftData['path']}${widget.draftData['id']}.png')) :

                                                                                  FileImage(photo), fit: BoxFit.cover),
                                                                              color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                                 borderRadius: BorderRadius.circular(10) 
                                                                                ),
                                                                                child: photo!=null || (widget.draftData != null && (widget.draftData['hasCover'] ?? false)) ?SizedBox.shrink():
                                                                                Center(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(20),
                                                                        child: Icon(Icons.image, color: const Color.fromARGB(255, 255, 255, 255), size: 80,),
                                                                      ),
                                                                                ),
                                                                              ),
                                                ), 
                                                                            SizedBox(height: 50,),
                                                                            Align(
                                            alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                child: Text('Title', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                                  fontSize:18, fontWeight: FontWeight.bold),),
                                                                              ),
                                                                            ),
                                                                                                    SizedBox(height: 15,),
                                                Container(
                                       
                                      width:width-40,
                                      decoration: BoxDecoration(
                                       border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                       borderRadius: BorderRadius.circular(10) 
                                      ),
                                      
                                      child:  TextField(
                                      
                                        
                                        onSubmitted: (value) async {
                                          if (widget.draftData != null){
                                            await supabase.from('story').update({'title':value}).eq('id', widget.draftData['id']);
                                          }
                                        },
                                      maxLines: 1,
                                    maxLength: 45,
                                    controller: titleController,
                                    decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    
                                    hint: Text('What will you call your story?', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                                   const Color.fromARGB(255, 111, 111, 111),
                                                                                                      fontSize: 15)),
                                    ),
                                    style: TextStyle(fontFamily: 'Poppins', color: 
                                                                   const Color.fromARGB(255, 0, 0, 0),
                                                                                                      fontSize: 16)
                                      ),
                                    ) ,
                                       SizedBox(height: 30,),
                                                             Align(
                                            alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                child: Text('Tags', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                                  fontSize:18, fontWeight: FontWeight.bold),),
                                                                              ),
                                                                            ),
                                                                                                    SizedBox(height: 15,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                                                           
                                                                                     width: width-110,
                                                                                          decoration: BoxDecoration(
                                                                                           border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                                                                           borderRadius: BorderRadius.circular(10) 
                                                                                          ),
                                                                                          
                                                                                          child:  TextField(
                                                                                       onSubmitted: (value) {
                                                                                         addTag();
                                                                                       },
                                                                                        controller: tagController,
                                                                                        decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                                        hint: Text('Add a tag...', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                                         const Color.fromARGB(255, 111, 111, 111),
                                                                                                            fontSize: 15)),
                                                                                        ),
                                                                                        style: TextStyle(fontFamily: 'Poppins', color: 
                                                                         const Color.fromARGB(255, 0, 0, 0),
                                                                                                            fontSize: 16)
                                                                                          ),
                                                                                        ),
                                                                                       Spacer()
          ,   GestureDetector(
                                                                onTap: (){
                                                                  addTag();
                                                                },
                                                                child: Container(
                                                                  
                                                                      decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(15),
                                                                                                      color: const Color.fromARGB(255, 254, 189, 211).withAlpha(100)
                                                                                                     ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(10),
                                                                      child: Icon(Icons.add, size: 30,
                                                                       color: const Color.fromARGB(255, 246, 95, 145),
                                                                      ),
                                                                    )),
                                                              ),                                
                                                    ],
                                                  ),
                                                ) ,
                                    SizedBox(height: 20,),
                                    SizedBox(
                                        width:width-40,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                                                              children: [
                                                                                              ... tags.map((e) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(right: 10),
                                                                      child: Container(
                                                                      width: 130,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: const Color.fromARGB(255, 190, 156, 250), width: 2),
                                                                        color:   const Color.fromARGB(255, 244, 237, 255),
                                                                      
                                                                        borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                                                                        child: Center(child: Row(
                                                                          children: [
                                                                          
                                                                            SizedBox(
                                                                              width: 70,
                                                                              child: Text('#$e', style: TextStyle(fontFamily: 'Poppins', overflow: TextOverflow.ellipsis,
                                                                              decoration: TextDecoration.none,
                                                                              color:   const Color.fromARGB(255, 190, 156, 250), fontWeight: FontWeight.bold, fontSize: 14),),
                                                                            ),
                                                                            Spacer(),
                                                                            GestureDetector(
                                                                              onTap: () async{
                                                                                setState(() {
                                                                                  tags.remove(e);
                                                                                });
                                                                                  if (widget.draftData != null){
                                            await supabase.from('story').update({'tags':tags}).eq('id', widget.draftData['id']);
                                          }
                                                                              },
                                                                              child: Icon(Icons.close, color: const Color.fromARGB(255, 190, 156, 250),))
                                                                          ],
                                                                        )),
                                                                      ),
                                                                                ),
                                                                    );
                                                                                               })]),
                                      ),
                                    ),
                                       SizedBox(height: 30,),
                                                                                                                                                                                                      Align(
                                            alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('Life Settings', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                                      fontSize:18, fontWeight: FontWeight.bold),),
                                                                              SizedBox(height: 20,),
                                                                            Row(
                                                                              children: [
                                                                                Text('Enable lives', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                                                      fontSize:15, fontWeight: FontWeight.bold),),
                                                                                                                                      Spacer(),
                                                                                                                                      Switch(
                                                                                                                                        inactiveThumbColor: const Color.fromARGB(255, 195, 166, 246),
                                                                                                                                        
                                                                                                                                        activeThumbColor: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                                        value: livesEnabled, onChanged: (e) async{
                                                                                                                                         
                            setState(() {
                              livesEnabled=!livesEnabled;
                              startingLivs=1;
                            });
                            await supabase.from('story').update({'lives':null}).eq('id', widget.draftData['id']);
                                                                                                                    })
                                                                              ],
                                                                            ), 
                                                                     livesEnabled ?        SizedBox(height: 20,) : SizedBox.shrink(),
                                                                       !livesEnabled ?      SizedBox.shrink():     Center(
                                                                         child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text('Starting lives:', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                                                        fontSize:15, fontWeight: FontWeight.bold),),
                                                                                                                                        Spacer(),
                                                                                                                                    Container(
                                                                                                         decoration: BoxDecoration(
                                                                                                           color: const Color.fromARGB(255, 255, 255, 255),
                                                                                                           borderRadius: BorderRadius.circular(10),
                                                                                                           boxShadow: [
                                                                                                   BoxShadow(
                                                                                                     color: Colors.black.withAlpha(20),
                                                                                                     blurRadius: 10,
                                                                                                     offset: Offset(0, 4),
                                                                                                   ),
                                                                                                 ],
                                                                                                         ),
                                                                                                         child: Padding(
                                                                                                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                                                           child: Row(
                                                                                                             
                                                                                                             children: [
                                                                                                                
                                                                                                               GestureDetector(
                                            onTap: () async {
                                              
                                       if (   startingLivs > 1 ) { 
                                        startingLivs--;
                                         if (widget.draftData != null){
                                            await supabase.from('story').update({'lives':startingLivs}).eq('id', widget.draftData['id']);
                                          }
                                       }
                                       setState(() {
                                              });
                                             
                                                
                                            },
                                             child: Container(
                                                                             decoration: BoxDecoration(color: const Color.fromARGB(255, 252, 181, 181),  borderRadius: BorderRadius.circular(12)),
                                                                             child: Center(child: Padding(
                                                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                              child: Icon(Icons.remove, color: Colors.red,),
                                                                             ),),
                                                                           ),
                                           ),
                                                                                                                SizedBox(width: 15,),
                                                                                                               Text('$startingLivs', style: TextStyle(fontFamily: 'Poppins', 
                                                                                                               fontWeight: FontWeight.bold,
                                                                                                               fontSize: 18, color: Colors.black),),
                                                                                                               SizedBox(width: 15,),
                                                                                                                GestureDetector(
                                                                                                                  onTap: () async {
                                                                                                                      if (startingLivs<10){
                                                                                                                       startingLivs++;
                                                                                                                        if (widget.draftData != null){
                                            await supabase.from('story').update({'lives':startingLivs}).eq('id', widget.draftData['id']);
                                          }

                                                                                                                      }
                                                                                                                      setState(() {
                                                                                                                        
                                                                                                                     });

                                                                                                                   },
                                                                                                                  child: Container(
                                                                                                                   decoration: BoxDecoration(color: const Color.fromARGB(255, 196, 255, 198),  borderRadius: BorderRadius.circular(12)),
                                                                                                                   child: Center(child: Padding(
                                                                                                                     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                                                                                                     child: Icon(Icons.add, color: Colors.green,),
                                                                                                                   ),),
                                                                                 ),
                                                                                                                ),
                                                                                                               
                                                                                                             ],
                                                                                                           ),
                                                                                                         ),
                                                                                                       )
                                                                                ],
                                                                              ),
                                                                            
                                                                       ),  SizedBox(height: 10,)
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
                      Positioned(
                            bottom: 24,
                            
                            child: 
                          
                          
                             SizedBox(
                              width: width-20,
                               child: Row(
                                                                                                          children: [
                                                                                                             SizedBox(width: 20,),
                                                                                                                   GestureDetector(
                                                                    onTap: (){
                                                                 
                                                                          Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => PreviewStory(
          data:{"id":3,
            "lives":livesEnabled ? startingLivs : null,
            'tags':tags,
            'title':titleController.text, 
            "username":"seasalt",
             'storytype':widget.storyType,
             
           }, slideData: widget.slideData, optionData: widget.optionData, tags: tags,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                                                      );
                                                                    },
                                                                    child: Icon(Icons.visibility, color: const Color.fromARGB(255, 143, 143, 143), size: 33,)),
                                                                    SizedBox(width: 30,),
                                                                  GestureDetector(
 onTap: () async {
        if (titleController.text.isEmpty){
Toast.show(context, 'Title cannot be left blank', true);
return;
                }
                 if (tags.length>=5){
Toast.show(context, 'Stories cannot have more than 5 tags', true);
return;
                }
                                       if (!isSaving){
                                         setState(() {
                                         
                                       isSaving  = true;
                                       
                                         });
                                        final id = supabase.auth.currentUser?.id;
                                               final fetchuser = await supabase.from('profile').select().eq('user_id', id!).maybeSingle();
                                               final insertCoverTime = DateTime.now();
                                                final storyInsert = await supabase.from('story').insert(
                                                {'title':titleController.text,
            'tags':tags,
            "author":id,
            'lives': livesEnabled ? startingLivs : null,
            'storytype':widget.storyType, 
            'username':fetchuser?['username'],
            'comments':0,
            'likes':0,

          'hasCover': photo!= null,
            'score':0,
            'draft':true,
            'path':insertCoverTime.toString(),
            }).select('id');
            print('phoo $photo');
            if (photo!=null){

                                               final path = 'cover/${insertCoverTime.toString()}${storyInsert[0]['id']}.png';
                                               print('path $path');
                                               try{
          await supabase.storage.from('stories').upload(path, photo, fileOptions: FileOptions(upsert: true)); 
                                               } catch (e){
                                                print('error: $e');
                                               }
            }
//        final slideFutures = widget.slideData.map((slide) async {
//  final insertDate = DateTime.now();
//                                                  slide.remove('id');
//                                                slide.remove('text', );
//                                                 final slideInsert = await supabase.from('slide').insert(
//                                                     {...slide, 'img': null, 'story_id':storyInsert[0]['id'], 'path':'${insertDate}' }
//                                                 ).select('id');
//                                                    final path = 'slides/${insertDate}${slideInsert[0]['id']}.png';
//                                                    if (slide['img']!=null){
//                                                await supabase.storage.from('stories').upload(path, slide['img'], fileOptions: FileOptions(upsert: true));
//                                                    }
//        }).toList();
//        await Future.wait(slideFutures);
//       final optionFutures = widget.optionData.map((option) async {
//    option.remove('id', );
//                                                   final insertDate = DateTime.now();
//                                                final optionInsert  = await supabase.from('options').insert(
                                                
//                                                    {...option, 'img': null, 
//                                                      'story_id':storyInsert[0]['id'], 'path':'${insertDate}' 
//                                                       }
//                                                 ).select('id');
//                                                final path ='options/${insertDate}${optionInsert[0]['id']}.png';
//                                                if (option['img'] != null){
//                                                await supabase.storage.from('stories').upload(path, option['img'], fileOptions: FileOptions(upsert: true));
//                                         } }).toList();
//               await Future.wait(optionFutures);
                                               for (final slide in widget.slideData){
                                                  final insertDate = DateTime.now();
                                                 slide.remove('id');
                                               slide.remove('text', );
                                                final slideInsert = await supabase.from('slide').insert(
                                                    {...slide, 'img': null, 'story_id':storyInsert[0]['id'], 'path':'${insertDate}' }
                                                ).select('id');
                                                   final path = 'slides/${insertDate}${slideInsert[0]['id']}.png';
                                                   if (slide['img']!=null){
                                               await supabase.storage.from('stories').upload(path, slide['img'], fileOptions: FileOptions(upsert: true));
                                                   }
                                               }
                                                  
                                               for (final option in widget.optionData){
                                                   option.remove('id', );
                                                  final insertDate = DateTime.now();
                                               final optionInsert  = await supabase.from('options').insert(
                                                
                                                   {...option, 'img': null, 
                                                     'story_id':storyInsert[0]['id'], 'path':'${insertDate}' 
                                                      }
                                                ).select('id');
                                               final path ='options/${insertDate}${optionInsert[0]['id']}.png';
                                               if (option['img'] != null){
                                               await supabase.storage.from('stories').upload(path, option['img'], fileOptions: FileOptions(upsert: true));
                                               }
                                               }
                                               isLoading = false;
                                                HapticFeedback.mediumImpact();
                                               Toast.show(context, 'Draft Saved', false);
                                                Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => Drafts(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                                                );
                                       } 

                               
},                                      
                                                                  
                                                                  child: 
                                                               
                                                               
                                                               widget.draftData == null ? 
                                                               isSaving ? SizedBox(
            width: 25,
            height: 25,
             child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color.fromARGB(255, 141, 116, 185),),
           ):
                                                                   Icon(Icons.text_snippet, color: const Color.fromARGB(255, 152, 152, 152), size: 33,) : SizedBox.shrink()),
                                                               
                                                            
                                                                  Spacer(),
          GestureDetector(
              onTap: () async{
                if (titleController.text.isEmpty){
Toast.show(context, 'Title cannot be left blank', true);
return;
                }
                     if (tags.length>=5){
Toast.show(context, 'Stories cannot have more than 5 tags', true);
return;
                }
                if (!isLoading){

          isLoading=true;
          setState(() {
            
          });

          final id = supabase.auth.currentUser?.id;
          final fetchuser = await supabase.from('profile').select().eq('user_id', id!).maybeSingle();
           if (widget.draftData!=null){
          await supabase.from('story').update(
            {'title':titleController.text,
            'tags':tags,
            "author":id,
            'lives': livesEnabled ? startingLivs : null,
            'storytype':widget.storyType, 
            
            'username':fetchuser?['username'],
            'path':null,
            'draft':false,
             'comments':null,
            'likes':null,
            'score':null,
            
            }).eq('id', widget.draftData['id']);
               final path = 'cover/${widget.draftData['id']}.png';
             try {
                  await supabase.storage.from('stories').copy('cover/${widget.draftData['path']}${widget.draftData['id']}.png', path);
                     await supabase.storage.from('stories').remove(['cover/${widget.draftData['path']}${widget.draftData['id']}.png']);
                } catch (e){


               }
              
            for (final slide in widget.slideData){
final path = 'slides/${slide['id']}.png';
           try {
                          await supabase.storage.from('stories').copy('slides/${slide['path']}${slide['id']}.png', path);
        await supabase.storage.from('stories').remove(['slides/${slide['path']}${slide['id']}.png']);
              } catch (e){

              }
            }
         
              for (final option in widget.optionData){
final path = 'options/${option['id']}.png';

              if (option['type']=='img'){
                try {
                 
     await supabase.storage.from('stories').copy('options/${option['path']}${option['id']}.png', path);
      await supabase.storage.from('stories').remove(['options/${option['path']}${option['id']}.png']);
              } catch(e){
               
              }
            }
              }
           } else {
           final storyInsert = await supabase.from('story').insert(
            {'title':titleController.text,
            'tags':tags,
            "author":id,
         'lives': livesEnabled ? startingLivs : null,
            'storytype':widget.storyType, 
            'hasCover':photo!=null,
            'username':fetchuser?['username'],
            'comments':0,
            'likes':0,
            'score':0,
            
            }).select();
            if (photo != null){
               final path = 'cover/${storyInsert[0]['id']}.png';
          await supabase.storage.from('stories').upload(path, photo, fileOptions: FileOptions(upsert: true));
            }
          for (final slide in widget.slideData){
          
            slide.remove('id');
          slide.remove('text', );
           final slideInsert = await supabase.from('slide').insert(
               {...slide, 'img': null, 'story_id':storyInsert[0]['id']}
           ).select();
              final path = 'slides/${slideInsert[0]['id']}.png';
              if (slide['img']!=null){
          await supabase.storage.from('stories').upload(path, slide['img'], fileOptions: FileOptions(upsert: true));
              }
          }
             
          for (final option in widget.optionData){
              option.remove('id', );
          
          final optionInsert  = await supabase.from('options').insert(
           
              {...option, 'img': null, 
                'story_id':storyInsert[0]['id'], 
                 }
           ).select();
          final path = 'options/${optionInsert[0]['id']}.png';
          if (option['img'] != null){
          await supabase.storage.from('stories').upload(path, option['img'], fileOptions: FileOptions(upsert: true));
          }
          }
           }
          if (tags.isNotEmpty){
            await supabase.from('tags').upsert(tags.map((e)=>{'tag':e}).toList(), onConflict: 'tag', ignoreDuplicates: true);
          }        
           isLoading=false; 
           HapticFeedback.mediumImpact();
           Toast.show(context, 'Story uploaded successfully', false);
               Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 2,),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                                          );
               }
               
                },
          // onTap: () async{
          // isLoading=true;
          //  final storyInsert = await supabase.from('story').insert(
          //   {'title':titleController.text,
          //   'tags':tags,
          //   "author":supabase.auth.currentUser?.id,
          //   'lives': livesEnabled ? true : null
            
          //   }).select();
            
          // for (final slide in widget.slideData){
          
          //   slide.remove('id');
          // slide.remove('text', );
          //  final slideInsert = await supabase.from('slide').insert(
          //      {...slide, 'img': null, 'story_id':storyInsert[0]['id']}
          //  ).select();
          //     await  supabase.from('slide').update({
          // "img":"${slideInsert[0]['id']}"
          //     }).eq('id', slideInsert[0]['id']);
          // }
             
          // for (final option in widget.optionData){
          //     option.remove('id', );
          
          // final optionInsert  = await supabase.from('options').insert(
           
          //     {...option, 'img': null, 
          //       'story_id':storyInsert[0]['id'], 
          //        }
          //  ).select();
          // await  supabase.from('options').update({
          // "img":"${optionInsert[0]['id']}"
          //     }).eq('id', optionInsert[0]['id']);
          // }
          //  isLoading=false; 
          //  Toast.show(context, 'Story uploaded successfully', false);
          //      Navigator.of(context).push(
          //                                   PageRouteBuilder(
          //                                     pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 2,),
          //                                     transitionDuration: Duration.zero,
          //                                     reverseTransitionDuration: Duration.zero,
          //                                   ),
          //                                                         );
          // },
            child: Container(
                 width:  width * 0.5,
                 height: 50,
          decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          
          colors: [const Color.fromARGB(255, 195, 166, 246).withAlpha(50), const Color.fromARGB(255, 165, 122, 241).withAlpha(110), ]
                                                                                                                          
          ),
          borderRadius: BorderRadius.circular(10),
          
          ),
          child: Center(child: isLoading?
           SizedBox(
            width: 25,
            height: 25,
             child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color.fromARGB(255, 141, 116, 185),),
           ):
          Text('Publish',                                                                                                                  
          style: 
          TextStyle(fontFamily: 'Poppins', 
          color: const Color.fromARGB(255, 141, 116, 185),
          fontWeight: FontWeight.bold,
          fontSize: 18)),),
          ),
          ),
          ],
          ),
                             ),)
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
