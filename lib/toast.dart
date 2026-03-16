import 'package:flutter/material.dart';


class Toast {
  static void show(
    BuildContext context,
    String message,
    bool error,
    
     {
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
   
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
width: MediaQuery.of(context).size.width-50,

decoration: BoxDecoration(
  border: Border.all(color: error ? Colors.red : const Color.fromARGB(255, 190, 156, 250), width: 2),
  color:  error ? const Color.fromARGB(255, 255, 196, 192) : const Color.fromARGB(255, 244, 237, 255),

  borderRadius: BorderRadius.circular(10)
),
child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
  child: Center(child: Row(
    children: [
      Icon(error ? Icons.error : Icons.check_circle, color: error ? Colors.red : const Color.fromARGB(255, 190, 156, 250), size: 20,),
      SizedBox(width: 10,),
      Expanded(
        child: Text(message, style: TextStyle(fontFamily: 'Poppins', 
        decoration: TextDecoration.none,
        color:   error ? Colors.red : const Color.fromARGB(255, 190, 156, 250), fontWeight: FontWeight.bold, fontSize: 14),),
      ),
    ],
  )),
),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
