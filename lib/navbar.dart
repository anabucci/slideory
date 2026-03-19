

import 'dart:ui';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final String current;
  final Function(String) onTabSelected;


  final tabs = const [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    // {'icon': Icons.explore_rounded, 'label': 'Notifications'},
  
    // {'icon': Icons.shopping_cart, 'label': 'Shop'},
        {'icon': Icons.add, 'label': 'Add'},
      // {'icon': Icons.bookmark, 'label': 'Collections'},
       {'icon': Icons.person, 'label': 'Profile'},
  ];


  const CustomNavBar({
    super.key,
    required this.current,
    required this.onTabSelected,
  });

  

  @override
  Widget build(BuildContext context) {
   double navheight = MediaQuery.of(context).size.height * 0.095;

    return Positioned(
      bottom: 0,
      left:0,
      right: 0,
      child: Container(
      decoration: BoxDecoration(
        color:     Colors.white,
             
        // color:    Color.fromARGB(255, 219, 210, 255),
        
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
      ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            
            children: [
              // Divider(color: purpleColor, thickness: 1,),
              Container(
                height: navheight,
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(20),
                  
                 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: tabs.map((tab) {
                    final label = tab['label'] as String;
                    final icon = tab['icon'] as IconData;
                    final isSelected = current == label;
              
                    return GestureDetector(
                      onTap: () => onTabSelected(label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width:  40,
                        height:navheight,
                      
                        child: Stack(
                          
          
                                                children: [
          // isSelected ?  Positioned(
          //   top: 0,
          //   child: Container(
          //   width: 40,
          //   height: 5,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
          //     bottomRight: Radius.circular(10)
          //     ),
          //     color:  const Color.fromRGBO(173, 142, 227, 1),
          //     // color:const Color.fromARGB(255, 195, 166, 246)
          //   ),
          //     ),
          // ) : SizedBox.shrink(),
                            Column(
                               mainAxisAlignment: MainAxisAlignment.center,
          
          crossAxisAlignment: CrossAxisAlignment.center, 
                              children: [
                                Center(
                                  child: Stack(
                                    children: [
                                  
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          
                                          Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Icon(
                                              shadows:  isSelected ? [Shadow(color:  const Color.fromARGB(255, 173, 142, 227), blurRadius: 25 )]:[],
                                              icon,
                                              size: isSelected ? 35 : 35,
                                              color: isSelected
                                                  // ? const Color.fromARGB(255, 195, 166, 246)
                                                  
                                                  ?   const Color.fromARGB(255, 255, 127, 170)
                                                  : const Color.fromARGB(255, 215, 215, 215)
                                            ),
                                          ),
                                           
                                        ],
                                      ),
                                         
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        
                            
                            
                          ],
                        ),
                      ),
                    );
                  //      return GestureDetector(
                  //   onTap: () => onTabSelected(label),
                  //   child: AnimatedContainer(
                  //     duration: const Duration(milliseconds: 250),
                  //     curve: Curves.easeOut,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(18),
                  //       color: isSelected
                  //           ? const Color.fromARGB(255, 234, 117, 255)
                  //               .withOpacity(.15)
                  //           : const Color.fromARGB(0, 255, 255, 255),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         AnimatedScale(
                  //           duration: const Duration(milliseconds: 200),
                  //           scale: isSelected ? 1.15 : 1,
                  //           child: Icon(
                  //             icon,
                  //             size: label == "Add" ? 32 : 26,
                  //             color: isSelected
                  //                 ? const Color.fromARGB(255, 250, 111, 157)
                  //                 : Colors.grey[400],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:ui';
// import 'package:flutter/material.dart';

// class CustomNavBar extends StatelessWidget {
//   final String current;
//   final Function(String) onTabSelected;


//   final tabs = const [
//     {'icon': Icons.home_rounded, 'label': 'Home'},
//     {'icon': Icons.explore_rounded, 'label': 'Notifications'},
  
//     // {'icon': Icons.shopping_cart, 'label': 'Shop'},
//         {'icon': Icons.add, 'label': 'Add'},
//       {'icon': Icons.event_note_rounded, 'label': 'Listings'},
//        {'icon': Icons.person, 'label': 'Profile'},
//   ];


//   const CustomNavBar({
//     super.key,
//     required this.current,
//     required this.onTabSelected,
//   });

  

//   @override
//   Widget build(BuildContext context) {
   
// Color purpleColor = Color.fromARGB(255, 255, 255, 255);
//     return Positioned(
//       bottom: 25,
//       left: 10,
//       right: 10,
//       child: Container(
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 255, 215, 229).withAlpha(150),
//         // color:    Color.fromARGB(255, 219, 210, 255),
        
//         borderRadius: BorderRadius.circular(20)
//       ),
//         child: Column(
          
//           children: [
//             // Divider(color: purpleColor, thickness: 1,),
//             Container(
//               height: 72,
//               decoration: BoxDecoration(
                
//                 borderRadius: BorderRadius.circular(20),
                
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withAlpha(13),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: tabs.map((tab) {
//                   final label = tab['label'] as String;
//                   final icon = tab['icon'] as IconData;
//                   final isSelected = current == label;
            
//                   return GestureDetector(
//                     onTap: () => onTabSelected(label),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       width: isSelected ? 40 : 40,
//                       height: isSelected ? 70 : 70,
                    
//                       child: Stack(
                        

//                                               children: [
// isSelected ?  Positioned(
//   top: 0,
//   child: Container(
//   width: 40,
//   height: 4,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
//     bottomRight: Radius.circular(10)
//     ),
//     color:  const Color.fromARGB(255, 246, 95, 145),
//     // color:const Color.fromARGB(255, 195, 166, 246)
//   ),
//     ),
// ) : SizedBox.shrink(),
//                           Column(
//                              mainAxisAlignment: MainAxisAlignment.center,

// crossAxisAlignment: CrossAxisAlignment.center, 
//                             children: [
//                               Center(
//                                 child: Stack(
//                                   children: [
                                
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Icon(
//                                           icon,
//                                           size: isSelected ? 40 : 28,
//                                           color: isSelected
//                                               // ? const Color.fromARGB(255, 195, 166, 246)
                                              
//                                               ?  const Color.fromARGB(255, 246, 95, 145)
//                                               : const Color.fromARGB(255, 240, 240, 240),
//                                         ),
                                         
//                                       ],
//                                     ),
                                       
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
                      
                          
                          
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

