


import 'dart:math';
import "dart:io";
import 'package:fashion/draft.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fashion/publishstory.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/material.dart';
//import 'package:nsfw_detector_flutter/nsfw_detector_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import "dart:async";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BasicEditor(isDraft: false,),
  ));
}
class BasicEditor extends StatefulWidget {
  final dynamic slideData;
final dynamic optionData;
final dynamic isDraft;
  const BasicEditor({super.key, this.slideData, this.optionData, this.isDraft,});

  @override
  State<BasicEditor> createState() => _BasicEditorState();
}

class _BasicEditorState extends State<BasicEditor> {
  int? tappedId;
    final supabase = Supabase.instance.client;
  dynamic currentImg;
  dynamic currentID;
  Map textMap = {};
  dynamic currentPath;
//   late NsfwDetector moderator;
//   void loadModerator() async {
//  moderator = await NsfwDetector.load();
//   }
    @override
  void initState(){
//loadModerator();

    if (widget.optionData != null){
      optionData=widget.optionData;
       for (final option in optionData.where((e)=>e['type']=='text')){
  dynamic painterText = TextPainter(text: TextSpan(text: option['text'], style: TextStyle(fontSize: option['size'].toDouble(),
                                                  fontFamily: 'Poppins'

                                                  )),
                                                  textDirection: TextDirection.ltr
                                                  )..layout();
                                                
textMap[option['id']] = {'width': painterText.width, 'height':painterText.height};
      }
    }
    if (widget.slideData != null){
      (widget.slideData as List).sort((a,b){ 
        if (a['slide'] == b['slide'] ){
if (a['subslide']==null && b['subslide']!=null){
  return -1;
} else if (b['subslide']==null && a['subslide']!=null){
  return 1;
}
        }
        
        return (a['slide']).compareTo(b['slide']
        );});
      slideData = widget.slideData;
     
    }
    super.initState();
  }
List<Map<dynamic, dynamic>> slideData = [{'slide':1, "story_id":3 , "type":"start", 'id':1, 'text':'text',  'subslide':null, 'img':null },

// {'slide':2, "story_id":3 , "type":"start", 'id':1, 'text':'text',  'subslide':null },

];

dynamic pickedImage;

int idis =1;
void delSlide() async {
  if (widget.isDraft??false){
isSaving=true;
setState(() {
  
});
  }
  if (subslide == null){
     if (widget.isDraft ?? false){
  await supabase.from('slide').delete().eq('id', currentID).select();
  await supabase.from('options').delete().or('slide_id.eq.${currentSlide},next_slide_id.eq.${currentSlide}').eq('story_id', slideData[0]['story_id']);
 await supabase.storage.from('story').remove(['slides/$currentPath$currentID']);
 for (final slide in slideData.where((e)=> e['slide']>(currentSlide))){
  await supabase.from('slide').update({'slide':slide['slide']-1}).eq('id', slide['id']).eq('story_id', slideData[0]['story_id']);
  
  }
  for (final option in optionData.where((e)=> e['slide_id']>(currentSlide))){
  await supabase.from('options').update({'slide_id':option['slide_id']-1}).eq('id',option['id']);
  
  }
  isSaving=false;

}
  slideData.removeWhere((e) => e['slide'] == currentSlide);

 optionData.removeWhere((e) => e['slide_id'] == currentSlide || e['next_slide_id'] == currentSlide);

 optionData= optionData.map((e)=> {...e, 'slide_id': e['slide_id']<currentSlide? e['slide_id'] : (e['slide_id']-1)}).toList();
 slideData= slideData.map((e)=> {...e, 'slide': e['slide']<currentSlide? e['slide'] : (e['slide']-1)}).toList();

 if (currentSlide != 1){

  currentSlide = currentSlide-1;
 
  
 }
setState(() {
  
});
  } else {
    if (widget.isDraft ?? false){
  
  await supabase.from('slide').delete().eq('id', currentID);
 
  await supabase.from('options').delete().eq('next_slide_id', subslide).eq('slide_id',  currentSlide).eq('story_id', slideData[0]['story_id']);

 for (final slide in slideData.where((e)=> alphabet.indexOf(subslide.toLowerCase())<alphabet.indexOf((e['subslide']??'').toLowerCase()))){

  await supabase.from('slide').update({'subslide': alphabet[(alphabet.indexOf(subslide.toLowerCase()))].toUpperCase()}).eq('story_id', slideData[0]['story_id']).eq('id', slide['id']);
  }
  for (final option in optionData.where((e)=> alphabet.indexOf(e['next_slide_id'].toString().toLowerCase())>alphabet.indexOf(subslide.toLowerCase()))){
  await supabase.from('options').update({'next_slide_id':alphabet[(alphabet.indexOf(subslide.toLowerCase()))].toUpperCase()}).eq('story_id',slideData[0]['story_id']).eq('id',option['id']);
  }
  isSaving=false;

}
   slideData.removeWhere((e) => e['slide'] == currentSlide && e['subslide'] == subslide);

 optionData.removeWhere((e) => e['slide_id'] == currentSlide && e['next_slide_id'] == subslide);

 optionData= optionData.map((e)=> {...e, 'next_slide_id': alphabet.indexOf(e['next_slide_id'].toString().toLowerCase())<alphabet.indexOf(subslide.toLowerCase())?
  e['next_slide_id'] : alphabet[(alphabet.indexOf(subslide.toLowerCase()))].toUpperCase()}).toList();
  
 slideData= slideData.map((e)=> {...e, 'subslide': e['subslide'] == null ? null : alphabet.indexOf( e['subslide'].toLowerCase())
 <alphabet.indexOf(subslide.toLowerCase())
 ? e['subslide'] : alphabet[(alphabet.indexOf(subslide.toLowerCase()))].toUpperCase()}).toList();

 if (slideData.where((e) => e['slide'] == currentSlide && e['subslide'] != null).isNotEmpty ){

 subslide = alphabet[(alphabet.indexOf(subslide.toLowerCase()))-(subslide== 'A' ? 0 :1)].toUpperCase();

 } else {
  subslide = null;
 }

  }
 
  setState(() {
    
  });
  
}

