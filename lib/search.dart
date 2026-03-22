
import "dart:async";

import 'package:fashion/details.dart';
import 'package:fashion/profile.dart';
import 'package:fashion/tagsearch.dart';
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
    home: SearchPage(),
  ));
}
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
List searchTypes = ["Stories", "Accounts", "Tags"];
bool isLoading = false;
List sampleTagss = ['Beach', 'Moving', 'Casual', ];
dynamic lastStoryCreated;
void storylisten(){
if (storyController.offset >=  (storyController.position.maxScrollExtent)){
 if (hasMoreStories) loadStoriesAfterScrolling();
}
}
@override
void initState(){
    storyController.addListener(storylisten);
    super.initState();
}
List storyResultData = [];
 int getScore(item, splitText){
  
if (item['title'] == searchController.text){
  return 100;
}
if ((item['tags']?? []) .any((tag) => tag == searchController.text)){
  return 96;
}
int score = 0;
for (String word in splitText){
if (item['title'].contains(word) || word.contains(item['title'])){
  score+=10;
}
if ((item['tags'] ?? []).contains(word)){
  score+=15;
}
}
return score.clamp(0, 95);
  }
void loadStoriesAfterScrolling() async {
    List splitText = searchController.text.toLowerCase().split(type == "Stories" || type == 'Tags' ? RegExp(r'\s+'):RegExp(r''));
  List storyData = [];
      List<String> altSplitText = splitText.map((e)=>'%$e%').toList();
    dynamic containsTitle = await supabase.from('story').select().ilikeAnyOf('title', altSplitText).not('draft', 'is', true)
    .gt('created_at', lastStoryCreated).order( 'created_at', ascending: true).limit(10);
dynamic containsTag = await supabase.from('story').select()
.not('draft', 'is', true)
.overlaps('tags', splitText)
.gt('created_at', lastStoryCreated).order('created_at', ascending: true).limit(10);
storyData= {
  for (var id in ([...storyData, ...containsTag, ...containsTitle]))
   id['id']: id}.values.toList();
 storyData.sort((a,b)=>a['created_at'].compareTo(b['created_at']));
lastStoryCreated = storyData.last['created_at'];
   
 
storyData.sort((a,b) => getScore(b, splitText).compareTo(getScore(a, splitText)));

storyResultData = [...storyResultData, ...storyData.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')})];


if (containsTitle.length<10 && containsTag.length<10){
  hasMoreStories=false;
  storyController.removeListener(storylisten);
}
setState(() {
  
});
}
bool hasMoreStories = true;
List genreResult = [];
ScrollController genreController = ScrollController();
bool hasMoreTags = true;
 final supabase = Supabase.instance.client;
ScrollController storyController = ScrollController();

int getTagscore(tag, splitText){
  if (tag == searchController.text){
    return 100;
  }
  int score = 0;
  for (String letter in splitText){
    if (tag.contains(letter) || letter.contains(tag)){
      score+=5;
    }
  }

  return score.clamp(0, 99);
}
// void loadTagsAfterScrolling() async {
//     List splitText = searchController.text.toLowerCase().split(RegExp(r''));
//   List storyData = [];
//       List<String> altSplitText = splitText.map((e)=>'%$e%').toList();
//     dynamic containsGenre = await supabase.from('tags').select().ilikeAnyOf('tag', altSplitText)
//     .gt('created_at', lastStoryCreated).order( 'created_at', ascending: true).limit(10);

// storyData= {
//   for (var id in ([...storyData, ...containsTag, ...containsTitle]))
//    id['id']: id}.values.toList();
//  storyData.sort((a,b)=>a['created_at'].compareTo(b['created_at']));
// lastStoryCreated = storyData.last['created_at'];
   
 
// storyData.sort((a,b) => getScore(b, splitText).compareTo(getScore(a, splitText)));

// storyResultData = [...storyResultData, ...storyData];


// if (containsTitle.length<2 && containsTag.length<2){
//   hasMoreStories=false;
// }
// setState(() {
  
// });
// }
List sampleStoryData = [
{'title':'Beachy days', 'tags':['beachy']},
{'title':'City life', 'tags':['beachy']},{'title':'Beach Bonfire', 'tags':['city', 'beach']}
,{'title':'Shipwreck', 'tags':['scary']},
 ];
 List accountData = [];

 List sampleAccountData = ['anabucci', 'buccijr', 'sweetlittlebunny', 'anacrissiq', 'mermaixd', 'seasalt', 'beachygirl'];
 void searchData(String value, type)async{
  isLoading = true;
   List splitText = value.toLowerCase().split(type == "Stories"  || type == 'Tags' ? RegExp(r'\s+'):RegExp(r''));

   
splitText.removeWhere((e)=> e.trim().isEmpty);

  Map scoreMap = {};
  List storyData = [];
  if (type == "Stories"){
  
  
    List<String> altSplitText = splitText.map((e)=>'%$e%').toList();
   
dynamic containsTitle= await supabase.from('story')

.select().ilikeAnyOf('title', altSplitText)
.not('draft', 'is', true)
.order( 'created_at', ascending: true).limit(20);
dynamic containsTag = await supabase.from('story').select()

.not('draft', 'is', true).overlaps('tags', splitText).order( 'created_at', ascending: true).limit(20);

storyData= {
  for (var id in ([...storyData, ...containsTag, ...containsTitle]))
   id['id']: id}.values.toList();
 storyData.sort((a,b)=>a['created_at'].compareTo(b['created_at']));

   lastStoryCreated = storyData.isNotEmpty? storyData.last['created_at'] : null;
storyData.sort((a,b) => getScore(b, splitText).compareTo(getScore(a, splitText)));
  
  storyResultData = storyData.map((e)=> {...e, 'cover':supabase.storage.from('stories').getPublicUrl('cover/${e['id']}.png')}).toList();
  
    
  showingResults=true;
  setState(() {
    
  });
  } else if (type == 'Tags'){
 List<String> altSplitText = splitText.map((e)=>'%$e%').toList();
dynamic equalsGenre= await supabase.from('tags').select().eq('tag', value.toLowerCase()).limit(1);
 dynamic containsGenre= await supabase.from('tags').select().ilikeAnyOf('tag', altSplitText).neq('tag', value.toLowerCase()).limit(20);

int getTagscore(tag, splitText){
  if (tag == value){
    return 100;
  }
  int score = 0;
  for (String letter in splitText){
    if (tag.contains(letter) || letter.contains(tag)){
      score+=5;
    }
  }

  return score.clamp(0, 99);
}
containsGenre.sort((a,b) => getTagscore(b['tag'], splitText).compareTo(getTagscore(a['tag'], splitText)));

genreResult = [...equalsGenre, ...containsGenre];

  showingResults=true;
  
setState(() {
  
});
  } else if (type == "Accounts"){
    List<String> getProfileList(String letter){
List<String> listofAll = [];
for (int c=1; c<letter.length+1; c++){
String newWord = letter.split('').sublist(0, c).join();
if (newWord.length >= 3){
  listofAll.add('%$newWord%');
}
}
listofAll.removeWhere((e) => !letter.contains(e.replaceAll('%', '')));
return listofAll;
}
 List<String> acceptableUsernames = getProfileList(value.replaceAll(RegExp(r'\s+'), ''));
dynamic equalsName= await supabase.from('profile').select().eq('username', value.toLowerCase()).limit(1);
 dynamic containsName= await supabase.from('profile').select().ilikeAnyOf('username',acceptableUsernames
 ).neq('username', value.toLowerCase()).limit(20);

int getNameScore(String username){
  int score=0;
  for (String letter in value.toLowerCase().split('')){
if (username.contains(letter)){
  score+=5;
}
  }
  return score;
}
containsName.sort((a,b) => getNameScore(b['username']).compareTo(getNameScore(a['username'])));

accountData = [...equalsName, ...containsName];

  showingResults=true;
  
setState(() {
  
});

  } else {
  List includedInSearch = (type == 'Stories' ? sampleStoryData : type == 'Tags' ? sampleTagss: sampleAccountData).where((sample) {
    
    sample = (type == 'Stories' ? sample['title'] : sample as String).toLowerCase();

  
bool hasTags(){
  if (type != 'Stories'){
    return true;
  } 
List findSample = sampleStoryData.where((story) => story['title'].toLowerCase() == sample).singleOrNull['tags'];
for (final word in splitText){
return findSample.any((tag) =>  tag.contains(word) );
}
return false;
}

bool equalTags(){
  if (type != 'Stories'){
    return true;
  } 
List findSample = sampleStoryData.where((story) => story['title'].toLowerCase() == sample).singleOrNull['tags'];
for (final word in splitText){
return findSample.any((tag) =>  tag == (word) );
}
return false;
}
if (!splitText.any((e)

{

  
  return sample.contains(e); }) && 
!hasTags()
){
  
  return false;
} 

  int getScore(String letter){
int localScore = 0;
int getProfileList(){
List listofAll = [];
for (int i=0; i<splitText.length+1; i++){
for (int c=0; c<splitText.length+1; c++){
  if (c>i){
String newWord = splitText.sublist(i, c).join();

if (newWord.length >= 3){
  listofAll.add(newWord);
}
}
}
}
listofAll.removeWhere((e) => !letter.contains(e));

return listofAll.isEmpty ? 0 :listofAll.reduce((value,element) => element.length>value.length ? element:value).length;
}
for (final text in splitText){
  localScore = localScore+=(type == "Stories" ?  ((sample.split(RegExp(r'\s+'))as List).any((e) { return e==text;}) ?5:0) : 
getProfileList()
  
   );
  
}
for (final text in splitText){
  localScore = localScore+=(type == "Stories" ?  ((sample.split(RegExp(r'\s+'))as List).any((e) { return e.contains(text) || text.contains(e);}) ?3:0) : 
0);
  
}


if(type =="Stories" && hasTags()){
    localScore += equalTags() ? 5: 4;
}
    return localScore;

  }
int score =  (sample == value ? 100 : type== 'Tags' ? sample.contains(value.toLowerCase())  ? 5 : 0 :getScore(sample))
.clamp(0, 100);

 if ( score>0){
scoreMap[ sample] = score;
 } else {
return false;
 }
return true;
  }).toList();

  includedInSearch.sort((a,b){ 
  
    return scoreMap[type == 'Stories' ? b['title'].toLowerCase() : b.toLowerCase()].compareTo(scoreMap[type == 'Stories' ? a['title'].toLowerCase(): a.toLowerCase() ]);});
    showingResults=true;
    
    resultData = includedInSearch;

    
    setState(() {
      
    });}
    isLoading=false;
 }
 List resultData = [];
String type = "Stories";
bool canSearch = true;
bool showingResults = false;
  Color lightPurple =  Color.fromARGB(255, 145, 87, 232);
Color darkPurple = Color(0xFF8743F0);

  @override
  Widget build (BuildContext context){
  
 
  return Scaffold(
  
backgroundColor: const Color.fromARGB(255, 248, 248, 248),


    body:  SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
        
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: 
            Stack(
                       children: [
                           Positioned(
                        left: 0,
                        top: 10,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
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
                          )
                        )),
                         Center(
                           child: Column(
                            children: [
                              SizedBox(height: 13,),
                            Text('Search', style: TextStyle(fontFamily: 'Poppins', color: 
                                                                       const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                                          fontSize: 18),),        
                            SizedBox(height:  50,),
                            Container(
                                     
                                    width:double.infinity,
                                    decoration: BoxDecoration(
                                     border: Border.all(color: const Color.fromARGB(255, 195, 166, 246), width: 2 ),
                                     borderRadius: BorderRadius.circular(10) 
                                    ),
                                    child:  TextField(
                                      controller: searchController,
                                      onSubmitted: (value) {
          storyResultData = [];
          if (value.length >= 2 && canSearch){
            canSearch = false;
            Timer(const Duration(seconds: 2), () {
              canSearch = true;
            });
          searchData(value, type);
          }
                                      },
                                                                 
                                                              
                                                              decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                              hint: Text('What are you searching for?', style:   TextStyle(fontFamily: 'Poppins', color: 
                                                               const Color.fromARGB(255, 147, 147, 147),
                                                                                                  fontSize: 15.5)),
                                    prefixIcon: Icon(CupertinoIcons.search, color: const Color.fromARGB(255, 195, 166, 246), )
                                                              ),
                                                              style: TextStyle(fontFamily: 'Poppins', color: 
                                                               const Color.fromARGB(255, 0, 0, 0),
                                                                                                  fontSize: 16)
                                                                    ),
          
                                  )      , 
                                !showingResults ? 
                                
                             SizedBox.shrink()
                                 :  Column(
                                    children: [
                                  
                                  SizedBox(height: 30,),
                                  Align(
                        alignment: Alignment.centerLeft,
                                    child: Text('Results', style: TextStyle(fontFamily: 'Poppins', color: 
                                                                         const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                                                                            fontSize: 23),),
                                  ),  
                                                  SizedBox(height: 20,),
          Row(
                                children:searchTypes.map((entry){
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
          onTap: (){
            setState(() {
          type = entry;
          if (showingResults) entry == 'Stories' ? storyResultData.isEmpty ? searchData(searchController.text, type) : storyResultData : searchData(searchController.text, type);
            });
          },
                          child: Container(
                            width: MediaQuery.of(context).size.width>600 ? 120: 105,
                          decoration: BoxDecoration(
                            color: entry == type ?  const Color.fromARGB(255, 255, 209, 224) : null,
                            border: Border.all(color:    const Color.fromARGB(255, 246, 95, 145), width: 2, ), 
                            borderRadius: BorderRadius.circular(25),
                          ), child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(entry, style: TextStyle(fontFamily: 'Poppins', 
                                    decoration: TextDecoration.none,
                                    color: const Color.fromARGB(255, 246, 95, 145), fontWeight: FontWeight.bold, fontSize: 13.5),),
                            ),
                          ),
                          ),
                        ),
                      );
                                  }).toList()),
                       SizedBox(height:   resultData.isEmpty && (type == 'Stories' ? storyResultData.isEmpty : true)
                        && (type == 'Tags' ? genreResult.isEmpty : true) && (type == 'Accounts' ? accountData.isEmpty : true)
                        ? 150 :20,),
                       resultData.isEmpty && (type == 'Stories' ? storyResultData.isEmpty : true)  && (type == 'Tags' ? genreResult.isEmpty : true)
                        && (type == 'Accounts' ? accountData.isEmpty : true)
                        ? 
                       !isLoading ? 
                        Center(child: Column(
                         children: [
                           Icon(Icons.search_off, color:const Color.fromARGB(255, 195, 166, 246), size: 60, ),
                           SizedBox(height: 10,),
                           Text('No Results', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 195, 166, 246), fontWeight: FontWeight.bold,
                                              fontSize: 26))
                         ],
                       )) 
                       : CircularProgressIndicator(color: const Color.fromARGB(255, 195, 166, 246))
                       :
                         SizedBox(
                          
                              height: MediaQuery.of(context).size.height*0.67,
                               child: type == "Stories" ? GridView.builder(
                              
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, crossAxisSpacing: 10, mainAxisSpacing:3,
                                childAspectRatio: 0.6
                                ),
                                controller: storyController,
                                itemCount: storyResultData.length,
                                itemBuilder: (context, index){
                               return   
                                   Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child:
                                      
                                      
                                      GestureDetector(
                                        onTap: () async {
         
          
             final results = await Future.wait([

supabase.from('slide').select().eq('story_id',storyResultData[index]['id']),
supabase.from('options').select().eq('story_id', storyResultData[index]['id']),
if (Supabase.instance.client.auth.currentUser == null)  Future.value([]) else supabase.from('likes').select().eq('target_id', storyResultData[index]['id'])
                                            .eq('user_id', supabase.auth.currentUser?.id ??0),
                                            supabase.from('story').select('comments, likes').eq('id', storyResultData[index]['id']),
                                            ]
                                            
                                            );
           
                                                Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(
                             data: {...storyResultData[index],'likes': results[3][0]['likes'], 'comments':results[3][0]['comments']}, 
                             slideData: results[0], optionData:results[1], hasLiked: 
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
                                          width: double.infinity, 
                                        
                                          decoration: BoxDecoration(
                                            image:
                                            ! (storyResultData[index]['hasCover']??false)?null: 
                                             DecorationImage(image: NetworkImage(storyResultData[index]['cover']), fit: BoxFit.cover),
                                          border: Border.all(color: const Color.fromARGB(255, 195, 166, 246)),
                                          color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: 
                                              (storyResultData[index]['hasCover']??false) ? SizedBox.shrink():
                                              Text(storyResultData[index]['title'] ?? '', style: 
                                              TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                              fontSize: 23, overflow: TextOverflow.ellipsis), maxLines: 3,),
                                            ),
                                          ),
                                          ),
                                        ),
                                      
                                   
                                  
                                );
                                             }) : 
                                             type== 'Tags' ?
                                   ListView.builder(
                              
                                
                                itemCount:genreResult.length,
                                itemBuilder: (context, index){
                               return   
                                   Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child:
                                      
                                      
                                      GestureDetector(
                                          onTap: () {
                                        
                                              Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => TagSearch(tag: genreResult[index]['tag'],),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                                          },
                                          child: Container(
                                          width: double.infinity, 
                                        
                                          decoration: BoxDecoration(
                                          border: Border.all(color:  const Color.fromARGB(255, 190, 156, 250),),
                                          color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                   Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(25),
                                                         border: Border.all(color: const Color.fromARGB(255, 190, 156, 250), width: 2),
                                                          color:    const Color.fromARGB(255, 244, 237, 255),
                                                        ),
                                                        child: Center(child: Text('#', style: TextStyle(fontSize: 22, color:const Color.fromARGB(255, 190, 156, 250), fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.bold),)),
                                                           ),
                                                           SizedBox(width: 25,),
                                                  Text(genreResult[index]['tag'] ?? '', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                  fontSize: 24),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),
                                      
                                   
                                  
                                );
                                             }):             
                                           ListView.builder(
                              
                                
                                itemCount: accountData.length,
                                itemBuilder: (context, index){
                               return   
                                   Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child:
                                      
                                      
                                      GestureDetector(
                                       onTap: () async {
           String banner =supabase.storage.from('profile').getPublicUrl('banner/${ accountData[index]['user_id']}');
          String picture = supabase.storage.from('profile').getPublicUrl('picture/${ accountData[index]['user_id']}');
                                              Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
                                          //  data: usernames[cmnts[index]['author_id']]
                                          banner: banner,
                                          picture: picture,
                                          data: accountData[index],
                                            ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                                              );
                                          }, 
                                          child: Container(
                                          width: double.infinity, 
                                        
                                          decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(255, 195, 166, 246)),
                                          color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  //  Container(
                                                  //       width: 50,
                                                  //       height: 50,
                                                  //       decoration: BoxDecoration(
                                                  //        borderRadius: BorderRadius.circular(25),
                                                  //        border: Border.all(color: Colors.white),
                                                  //         color:    const Color.fromARGB(255, 246, 95, 145)
                                                  //       ),
                                                  //       child: Center(child: Text('A', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Poppins'),)),
                                                  //          ),
                                                  //          SizedBox(width: 20,),
                                                  Text('@${accountData[index]['username'] ?? ''}', style: TextStyle(fontFamily: 'Poppins', color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold,
                                                  fontSize: 24),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),
                                      
                                   
                                  
                                );
                                             })  ,
                             ),           
                                    ]),
                           ],),
                         ),
                       ],
                     )
            ),
        ),
      ),
    ),
    );
        }
        
}