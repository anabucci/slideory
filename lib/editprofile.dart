import 'package:fashion/main.dart';
import 'package:fashion/toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://hdksoyldefecnizqotwp.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhka3NveWxkZWZlY25penFvdHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4NDA0NjIsImV4cCI6MjA3MDQxNjQ2Mn0.jx26QA8bUY949C2ZuqzOL2Kca8Rw-dvc9uL_fg7UdiA',
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfile(),
  ));
}
class EditProfile extends StatefulWidget {
  final dynamic data;
  final dynamic banner;
  final dynamic picture;
  final dynamic pictureFile;
  final dynamic bannerFile;
  const EditProfile({super.key, this.data, this.banner, this.picture, this.pictureFile, this.bannerFile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final supabase= Supabase.instance.client;
  dynamic bio;
  String? banner;
  String? username;
String? picture;
bool isLoading = false;
  @override
  void initState(){

    if (widget.data != null){
      username = widget.data[0]['username'];
    selected = colors[widget.data[0]['theme']];
    bio = widget.data[0]['bio'];
 bioController = TextEditingController(text: bio);
setState(() {
  
});
    }
    super.initState();
  }
    final ImagePicker picker = ImagePicker();
    Future<File?> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> pickFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
  dynamic bannerFile;
  dynamic pictureFile;
  dynamic savedBio;
  dynamic savedTheme;
  dynamic pickedImage;
    void showImagePickerOptions(type) {

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
                    //final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      if (type != 'banner'){
              pictureFile = image;
              //await image.readAsBytes();
                      } else {
bannerFile = image;
//await image.readAsBytes();
                      }
                   setState(() {
                     
                   });
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
  TextEditingController bioController = TextEditingController();
  Future<void> updateProfile() async {
    
 
   await supabase.from('profile')
   .update({'bio': RegExp(r'^\s*$').hasMatch(bioController.text) ? null : bioController.text, 'theme':colors.indexOf(selected),
   'picture':(pictureFile!=null || widget.picture != null), 'banner':(bannerFile!=null || widget.banner!=null)
   })

   .eq('user_id', supabase.auth.currentUser?.id ?? 1);
   savedBio = true;
   savedTheme = true;
 
  }
Future<void> updateBanner(id, file) async {
final path = 'banner/$id.png';
// await supabase.storage.from('profile').upload(path, file, fileOptions: FileOptions(upsert: true));
await supabase.storage.from('profile').upload(path, file, fileOptions: FileOptions(upsert: true));
}
Future<void> updatePic(id, file) async {
final path = 'picture/$id.png';
// await supabase.storage.from('profile').upload(path, file, fileOptions: FileOptions(upsert: true));
await supabase.storage.from('profile').upload(path, file, fileOptions: FileOptions(upsert: true));
}
List<Color> colors = [Colors.red, const Color.fromARGB(255, 246, 95, 145),  const Color.fromARGB(255, 255, 177, 203),  Colors.orange, Colors.yellow, Colors.green, Colors.blue,
 const Color.fromARGB(255, 172, 216, 248),  const Color.fromARGB(255, 144, 80, 255),
const Color.fromARGB(255, 195, 166, 246),Colors.grey,
Colors.black, 
 ];
 Color selected = Colors.red;


  @override
  Widget build (BuildContext context){
        final width = MediaQuery.of(context).size.width;

  return Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
    body: SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          // height:height+MediaQuery.of(context).viewInsets.bottom,
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
                                    List themebio = savedBio == null && savedTheme == null ? [null, null,
                                     (widget.banner == null ? bannerFile : null ),  (widget.picture == null ? pictureFile : null )]
                                     : [widget.data[0]['bio'] == savedBio ? null : RegExp(r'^\s*$').hasMatch(bioController.text) ? null : bioController.text
                               , 
                        colors[widget.data[0]['theme']] == savedTheme ? null : colors.indexOf(selected), 
                         (widget.banner == null ? bannerFile : null ),  (widget.picture == null ? pictureFile : null )
                        ];
                     print('themmebio: $themebio');
                               Navigator.pop(context, themebio);
                                    } else {
                                         Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => MyApp(selectedIndex: 2,),
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
                  Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins', color: 
                                                                     const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                                        fontSize: 22),),
                          SizedBox(height: 30,),
             GestureDetector(
          onTap: (){
            showImagePickerOptions('banner');
          },
           child:
           
            Stack(
             children: [
              bannerFile == null  ?
               Container(
                                            width: width,
                                            height: 130,
                                            decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 199, 217),
                                            image: 
                                            widget.banner == null && widget.bannerFile ==null ? null :
                                            DecorationImage(image: widget.bannerFile==null ?  NetworkImage(widget.banner??'')
                                            
                                            : FileImage(widget.bannerFile), fit: BoxFit.cover),
                                             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(20))),
                                             
                                          )
                                           :
              Container(
                                            width: width,
                                            height: 130,
                                            
                                            decoration: BoxDecoration(
                                               image: DecorationImage(image: FileImage(bannerFile), fit: BoxFit.cover ),
                                              color: const Color.fromARGB(255, 255, 199, 217), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(20))),
                                             
                                          )
           