                                                                        void explain(type){

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
                                                child: Text('Next Slide', 
                                                                     textAlign: TextAlign.center,
                                                                     style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                             
                                                                      fontWeight: FontWeight.bold,
                                                                                                        fontSize: 20),),
                                                                                                        
                                              ),
                                                  SizedBox(height: 10,),
                                             Text('This lets you choose where this option leads. You can create a new slide, link it to an existing slide, or have it continue to the next slide.', 
                                                                   textAlign: TextAlign.center,
                                                                   style: TextStyle(fontFamily: 'Poppins', color: Colors.black
                                                                                           ,
                                                                                                      fontSize: 17),),
                                                                        
                                         
                                          SizedBox(height: 20,),
                                           GestureDetector(
                                     onTap: () async {
                                                                        Navigator.pop(context);
                                          
                                     },
                                             child: Container(
                                                      width:  double.infinity,
                                                      height: 50,
                                                   decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 221, 239),
                                                   borderRadius: BorderRadius.circular(10),
                                                   
                                                   ),
                                                   child: Center(child: 
                                              
                                                    
                                                   Text('Understood',                                                                                                                  
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
 

dynamic saveSlide(slide) async {
                                                                 
                                                                                               final insertDate = DateTime.now();
                                                 slide.remove('id');
                                               slide.remove('text', );
                                                final slideInsert = await supabase.from('slide').insert(
                                                    {...slide, 'img': null, 'story_id':slideData[0]['story_id'], 'path':'${insertDate}' }
                                                ).select();
                                                   final path = 'slides/${insertDate}${slideInsert[0]['id']}.png';
                                                   if (slide['img']!=null){
                                               await supabase.storage.from('stories').upload(path, slide['img'], fileOptions: FileOptions(upsert: true));
                                                   }
                                                   return slideInsert[0]['id'];
                                                  
}
dynamic saveOption(option) async {
  final insertDate = DateTime.now();
              option.remove('id', );
          
          final optionInsert  = await supabase.from('options').insert(
           
              {...option, 'img': null, 
                'story_id':slideData[0]['story_id'], 'path': '${insertDate}' 
                 }
           ).select();
         
          if (option['img'] != null){
             final path ='options/${insertDate}${optionInsert[0]['id']}.png';
          await supabase.storage.from('stories').upload(path, option['img'], fileOptions: FileOptions(upsert: true));
          }
           await supabase.from('slide').update({'type':'choice'}).eq('slide', currentSlide);
          return optionInsert[0]['id'];
}

bool canUpdateOption = true;
void updateOption(option, change) async {
 
        await supabase.from('options').update(
           
              {'left': change[0], 'top':change[1], 
                'width':change[2], 'height':change[3], 'size':change[4] 
                 }
           ).eq('id', option['id']);
          
           setState(() {
             
           isSaving= false;
           
           });
       
}

void updateSlide(image) async {
setState(() {
  isSaving=true;
});
                     await supabase.storage.from('stories').remove(['slides/$currentPath${currentID}.png']);
                                                                                                                            
  final insertDate = DateTime.now();
                                               
                                                   final path = 'slides/${insertDate}${currentID}.png';
                                                 
                                               await supabase.storage.from('stories').upload(path, image, fileOptions: FileOptions(upsert: true));
       await supabase.from('slide').update({'path':insertDate.toString()}).eq('id', currentID);
                                         slideData.where((e) => e['slide'] == currentSlide
                          && subslide == e['subslide']).single['path'] 
                = insertDate.toString();    
                setState(() {
                 isSaving=false; 
                });                            
}

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
final picker = ImagePicker();
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
                    //   final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                       // NsfwResult? result = await  moderator.detectNSFWFromFile(image);
//if (!(result?.isNsfw ?? false)){
                   if (!(widget.isDraft??false)){
                                        
                         slideData.where((e) => e['slide'] == currentSlide
                          && subslide == e['subslide']).single['img'] 
                 =image;
             
                  setState(() {
                });
                   } else {
            
                updateSlide(image);
                   }
  // } 
     }
               
                  //   if (image != null) {
                  // slideData.where((e) => e['slide'] == currentSlide
                  //          && subslide == e['subslide']).single['img'] = await image.readAsBytes();
                
                  
                  //  setState(() {
                     
                  //  });
                    // }
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
bool isSaving = false;
          Future addImg (dynamic nextSlide, dynamic count, dynamic existingSlide, dynamic lives, photo) async{
                                                                                       final completer = Completer<ImageInfo>();
  final img = FileImage(photo);
  img.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((info, _) {
      completer.complete(info);
    }),
  );
  final info = await completer.future;
int maxSize = 200;
double width = info.image.width.toDouble();
double height = info.image.height.toDouble();
if (width > maxSize && height > maxSize){
  
double scale = maxSize / max(info.image.height, info.image.width);
width = width*scale;
height = height*scale;
}
dynamic optionInsert =   { 'slide_id':currentSlide,   'type':'img', 
                                                                                            'text':  null, 'img': photo,
                                                                                           'left':37 , 'top':150, 
                     'width':width.toInt(),
                      'height':height.toInt(), 'size':23, "lives":lives, 
                      'id': ( optionData.isNotEmpty ? optionData.last['id']??0 : 0)+1, 
              'next_slide_id': nextSlide== 'new' ? getNextLtr(count) : 
                count == null ? currentSlide+1:
               existingSlide};
      final newOption = 
      widget.isDraft?? false
    ? Map<String, dynamic>.from({
        ...optionInsert, 
      
        'id': await saveOption(optionInsert),
      })
    : 
    Map<String, dynamic>.from(optionInsert);
  
                                             
optionData.add(newOption                            
                                                                                          );
                                                                                         
setState(() {
  
});
  
                                                                                        }
                                                                                       
  List<Map<dynamic, dynamic>> optionData = [
    // { 
    //   'slide_id':2, 'story_id':3, 'next_slide_id':'A', 'type':'text', 'text':'Option 1', 'left':0.1, 'top':0.3, 
    //   "img":null, 'width':0.3, 'height':0.2, 'size':23, "lives":-3, 'id':1
    // },
    //  { 
    //   'slide_id':2, 'story_id':3, 'next_slide_id':'B', 'type':'text', 'text':'Option 2', 'left':0.1, 'top':0.6,
    //    "img":null,  'width':0.3, 'height':0.2, 'size':23, "lives":null, 'id':2
    // },
    //  { 
    //   'slide_id':2, 'story_id':3, 'next_slide_id':'C', 'type':'text', 'text':'Option 3', 'left':0.6, 'top':0.3,
    //    "img":null,  'width':0.3, 'height':0.2, 'size':23, "lives":null, 'id':3
    // },
    //  { 
    //   'slide_id':2, 'story_id':3, 'next_slide_id':'D', 'type':'text', 'text':'Option 4', 'left':0.6, 'top':0.6,
    //    "img":null,  'width':0.3, 'height':0.2, 'size':23, "lives":null, 'id':4
    // },
    
  ];
  List alphabet = ['a','b','c','d','e','f','g','h','i','j','k', 'l', 'm', 'o', 'p'];
  String getNextLtr(int idx){
return (alphabet[idx]).toUpperCase();
  }

