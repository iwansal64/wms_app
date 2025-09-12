import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(child: const Text("Aww man :(", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, decoration: TextDecoration.none),),)
    );
  }
}