           ,
                       Positioned(
                        
                        child: 
                         Container(
                                            width: width,
                                            height: 130,
                                            decoration: BoxDecoration(color: const Color.fromARGB(255, 98, 98, 98).withAlpha(30), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(20))),
                                                 child: Center(
                                            child: Icon(Icons.camera_alt, size: 50, color: const Color.fromARGB(255, 63, 63, 63)),
                                          ),   
                                          ),
                       )                 
             ],
           )
             ),                      
                          
                          SingleChildScrollView(
                            child: SizedBox(
                          
                              child: Column(
                                children: [
                              
                              SizedBox(height: 90,),     
                                           
                                             Align(
                                                    alignment: Alignment.topLeft,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                        child: Text('Bio', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
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
                                              maxLines: 1,
                                            maxLength: 80,
                                            
                                             controller: bioController,
                                            decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hint: Text('Bio...', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                                           const Color.fromARGB(255, 111, 111, 111),
                                                                                                              fontSize: 15)),
                                            ),
                                            style: TextStyle(fontFamily: 'Poppins', color: 
                                                                           const Color.fromARGB(255, 0, 0, 0),
                                                                                                              fontSize: 16)
                                              ),
                                            ) ,
                                             SizedBox(height: 20,),     
                                           
                                             Align(
                                                    alignment: Alignment.topLeft,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                        child: Text('Color scheme', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0),
                                                                                                                                          fontSize:18, fontWeight: FontWeight.bold),),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 30,),
                                                  SizedBox(
                                                    height: 240,
                                                      width:width-85,
                                                    child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: MediaQuery.of(context).size.width > 700 ? 8: 4), 
                                                    itemCount: colors.length,
                                                    itemBuilder: (context, index){
                                                    return GestureDetector(
                                                      onTap: (){
                              setState(() {
                                selected=colors[index];
                              });
                                                      },
                                                      child: Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: colors[index] == selected ? Border.all(color: colors[index], width: 3, ) : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors[index]
                                    ),
                                                
                                  ),
                                ),
                              ),
                                                      ),
                                                    );
                                                    }),
                                                  ),
                                                  SizedBox(height: 30,),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 20),
                                                      child: Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: GestureDetector(
                              onTap: () async {
                                         if (bioController.text == widget.data[0]['bio'] && colors.indexOf(selected) == widget.data[0]['theme'] && bannerFile == null && pictureFile == null){
                                        return;
                                }
                                if (!isLoading ){
                                  isLoading = true;

                                   await  updateProfile();
                                try{
                                if (bannerFile != null){
                                        await updateBanner(supabase.auth.currentUser?.id, bannerFile);
                                } 
                                        if (pictureFile != null){
                                         await  updatePic(supabase.auth.currentUser?.id, pictureFile);
                                        }
                                        
                                                print('pic, $pictureFile $bannerFile ${widget.banner} ${widget.picture}');   
                                             Toast.show(context, 'Update successful. ${
                                         ((widget.banner!= null && widget.picture != null)) ?  bannerFile != null || pictureFile != null ?
                                              'Please wait at most a couple hours for the images to update.' : '' :
                                           (widget.banner== null && widget.picture != null) && pictureFile != null ?
                                              'Please wait at most a couple hours for the images to update.' :
                                                 (widget.picture== null && widget.banner != null) && bannerFile != null ?
                                              'Please wait at most a couple hours for the images to update.' : '' 
                                              }', false);
                                } catch (e) {
                                  print('error  $e');
                                        Toast.show(context, 'Update failed!', true);
                                }
                                isLoading = false;
                              }
                              },
                              child:  Container(
                                                      width: 130,
                                                      height: 50,
                                                    decoration: BoxDecoration(
                                                      color:   const Color.fromARGB(255, 255, 209, 224),
                                                      border: Border.all(color:    const Color.fromARGB(255, 246, 95, 145), width: 2, ), 
                                                      borderRadius: BorderRadius.circular(25),
                                                    ), child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Center(
                              child: Text('Save', style: TextStyle(fontFamily: 'Poppins', 
                                    decoration: TextDecoration.none,
                                    color: const Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold, fontSize: 16),),
                                                      ),
                                                    ),
                                                    ),
                                                      ),
                                                    )
                                                    ),
                                                  ),
                                                  ],
                                                ),
                            ),
                          ),
                    ]),
                ),
              ),
                  Positioned(
                                  left: 20,
                                  top: 190,
                                  child:     Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     GestureDetector(
                                      onTap: (){
            showImagePickerOptions('profile');
          },
                                       child:
                                     
                                        Stack(
                                          children: [
                                          pictureFile == null ?
                                            Container(
                                                              width: 90,
                                                              height: 90,
                                                              decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(25),
                                                               border: Border.all(color: Colors.white),
                                                                color:   const Color.fromARGB(255, 196, 163, 254),
                                                                image:
                                                                widget.picture == null && widget.pictureFile == null? null :
                                                                 DecorationImage(image: 
                                                                 widget.pictureFile == null? 
                                                                 NetworkImage(widget.picture??'') : FileImage(widget.pictureFile), fit: BoxFit.cover)
                                                              ),
                                                            
                                                                 ) 
                                                                 : 
                                         Container(
                                                              width: 90,
                                                              height: 90,
                                                              decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(25),
                                                             color: const Color.fromARGB(255, 98, 98, 98).withAlpha(30),
                                                             image: DecorationImage(image: FileImage(pictureFile) , fit: BoxFit.cover),
                                                              ),
                                                           
                                                                 )
                                                               
                                                                 ,
                                                                  Container(
                                                              width: 90,
                                                              height: 90,
                                                              decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(25),
                                                             color: const Color.fromARGB(255, 98, 98, 98).withAlpha(30),
                                                              ),
                                                              child: Icon(Icons.camera_alt, size: 40, color: const Color.fromARGB(255, 63, 63, 63),),
                                                                 ),
                                                              ]
                                        )
                                        
                                        ,
                                     ),
                                                           
                               SizedBox(width: 20),
                               Column(
                                 children: [
                                  SizedBox(height: 30,),
                                   Text('@${username}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold,
                                   fontSize: 22, color: Colors.black),),
                                 ],
                               ),
                                    ],
                                  ),),
            ],
          ),
        ),
      ),
    ),
        );
  }
}