int currentSlide = 1;
dynamic subslide;
Timer? debounceTimer;
void addOption(){
   dynamic photo;
  void optionImage(setLocalState) {
 
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
                 
                //    photo= await picker.pickImage(source: ImageSource.gallery);
                // photo= await photo.readAsBytes();
                                   final image = await pickFromGallery();
                   if (image != null) {
                    //  NsfwResult? result = await  moderator.detectNSFWFromFile(image);
                     
// if (!(result?.isNsfw ?? false)){
                     setState(() => photo = image);
// }
                   }
                   setLocalState((){

                   });
                  
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

  TextEditingController choiceText  = TextEditingController();
  bool text = true;
dynamic existingSlide = 'Use Existing Slide';

dynamic nextSlide = 'new';
int lives = 0;

  showModalBottomSheet(
      constraints: BoxConstraints(
    maxWidth: double.infinity
  ),
    isScrollControlled: true,
    context: context,
  backgroundColor: Colors.white, 
  
  builder:(context) {
        final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return FocusScope(
          child: GestureDetector(
             onTap: (){
                
                    FocusScope.of(context).unfocus();
              },
            child: SizedBox(
              height: height*0.8 ,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                         Text('Add Choice', style: TextStyle(fontFamily: 'Poppins', color: 
                                                               const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                                                                                  fontSize: 22),),
                                                                                                  SizedBox(height: 15,),
                    SizedBox(
                      height: height*0.55,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          
                          
                        children: [
                     
                                                                                                  Row(
                                                                                                    children: [
                                GestureDetector(
                                  onTap: () {
                                
                                  text = !text;
                                
                                
                                   setLocalState(() {
                                  
                                });
                                  },
                                  child: SizedBox(
                                width: width>700 ? width*0.2:width*0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                           Text('Text', style: TextStyle(fontFamily: 'Poppins', color: text ?  const Color.fromARGB(255, 246, 95, 145)
                           : const Color.fromARGB(255, 255, 209, 224), fontWeight: FontWeight.w600
                           , 
                                                                                                      fontSize: 15),),
                                                                                                          SizedBox(height: 5,),
                                                                          Container(
                                                                        width: double.infinity,
                                                                        height: 2,
                                                                        decoration: BoxDecoration(
                                                                          color: 
                                                                          text ?  const Color.fromARGB(255, 246, 95, 145)
                           : const Color.fromARGB(255, 255, 209, 224), 
                                                                          borderRadius: BorderRadius.circular(10)
                                                                        ),
                                                                          )
                                  ],
                                ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                GestureDetector(
                                onTap: () {
                                
                                  text = !text;
                                  
                                setLocalState(() {
                                  
                                });
                                  },
                                  child: SizedBox(
                                 width: width>700 ? width*0.2:width*0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                           Text('Image', style: TextStyle(fontFamily: 'Poppins',  fontWeight: FontWeight.w600, color: 
                           !text ?  const Color.fromARGB(255, 246, 95, 145)
                           : const Color.fromARGB(255, 255, 209, 224), 
                                  
                                                                                                      fontSize: 15),),
                                                                                                      SizedBox(height: 5,),
                                                                          Container(
                                                                        width: double.infinity,
                                                                        height: 2,
                                                                        decoration: BoxDecoration(
                                                                          color: 
                                                                          !text ?  const Color.fromARGB(255, 246, 95, 145)
                           : const Color.fromARGB(255, 255, 209, 224), 
                                                                          borderRadius: BorderRadius.circular(10)
                                                                        ),
                                                                          )
                                  ],
                                ),
                                  ),
                                ),
                                   
                                            
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(height: 20,),
                                                                                                       text ? Container(
                                   
                                  width:width-40,
                                  decoration: BoxDecoration(
                                   border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                   borderRadius: BorderRadius.circular(10) 
                                  ),
                                  child:  TextField(
                                  maxLines: null,
                                  maxLength: 60,
                                controller: choiceText,
                                
                                decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                hint: Text('Type...', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                               const Color.fromARGB(255, 0, 0, 0),
                                                                                                  fontSize: 15))
                                ),
                                style: TextStyle(fontFamily: 'Poppins', color: 
                                                               const Color.fromARGB(255, 0, 0, 0),
                                                                                                  fontSize: 16)
                                  ),
                                ) :  GestureDetector(
                                  onTap: (){
            optionImage(setLocalState);
                                  },
                                  child: Container(
                                    width: width-40,
                                                    height: 100,         
                                     decoration: BoxDecoration(
                                      image: photo == null ? null : DecorationImage(image: FileImage
                               (
                              photo
                               
                               )),
                                  color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                     borderRadius: BorderRadius.circular(10) 
                                    ),
                                    child:  Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20),
                                                        child: photo != null ? SizedBox.shrink() :Icon(Icons.image, color: const Color.fromARGB(255, 255, 255, 255), size: 70,),
                                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text('Next Slide', style: 
                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                        fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                                                                                          color: const Color.fromARGB(255, 0, 0, 0),)),
                                  
                                     SizedBox(width: 10,),
                                                                                                          GestureDetector(
                                                                                            onTap: (){
                                                                                              explain('Next Slide');
                                                                                            }                ,
                                                                                                            child: Icon(Icons.help_outline, color: Colors.grey, size: 20,))
                                  ],
                                ),
                                                                                                      SizedBox(height: 10,),
                                                                                                        GestureDetector(
                                                                                                onTap: (){
                                                                                                 nextSlide = 'new' ;
                                                                                                 setLocalState(() {
                                                                                                   
                                                                                                 },);
                                                                                                },
                                                                                                child: Container(
                                                                                                     decoration: nextSlide == 'new' ?  BoxDecoration(
                                                                                                    border: Border.all( color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                    width: 2
                                                                                                    ),
                                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                                      
                                                                                                    ) :null,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(3),
                                                                                                    child: Container(
                                                                                                    
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                        
                                                                                                      ),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(12),
                                                                                                        child: Center(child: Text('Create New Slide', style: 
                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                          color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                                                    fontSize: 14)),),
                                                                                                    
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                                slideData.where((e)=>e['slide'] == currentSlide && e['subslide'] != null).isEmpty ?
                                                                                                   SizedBox.shrink() :     SizedBox(height: 10,),
                                                                                                   slideData.where((e)=>e['slide'] == currentSlide && e['subslide'] != null).isEmpty ?
                                                                                                   SizedBox.shrink() :
                                                                                                        GestureDetector(
                                                                                                onTap: (){
                                                                                                 nextSlide = 'Use Existing Slide' ;
                                                                                                 setLocalState(() {
                                                                                                   
                                                                                                 },);
                                                                                                },
                                                                                                child: Container(
                                                                                                     decoration:  nextSlide == 'new' || nextSlide == 'next' ? null: BoxDecoration(
                                                                                                    border: Border.all( color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                    width: 2
                                                                                                    ),
                                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                                      
                                                                                                    ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(3),
                                                                                               child:   nextSlide != 'new' && nextSlide != 'next' ?    DropdownButtonHideUnderline(
                                                        child: DropdownButton2(
                                                          alignment: Alignment.center,       
                                                          isExpanded: true,                    
                                              value:  existingSlide,
                                items: [
                                               DropdownMenuItem(
                                               
                                                                                                   value: 'Use Existing Slide',
                                                                                                   child: Center(child: Text(
                                                                                        'Use Existing Slide' ,style: 
                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                          color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                                                    fontSize: 14))),),
                                                                                             ...slideData.where((e)=>e['slide'] == currentSlide && e['subslide'] != null).map((entry) { 
                                                                                          return  DropdownMenuItem(
                                                                                                   value: entry['subslide'],
                                                                                                   child: Center(
                                                                                                     child: Text('Slide ${entry['slide']}${entry['subslide'] == null ? '':', Option ${entry['subslide']}'}', style: 
                                                                                                          TextStyle(fontFamily: 'Poppins', 
                                                                                                            color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                                                                                                      fontSize: 14)),
                                                                                                   ));
                                                                                     })
                                                                                                 
                                                                                                 
                                                                                               
                                                                                                 ],
                                                                                                 onChanged: (value){
                                                                                                   setLocalState((){
                                                                                           existingSlide= value;
                                                                                          
                                                                                                   });
                                                                                                 setLocalState(() {
                                                                                                   
                                                                                                 });
                                                                                                 
                                                                                              
                                                                                                 },
                                                                                                            dropdownStyleData: DropdownStyleData(
                                                            maxHeight: 200,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            offset: const Offset(0, 5),
                                                            scrollbarTheme: ScrollbarThemeData(
                                                              thumbColor: WidgetStatePropertyAll(   Color.fromARGB(255, 204, 191, 216),),
                                                              radius: const Radius.circular(8),
                                                              thickness: WidgetStatePropertyAll(4),
                                                              trackVisibility: WidgetStatePropertyAll(false),
                                                              mainAxisMargin: 10, 
                                                            ),
                                                          ),
                                                          iconStyleData: IconStyleData(icon: Icon( Icons.keyboard_arrow_down_rounded),),
                                                          menuItemStyleData: const MenuItemStyleData(
                                                            overlayColor: WidgetStatePropertyAll(   Color.fromARGB(255, 244, 236, 255),), 
                                                          ),
                                                                                 buttonStyleData:  ButtonStyleData(
                        
                                                            height: 45,
                                                            width: width-40,
                                                            padding: EdgeInsets.symmetric(horizontal: 0),
                                                            decoration: BoxDecoration(
                                                               color:  const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                borderRadius: BorderRadius.circular(10),
                                                                                                        
                                                            ),),
                                                          ),
                                                      ):
                                                                                                     Container(
                                                                                                    
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                        
                                                                                                      ),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(12),
                                                                                                        child: Center(child: Text('Use Existing Slide', style: 
                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                          color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                                                    fontSize: 14)),),
                                                                                                    
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(height: 10,),
                                                                                                        GestureDetector(
                                                                                                onTap: (){
                                                                                                 nextSlide = 'next' ;
                                                                                               
                                                                                                 setLocalState(() {
                                                                                                   
                                                                                                 },);
                                                                                                },
                                                                                                child: Container(
                                                                                                     decoration: nextSlide == 'next' ?  BoxDecoration(
                                                                                                    border: Border.all( color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                    width: 2
                                                                                                    ),
                                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                                      
                                                                                                    ) :null,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(3),
                                                                                                    child: Container(
                                                                                                    
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                        
                                                                                                      ),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(12),
                                                                                                        child: Center(child: Text('Continue to Next Slide', style: 
                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                          color: const Color.fromARGB(255, 173, 142, 227),
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                                                    fontSize: 14)),),
                                                                                                    
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                        SizedBox(height: 20,),
                                Text('Consequences', style: 
                                                                                                    TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold,
                                                                                                     
                                  fontSize: 15,  color: const Color.fromARGB(255, 0, 0, 0), )),
                                   SizedBox(height: 10,),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                       Text('Live change:', style: 
                                                                                                    TextStyle(fontFamily: 'Poppins', 
                                                                                                     
                                  fontSize: 15,  color: const Color.fromARGB(255, 0, 0, 0), )),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                             GestureDetector(
                                              onTap: (){
                                                setLocalState(() {
                                                  lives=lives-1;
                                                });
                                              },
                                               child: Container(
                                                                               decoration: BoxDecoration(color: const Color.fromARGB(255, 252, 181, 181),  borderRadius: BorderRadius.circular(12)),
                                                                               child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.remove, color: Colors.red,),
                                                                               ),),
                                                                             ),
                                             ),
                                         
                                          SizedBox(width: 25,),
                                          Text('${lives.isNegative ? lives: '+ $lives'}', style: TextStyle(fontFamily: 'Poppins', 
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18, color: Colors.black),),
                                          SizedBox(width: 25,),
                                           GestureDetector(
                                             onTap: (){
                                                setLocalState(() {
                                                  lives=lives+1;
                                                });
                                              },
                                             child: Container(
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 196, 255, 198),  borderRadius: BorderRadius.circular(12)),
                                              child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.add, color: Colors.green,),
                                              ),),
                                                                           ),
                                           ),
                                          
                                        ],
                                      ),
                                    ),
                                  )
                                    ]
                                   ),
                                     ]
                                   ),
                      ),
                    ),
                            Spacer(),
                      GestureDetector(
                                                                                            onTap: () async {
                                                                                              if (!text && photo==null){
                                                                                                Toast.show(context, 'Photo cannot be empty', true);
                                                                                                return;
                                                                                              } 
                                                                                              if (text &&choiceText.text.isEmpty){
                                                                                                Toast.show(context, 'Text cannot be empty', true);
                                                                                                return;
                                                                                              }
                                                                                       if (existingSlide == 'Use Existing Slide' && nextSlide != 'next' 
                                                                                       && nextSlide!='new'){
                                                                                                Toast.show(context, 'Please choose a next slide.', true);
                                                                                                return;
                                                                                              }
                                                                                              setState(() {
                                                                                                
                                                                                              isSaving = true;
                                                                                              
                                                                                              });
                                                                                             if (optionData.where((e) => e['slide_id'] == currentSlide).length < 23){
                                                                                               slideData.where((e) => e['slide'] == currentSlide && e['subslide'] == subslide).singleOrNull?['type'] = 'choice';
                                                                                              if (nextSlide != 'next'){
                                                                                               dynamic subslides = slideData.where((e) => e['slide'] == currentSlide && e['subslide'] != null).toList();
                                                                                            
                                                                                              int count = subslides.length;
                                                                                           if (!text){
                                                                                            addImg(nextSlide, count, existingSlide, lives, photo);
                                                                                           } else {
            
                                                                                           dynamic optionInsert =    { 'slide_id':currentSlide,   'type': 'text',
                                                                                                'text':  choiceText.text, 'img': null,
                                                                                                
                                                                                                 'left':37 , 'top':150, 
                         'width':null, 'height':null, 'size':23, "lives":lives, 'id':(optionData.isNotEmpty ? optionData.last['id']??0 : 0)+1, 
                                                                                                 'next_slide_id': nextSlide== 'new' ? getNextLtr(count) : existingSlide};
                 
                                         
                                                                                            final newOption = widget.isDraft?? false
                ? Map<String, dynamic>.from({
            ...optionInsert, 
            'id': await saveOption(optionInsert),
                  })
                : Map<String, dynamic>.from(optionInsert);
            
            optionData.add(newOption);
              
                                                   dynamic painterText = TextPainter(text: TextSpan(text: newOption['text'], style: TextStyle(fontSize: newOption['size'].toDouble(),
                                                      fontFamily: 'Poppins'
            
                                                      )),
                                                      textDirection: TextDirection.ltr
                                                      )..layout();
                                                    
            textMap[newOption['id']] = {'width': painterText.width, 'height':painterText.height};
                                                    
                                                                                           }
                        //                                                                    !text ? addImg(nextSlide, count, existingSlide, lives, photo)  : optionData.add(
                        //                                                                         { 'slide_id':currentSlide,   'type': 'text',
                        //                                                                         'text':  choiceText.text, 'img': null,
                                                                                                
                        //                                                                          'left':37 , 'top':150, 
                        //  'width':null, 'height':null, 'size':23, "lives":lives, 'id':(optionData.isNotEmpty ? optionData.last['id']??0 : 0)+1, 
                        //                                                                          'next_slide_id': nextSlide== 'new' ? getNextLtr(count) : existingSlide}
                        //                                                                       );
            
                                                                                         if (nextSlide == 'new'){
                                                                                             
                                       
                                      
                                          dynamic addSlide =  {
                                                                                                'slide':currentSlide, 'subslide':getNextLtr(count)
                                                                                                ,"type":"text",  
            
                                                                                              };
                                            final newSlide = widget.isDraft?? false
                ? Map<String, dynamic>.from({
            ...addSlide, 
            'id': await saveSlide(addSlide),
                  })
                : Map<String, dynamic>.from(addSlide);
            
                                        
                                       
                                                                                              slideData.insert(
                                                                                             slideData.indexOf(subslides.isEmpty ? slideData.where((entry) => entry['slide'] == currentSlide && entry['subslide'] == null).single
                                                                                             : subslides.last)+1,
                                                                                              newSlide);
                                                                                         }
                                                                                             
                                                                                              } else if (nextSlide == 'next'){
                                                                                                  if (!text){
                                                                                            addImg(nextSlide, null, existingSlide, lives, photo);
                                                                                           } else {
                                                                                               dynamic optionInsert =      { 'slide_id':currentSlide,   'type':text ? 'text':'img', 
                                                                                                'text':!text ? null :choiceText.text, 'img': text ? null :
                                                                                               photo,
                                                                                                 'left':37 , 'top':150, 
                         'width':null, 'height':null, 'size':23, "lives":lives, 'id':optionData.length+1, 
                                                                                                 'next_slide_id':currentSlide+1 };
                                                                                             
                   final newOption = widget.isDraft?? false
                ? Map<String, dynamic>.from({
            ...optionInsert, 
            'id': await saveOption(optionInsert),
                  })
                : Map<String, dynamic>.from(optionInsert);
            
            optionData.add(newOption); 
            
                                                   dynamic painterText = TextPainter(text: TextSpan(text: newOption['text'], style: TextStyle(fontSize: newOption['size'].toDouble(),
                                                      fontFamily: 'Poppins'
            
                                                      )),
                                                      textDirection: TextDirection.ltr
                                                      )..layout();
                                                    
            textMap[newOption['id']] = {'width': painterText.width, 'height':painterText.height};
                                                                                
                                                                                           }                                                                          
            //                                                                                                !text ? addImg(nextSlide, null, existingSlide, lives, photo)  :
            // optionData.add(
            //                                                                                             { 'slide_id':currentSlide,   'type':text ? 'text':'img', 
            //                                                                                             'text':!text ? null :choiceText.text, 'img': text ? null :
            //                                                                                            photo,
            //                                                                                              'left':37 , 'top':150, 
            //                      'width':null, 'height':null, 'size':23, "lives":lives, 'id':optionData.length+1, 
            //                                                                                              'next_slide_id':currentSlide+1 }
            //                                                                                           );
                                                                                           
                                              if (slideData.where((e)=> e['slide'] > currentSlide && e['subslide'] == null).isEmpty){
                                                 dynamic addSlide =    {
                                                                                                'slide':currentSlide+1, 'subslide':null
                                                                                                ,"type":"text",  
            
                                                                                              
                                                                                              };
                                            final newSlide = widget.isDraft?? false
                ? Map<String, dynamic>.from({
            ...addSlide, 
            'id': await saveSlide(addSlide),
                  })
                : Map<String, dynamic>.from(addSlide);
            
                                        
                                                 slideData.add(
                                                                                         
                                                                                           newSlide   );
                                              }
                                                                                              }
                                                                                              
            
                                                       isSaving = false;
                                                                                             } else {
                                                                                            Toast.show(context, "Option limit reached.", true);
                                                                                             }
                                                                                               setState(() {
                                                                                                
                                                                                              });
            
                                                                                               Navigator.pop(context);
                                                                                               setState(() {
                                                                                                 
                                                                                               });
                                                                                            },
                                                                                            child: Container(
                                                                                            
                                                                                              decoration: BoxDecoration(
                                                                                                color: const Color.fromARGB(255, 255, 209, 224),
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                                
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(15),
                                                                                                child: Center(child: Text('Add Choice', style: 
                                                                                                TextStyle(fontFamily: 'Poppins', 
                                                                                                  color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                                                                            fontSize: 15)),),
                                                                                            
                                                                                              ),
                                                                                            ),
                                                                                          ),
                  
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  },
  
  );

}
bool isLoading = false;

TextEditingController titleController = TextEditingController();
   @override
   

  Widget build (BuildContext context){
        final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
   final match = slideData.firstWhere(
  (e) => e['slide'] == currentSlide && subslide == e['subslide'],
  orElse: () =><String, dynamic>{},
);

currentImg = match['img'];
currentID = match['id'];
currentPath =match['path'];
    final containerHeight = 500.00;
    final containerWidth = 370.00;
  

 
  return Scaffold(

    backgroundColor: const Color.fromARGB(255, 246, 246, 246)
,
    body: SafeArea(
      child: SingleChildScrollView(
 child: Stack(
   children: [
              if (width>550)
                          Positioned(
                            left: 20,
                            top: 20,
                            child: 
                           GestureDetector(
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
                                        color: const Color.fromARGB(255, 175, 175, 175).withAlpha(50),
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
     ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
      ),
              child: Center(
                child: Container(
                      height: 820,
                   decoration: BoxDecoration(
                      
                
                      ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: 
                          Stack(
                            alignment: AlignmentGeometry.center,
                             children: [
                          
                              Positioned(
                                // left:   width>700? 0 : 20,
                                // right:   width>700? 0 : null,
                                top: 0,
                                child: SizedBox(
                                  width: containerWidth,
                                  child: Row(
                                    children: [
                                      if (width<550)
                                      SizedBox(width: 10,),
                                        if (width<550)
                                      GestureDetector(
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
                                            color: const Color.fromARGB(255, 175, 175, 175).withAlpha(50),
                                            shape: BoxShape.circle
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Center(child: Icon(Icons.arrow_back, size: 23, 
                                            color: const Color.fromARGB(255, 0, 0, 0), )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      GestureDetector(
                                        onTap: (){
                                        showModalBottomSheet(context: context,
                                                                                isScrollControlled: true,

                                           constraints: BoxConstraints(
    maxWidth: double.infinity
  ),
                                          builder:(context) {
                                           return StatefulBuilder(
                                             builder: (context, setState) {
                                               return Padding(
                                                   padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
                                               
                                                 child: Container(
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
                                                            child: Text('Save Draft', 
                                                                                 textAlign: TextAlign.center,
                                                                                 style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                         
                                                                                  fontWeight: FontWeight.bold,
                                                                                                                    fontSize: 20),),
                                                          ),
                                                              SizedBox(height: 10,),
                                                         Text('To save this story as a draft, add a title.', 
                                                                               textAlign: TextAlign.center,
                                                                               style: TextStyle(fontFamily: 'Poppins', color: Colors.black
                                                                                                       ,
                                                                                                                  fontSize: 17),),
                                                                                      SizedBox(height: 30,),
                                                         Align(
                                                       alignment: Alignment.topLeft,
                                                       child: Text('Title', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                                                                  fontSize:18, fontWeight: FontWeight.bold),),
                                                         ),
                                                                                                                      SizedBox(height: 15,),
                                                                  Container(
                                                         
                                                        width:double.infinity,
                                                        decoration: BoxDecoration(
                                                         border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                                         borderRadius: BorderRadius.circular(10) 
                                                        ),
                                                        
                                                        child:  TextField(
                                                        maxLines: null,
                                                      maxLength: 80,
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
                                                      SizedBox(height: 20,),
                                                       GestureDetector(
                                                 onTap: () async {
                                                  
                                                   if (!isLoading){
                                                     setState(() {
                                                     
                                                   isLoading  = true;
                                                   
                                                     });
                                                    final id = supabase.auth.currentUser?.id;
                                                           final fetchuser = await supabase.from('profile').select().eq('user_id', id!).maybeSingle();
                                                            final storyInsert = await supabase.from('story').insert(
                                                             {'title':titleController.text,
                                                             'tags':[],
                                                             "author":id,
                                                              'comments':0, 'likes':0, 
                                                             'score':0,
                                                             'draft':true,
                                                             'lives': null,
                                                             'storytype':'Basic', 
                                                             'username':fetchuser?['username'],
                                                             }).select();
                                                            
                                                           for (final slide in slideData){
                                                              final insertDate = DateTime.now();
                                                             slide.remove('id');
                                                           slide.remove('text', );
                                                            final slideInsert = await supabase.from('slide').insert(
                                                                {...slide, 'img': null, 'story_id':storyInsert[0]['id'], 'path':'${insertDate}' }
                                                            ).select();
                                                               final path = 'slides/${insertDate}${slideInsert[0]['id']}.png';
                                                               if (slide['img']!=null){
                                                           await supabase.storage.from('stories').upload(path, slide['img'], fileOptions: FileOptions(upsert: true));
                                                               }
                                                           }
                                                              
                                                           for (final option in optionData){
                                                               option.remove('id', );
                                                              final insertDate = DateTime.now();
                                                           final optionInsert  = await supabase.from('options').insert(
                                                            
                                                               {...option, 'img': null, 
                                                                 'story_id':storyInsert[0]['id'], 'path':'${insertDate}' 
                                                                  }
                                                            ).select();
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
                                                         child: Container(
                                                                  width:  double.infinity,
                                                                  height: 50,
                                                               decoration: BoxDecoration(
                                                               gradient: LinearGradient(
                                                               begin: Alignment.topLeft,
                                                               end: Alignment.bottomRight,
                                                               
                                                               colors: [const Color.fromARGB(255, 195, 166, 246).withAlpha(50), const Color.fromARGB(255, 165, 122, 241).withAlpha(110), ]
                                                                                                                                            
                                                               ),
                                                               borderRadius: BorderRadius.circular(10),
                                                               
                                                               ),
                                                               child: Center(child: 
                                                               isLoading?
                                                                SizedBox(
                                                                 width: 25,
                                                                 height: 25,
                                                                  child: CircularProgressIndicator(
                                                                   strokeWidth: 3,
                                                                   color: const Color.fromARGB(255, 141, 116, 185),),
                                                                ):
                                                               Text('Save',                                                                                                                  
                                                               style: 
                                                               TextStyle(fontFamily: 'Poppins', 
                                                               color: const Color.fromARGB(255, 141, 116, 185),
                                                               fontWeight: FontWeight.bold,
                                                               fontSize: 18)),),
                                                               ),
                                                       ),                      
                                                      SizedBox(height: 10,)
                                                       ],
                                                         ),
                                                       ),
                                                 ),
                                               );
                                             }
                                           );
                                         },);
                                        },
                                        child:  Center(child: 
                                             Row(
                                          children: [
                                            SizedBox(width: 10,),
                                               widget.isDraft?? false ?
                                   Text(isSaving ? 'Saving draft...': 'Draft saved', style: TextStyle(fontFamily: 'Poppins',
                                   
                                    fontSize: 16, color:  const Color.fromARGB(255, 246, 95, 145).withAlpha(150)),)
                                
                                     :   Icon(Icons.text_snippet, size: 30, color:  const Color.fromARGB(255, 246, 95, 145), )
                                          ],
                                        ) 
                                      ),),
                                      Spacer(),
                                        GestureDetector(
                                            onTap: () async {
                                              dynamic sentData = [];
                                              if (widget.isDraft??false){
                                                sentData = await supabase.from('story').select().eq('id', slideData[0]['story_id']).maybeSingle();
                                              }
                                                               Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => PublishStory(storyType: 'Basic', slideData: slideData, optionData: optionData, 
                                                  
                                                  
                                                  draftData: (widget.isDraft??false) ?sentData: null,),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                                                      );
                                },
                                          child: Row(
                                            children: [
                                              Text('Finish', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 173, 142, 227)
                                                                    //     const Color.fromARGB(255, 195, 166, 246)
                                                                         , fontWeight: FontWeight.bold,
                                                                                                            fontSize: 17),),
                                                                                                            SizedBox(width: 2,),
                                          Icon(Icons.chevron_right, color: const Color.fromARGB(255, 173, 142, 227), size: 30,)
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )),
                               Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                             SizedBox(height: 50,),
                                                 SizedBox(
                                                     width: containerWidth,
                                                   child: Column(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Text('Slide ${currentSlide}${slideData.where((entry) => entry
                                                       ['subslide'] == subslide && entry['slide'] == currentSlide).first['subslide'] == null ? '':', Option ${
                                                       slideData.where((entry) => entry
                                                       ['subslide'] == subslide && entry['slide'] == currentSlide).first['subslide']
                                                       }'}', style: TextStyle(fontFamily: 'Poppins', color: 
                                                       const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                                                                          fontSize: 25),),
                                                                                          SizedBox(height: 10,),
                                                                                          Row(
                                                                                            children: [
                                                                                              subslide != null ? SizedBox.shrink() :
                                                                                              GestureDetector(
                                                                                                onTap: (){
                                                                                                  addOption();
                                                                                                },
                                                                                                child: Container(
                                                                                                
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: const Color.fromARGB(255, 255, 209, 224),
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(12),
                                                                                                    child: Center(child: Text('Add Choice', style: 
                                                                                                    TextStyle(fontFamily: 'Poppins', 
                                                                                                      color: const Color.fromARGB(255, 246, 95, 145),
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                                                                                                fontSize: 14)),),
                                                                                                
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                       subslide != null ? SizedBox.shrink() :   SizedBox(width: 10,),
                                                                                            GestureDetector(
                                              onTap: (){
                                                showImagePickerOptions();
                                              },
                                                                                              child: Container(
                                                                                              
                                                                                              decoration: BoxDecoration(
                                                                                                color: const Color.fromARGB(255, 255, 209, 224),
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                                
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(12),
                                                                                                child: Center(child: Text('Background Image', style: 
                                                                                              TextStyle(fontFamily: 'Poppins', 
                                                                                                color: const Color.fromARGB(255, 246, 95, 145)
                                                                                                , fontWeight: FontWeight.bold,
                                                                                              fontSize: 14)
                                                                                                ),),
                                                                                              ),
                                                                                                                                                                            ),
                                                                                            ),
                                                                                            SizedBox(width: 10,),
                
                                                           ((subslide == null ? slideData.where((e)=>e['subslide'] == null).length > 1 : true)) ?   Container(
                                                                                
                                                         decoration: BoxDecoration(
                                                           color: const Color.fromARGB(255, 255, 173, 173),
                                                           shape: BoxShape.circle
                                                           
                                                         ),
                                                         child: Padding(
                                                           padding: const EdgeInsets.all(8),
                                                           child: Center(child: 
                                                         
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             crossAxisAlignment: CrossAxisAlignment.center,
                                                             children: [
                                                         
                                                          GestureDetector(
                                                            onTap: (){
                                                          delSlide();
                                                            },
                                                            child: Icon(
                                                               Icons.delete, size: 27,  color: const Color.fromARGB(255, 255, 84, 84)),
                                                          )
                                                             ],
                                                           ),),
                                                         ),
                                                                                                                                           ) : SizedBox.shrink(),
                                                                                            ],
                                                                                          ),
                
                                                    
                                                   ],
                                                   ),
                                                 ),
                SizedBox(height: 10,),
                                  GestureDetector(
                //                         onHorizontalDragEnd: (details){
                //                           final vel = details.primaryVelocity ?? 0;
                //                           if (vel > 0 && currentSlide>0 ){
                
                // setState(() {
                //   currentSlide--;
                // });
                //                           }
                
                //                           if (vel<0 && widget.slideData.where((e) => e['slide'] == currentSlide && e['subslide'] == subslide).single['type'] != 'choice'){
                
                // setState(() {
                //   currentSlide++;
                //   subslide=null;
                // });
                //   print(currentSlide);
                //                           }
                                    
                                    child: GestureDetector(
                //                         },
                                      onTap: (){
                                        setState(() {
     
                                          
                                        tappedId = null;
                                        
                                        });
                                      },
                                      child: Container(
                                          width: containerWidth, 
                                                         
                                          height: containerHeight,
                                          decoration: BoxDecoration(
                                       image: currentImg == null && currentPath == null  ? null : DecorationImage(image:
                                       currentPath != null ? 
                                       NetworkImage
                                       (
                                   supabase.storage.from('stories').getPublicUrl
                                       ('slides/${currentPath}${currentID}.png'))
                                       :
                                       FileImage
                                       (
                                    currentImg
                                       ) ),
                                          color:
                                          
                                         
                                           const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                           
                                          child:
                                        
                                           Stack(
                                             children: [
                                                                                  ...optionData.where((e) => e['slide_id'] == currentSlide && e['subslide'] == subslide).map((e) 
                                                        {
                                                       
                                             return Positioned(
                                               left: ((e['left'].toDouble() )),
                                               top: ((e['top'].toDouble() )),
                                                child: GestureDetector(
                                                 onTap: () {
                                                  tappedId= e['id'];
                                                
                                                   setState(() {
                                                     
                                                   });
                                                 
                                                 },
                                                 onVerticalDragStart: (_) {}, 
  onVerticalDragUpdate: (_) {},
  onVerticalDragEnd: (_) {},
                                                onScaleEnd: (details){
                   
                                                                    
                                                  if ((widget.isDraft??false) ){
                                                                      //  canUpdateOption=false;
                                                                        
                                                                      updateOption(e, [e['left'], e['top'], e['width'], e['height'], e['size'] ]);
                //                                                             debounceTimer = Timer(Duration(milliseconds: 100), (){
                // canUpdateOption=true;
                
                //                                                             }) ;
                                                                      }
                                                },
                                                 onScaleUpdate: (details){
                                                  
                                                   isSaving=true;
                                                   if (tappedId == e['id']){
     
                                                    setState(() {
                                                    
                                                      final left = ( (e['left'] + (details.focalPointDelta.dx)).clamp(0, 
                                                     (e['type'] == 'img' ?   ((containerWidth- e['width'])) : (360-textMap[e['id']]['width'])).abs()
                                                     .round()
                                                            
                                                     ) ).round();
                                                     final top = (e['top'] + (details.focalPointDelta.dy)).clamp(0,
                                                                                   (e['type'] !=  'img' ? 490-textMap[e['id']]['height']
                                                                                    :(containerHeight- e['height'])).abs()).round();
                                                    
                                                     optionData[optionData.indexOf(e)]['left'] = left;
                                                   
                                                      optionData[optionData.indexOf(e)]['top'] = top;
                                                                                 dynamic width;
                                                                                 dynamic height;
                                                                                 dynamic size;
                                                      if (e['type'] == 'img'){
                                                        width = ((e['width']) * (((details.scale-1)/10)+1)).clamp(100,(0.9*containerWidth))  .round();
                                                        height = ((e['height']) *  (((details.scale-1)/10)+1)).clamp(100,(0.9*containerHeight))  .round();
                                                      optionData[optionData.indexOf(e)]['width'] = width;
                                                      optionData[optionData.indexOf(e)]['height'] = height;
                                                      }
                                                      
                                                                      if (e['size'] != null){
                                                                        size= (e['size'] * (((details.scale-1)/10)+1)).clamp(13,35).round();
                                                                     optionData[optionData.indexOf(e)]['size'] =size;
                                                                    
                                                 
                                                    final  painterText = TextPainter(text: TextSpan(text: e['text'], style: TextStyle(fontSize: e['size'].toDouble(),
                                                      fontFamily: 'Poppins'
     
                                                      )),
                                                      textDirection: TextDirection.ltr
                                                      )..layout();
                                                    textMap[e['id']] = {'width':painterText.width, 'height':painterText.height};
                                                                      }
                                                                    
                                                     });
                                                   } 
                                                 },
                                                 child:
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                  
                                                     Padding(
                                                       padding: const EdgeInsets.all(2),
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                       
                                                         width: e['type'] == 'img' ? (e['width'] ?? 150).toDouble()  : null,
                                                         height:  e['type'] == 'img' ? (e['height']??150).toDouble() : null, 
                                                         decoration: tappedId == e['id'] ?  
                                                         
                                                         BoxDecoration(
                                                           border: Border.all(width: 2.5, color:  const Color.fromARGB(255, 246, 95, 145),)
                                                         ) : null,
                                                         child: 
                                                         Padding(padding: EdgeInsets.all(0),
                                                         child:
                                                        (e['img'] == null  && e['path'] == null) || e['type'] == 'text'? Text('${e['text']}', style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: e['size'] == null ? 10 :e['size'].toDouble())) : Container(
                                                         
                                                         
                                                                                 decoration: BoxDecoration(
                                                                                   image: DecorationImage(image: 
                                                                                   
                                                                                    e['path'] != null?
                                       NetworkImage
                                       (
                                   supabase.storage.from('stories').getPublicUrl
                                       ('options/${e['path']}${e['id']}.png'))
                                       :
                                                                                   FileImage(e['img']) , fit: BoxFit.contain )
                                                                                 ),
                                                                                 
                                                         )) ),
                                                     ),
                                                       SizedBox(width: 10,),
                                                          tappedId!=e['id'] ? SizedBox.shrink() :
                                                           Column(
                                                             children: [
                                                               GestureDetector(
                                                                onTap: ()async{
                                                              
                                                              List sameSubslide = optionData.where((entry) => entry['slide_id'] == e['slide_id'] && entry['next_slide_id'] == e['next_slide_id']).toList();
                                                      
                                                              if (sameSubslide.length==1 && int.tryParse(e['next_slide_id'].toString()) == null){
                                                                  if (widget.isDraft ?? false){
                                                               await supabase.from('slide').delete().eq('slide', e['slide_id']).eq('subslide', e['next_slide_id']);
                                                                  }
                                                               slideData.remove(slideData.where((entry) => entry['slide'] == e['slide_id'] && entry['subslide'] == e['next_slide_id']).single);
                                                               
                                                               List withSubslides = slideData.where((entry) {
                                                            
                                                                 return 
                                                                 entry['slide'] == currentSlide &&
                                                                 entry['subslide'] != null && alphabet.indexOf(entry['subslide']?.toLowerCase()) > alphabet.indexOf(e['next_slide_id']?.toLowerCase());}).toList();
     
                                                               for (final slide in withSubslides){
                                           
                                                               List optionslide =  optionData.where((era) => era['slide_id'] == slide['slide'] && era['next_slide_id'] == slide['subslide']).toList();
                                                              
                                                               for (final option in optionslide){
                                                                  option['next_slide_id'] = alphabet[alphabet.indexOf(slide['subslide'].toLowerCase())-1].toUpperCase();
                                                                     if (widget.isDraft ?? false){
                                                                   await supabase.from('options').update({'next_slide_id':alphabet[alphabet.indexOf(slide['subslide'].toLowerCase())-1].toUpperCase()
                                                                   }).eq('id', option['id']);
                                                                     }
                                                               }
                                                                 slide['subslide'] = alphabet[alphabet.indexOf(slide['subslide'].toLowerCase())-1].toUpperCase();
                                                                 if (widget.isDraft ?? false){
                                                                  await supabase.from('slide').update({'subslide':alphabet[alphabet.indexOf(slide['subslide'].toLowerCase())-1].toUpperCase
                                                                   }).eq('id', slide['id']);
                                                                 }
                                                               }
                                                              }
                                                            
                                                                if (optionData.where((er)=>er['slide_id'] == currentSlide).length==1 ){
                                                                  final current=slideData.where((e)
                                                                  { 
                                                                
                                                                    return e['slide']==currentSlide && e['subslide'] == null;} ).single;
     current['type']= 'text';
     if (widget.isDraft??false){
       await supabase.from('slide').update({'type':'text'}).eq('id', current['id']);
     }
                                                              }
                                                              optionData.remove(e);
                                                              
                                                              if (widget.isDraft??false){
                                                                   await supabase.from('options').delete().eq('id', e['id']);
                                                                    await supabase.storage.from('story').remove(['options/${e['path']}${e['id']}']);
                
                                                              }
                                             setState(() {
                                                                });
                                                                },
                                                                 child:  Container(
                                                                             width: 45,                                                         decoration: BoxDecoration(color: const Color.fromARGB(255, 252, 181, 181).withAlpha(200),  borderRadius: BorderRadius.circular(12)),
                                                                                                                                      child: Center(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.delete, color: Colors.red,),
                                                                                                                                   ),),
                                                                                                                                    ),
                                                               ),
                                                                SizedBox(height: 10,),
                                                                    GestureDetector(
                                                                onTap: (){
                                                               setState(() {
     
      final nextSlide = int.tryParse(e['next_slide_id']?.toString() ?? '');
   
      if (nextSlide != null) {
      
        subslide = null;
        currentSlide = nextSlide;
      } else {
     
        subslide = e['next_slide_id'];
        currentSlide = e['slide_id']; 
      }
     });
                                                                },
                                                                 child:  Container(
                                                                   width: 45,
                                                                                                                                      decoration: BoxDecoration(color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                                              borderRadius: BorderRadius.circular(12)),
                                                                                                                                      child: Center(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                 child: Text('${int.tryParse(e['next_slide_id'].toString()) == null ? e['slide_id'] : ''}${e['next_slide_id']}', 
                                                                   style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                   fontSize: 18,
                                                    color:const Color.fromARGB(255, 173, 142, 227),))
                                                                                                                                   ),),
                                                                                                                                    ),
                                                               ),
                                                             ],
                                                           ),
                                                   ],
                                                 ))
                                             );
                                                        }
                                              ),
                                             // widget.data['lives'] != null ?  Positioned(
                                               
                                             //     right: 10,
                                             //     child: 
                                             // Row(
                                             //     children: [
                                             //       Icon(Icons.favorite_rounded, color: const Color.fromARGB(255, 255, 87, 75),),
                                             //       SizedBox(width: 10,),
                                             //       Text('${lives ?? widget.data['lives']}', style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                             //       fontSize: 18,
                                             //        color: const Color.fromARGB(255, 136, 74, 69)),)
                                             //     ],
                                             //   )
                                             //   ) : SizedBox.shrink(),
                                               Column(
                                                 children: [
                                                   
                                                
                                                 
                                                 ],
                                               ),
                                                                     //                                    ...widget.optionData.where((e) => e['slide_id'] == currentSlide).map((e) 
                                                                     //                    {
                                                       
                                                                     //                                 return Positioned(
                                                                     //                                   left: ((e['left'] as double) * containerWidth),
                                                                     //                                   top: ((e['top'] as double)* containerHeight),
                                                                     //                                    child: GestureDetector(
                                                                     //                                     onTap: () {
                                                   
                                                                     //                                      subslide = widget.slideData.where((entry) => entry['subslide'] == e['next_slide_id'] && (entry['slide'] == (currentSlide+1))).first['subslide']as int;
                                                                              
                                                                     //                                         currentSlide++;
                                                                     //                                         if (e['lives'] != null && widget.data['lives'] != null){
                                                                     // lives == null ? lives = widget.data['lives']+(e['lives'] as int) : lives = lives! + (e['lives'] as int);
                                                                     // if (lives == 0){gameOVer=true;}
                                                                     //                                         }
                                                                     //                                       setState(() {
                                                     
                                                                     //                                       });
                                                                     //                                     },
                                                                     //                                     child: e['img'] == null ? Text('${e['text']}') : Container(
                                                   
                                                                     // width: ((e['width'] as double) * containerWidth), height: ((e['height'] as double) * containerWidth),
                                                                     // decoration: BoxDecoration(
                                                                     //   image: DecorationImage(image: NetworkImage(e['img'] as String))
                                                                     // ),
                                                                     
                                                                     //                                     )),
                                                                     //                                  );
                                                                     //                    }
                                                          ] ),
                                            ),
                                    ),
                
                                     
                                        ),
                                        SizedBox(height: 20,),
                                           Padding(
                                            padding: const EdgeInsets.only(left: 20, bottom: 12),
                                            child: SizedBox(
                                              width: containerWidth,
                                              child: Align(
                                                                                         alignment: Alignment.topLeft,
                                                child: Text('Slides', style: 
                                                                                                                        TextStyle(fontFamily: 'Poppins', 
                                                                                                                          color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                                                                    fontSize: 17)),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          width: containerWidth,
                                          height: 80,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: slideData.length+1,
                                            itemBuilder: (context, index){
                                            return index == slideData.length ?
                                            GestureDetector(
                                              onTap: () async {
                                               setState(() {
                                                 
                                             
                                                isSaving=true;
                                                  });
                                                dynamic addSlide = {'slide':slideData.where((e)=>e['subslide'] == null).length+1, "type":"text", 'subslide':null, 'id':
                                            idis+1};
                                                  final newSlide = widget.isDraft?? false
                    ? Map<String, dynamic>.from({
                  ...addSlide, 
                  'id': await saveSlide(addSlide),
                })
                    : Map<String, dynamic>.from(addSlide);
                
                                               slideData.add(newSlide);
                                               setState(() {
                                                 isSaving=false;
                                               });
                                           
                                              },
                                              child: Container(
                                                width: 70,
                            decoration: BoxDecoration(
                                                                 borderRadius: BorderRadius.circular(10),
                                                             color: const Color.fromARGB(255, 195, 166, 246).withAlpha(100),
                                       ),
                                 child: Padding(
                                                                                    
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                                                    child: Center(
                                                                                      child: Icon(Icons.add, size: 45,
                                                                                       color:  const Color.fromARGB(255, 173, 142, 227),
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                            )
                                             :  GestureDetector(
                                              onTap: (){
                                                currentSlide = slideData[index]['slide'];
                                                 subslide = slideData[index]['subslide'];
                                                 setState(() {
                                                   
                                                 });
                                                 
                                                   
                                              },
                                               child: Padding(
                                                 padding: const EdgeInsets.only(right: 15),
                                                 child: Container(
                                                  width: 70,
                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        color: 
                                                                                                                        currentSlide == slideData[index]['slide'] && subslide == slideData[index]['subslide'] 
                                                                                                                        ?  const Color.fromARGB(255, 247, 124, 165).withAlpha(100):
                                                                                                                        const Color.fromARGB(255, 254, 189, 211).withAlpha(100)
                                                                                                                       ),
                                                                                    child: Padding(
                                                                                      
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                                                      child: Center(
                                                                                        child: Text('${ slideData[index]['slide']}${slideData[index]['subslide'] == null ? '' : '${slideData[index]['subslide']}'}', style: TextStyle(fontSize:  30,fontFamily: 'Poppins',
                                                                                        fontWeight: FontWeight.bold,
                                                                                         color: const Color.fromARGB(255, 246, 95, 145),),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                               ),
                                             );
                                          }),
                                        ),
                //                             SizedBox(height: 20,),
                //                             Row(
                //                               mainAxisAlignment: MainAxisAlignment.center,
                //                               crossAxisAlignment: CrossAxisAlignment.center,
                //                               children: [
                //                                 Container(
                //                                                                                     width: 100,
                //                                                                                       decoration: BoxDecoration(
                //                                                                                         color: const Color.fromARGB(255, 255, 209, 224),
                //                                                                                         borderRadius: BorderRadius.circular(20),
                                                                                                    
                //                                                                                       ),
                //                                                                                       child: Padding(
                //                                                                                         padding: const EdgeInsets.all(12),
                //                                                                                         child: Center(child: Text('Previous', style: 
                //                                                                                         TextStyle(fontFamily: 'Poppins', 
                //                                                                                           color: const Color.fromARGB(255, 246, 95, 145),
                //                                                                                             fontWeight: FontWeight.bold,
                //                                                                                                                                                                     fontSize: 14)),),
                                                                                                
                //                                                                                       ),
                //                                                                                     ),
                //                                                                                     SizedBox(width: 20),
                // Container(
                //                                                                                     width: 100,
                //                                                                                       decoration: BoxDecoration(
                //                                                                                         color: const Color.fromARGB(255, 255, 209, 224),
                //                                                                                         borderRadius: BorderRadius.circular(20),
                                                                                                    
                //                                                                                       ),
                //                                                                                       child: Padding(
                //                                                                                         padding: const EdgeInsets.all(12),
                //                                                                                         child: Center(child: Text('Next', style: 
                //                                                                                         TextStyle(fontFamily: 'Poppins', 
                //                                                                                           color: const Color.fromARGB(255, 246, 95, 145),
                //                                                                                             fontWeight: FontWeight.bold,
                //                                                                                                                                                                     fontSize: 14)),),
                                                                                                
                //                                                                                       ),
                //                                                                                     ),
                
                //                               ],
                //                             )
                             ]),
                                  ]),
                                     
                
                                  
                                 
                                           
                                             
                                 
                            
                               
                            
                           )
                  ),
              ),
            ),
   ],
 ),
      ),
    ));
    }
}



