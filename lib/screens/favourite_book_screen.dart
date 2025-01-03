import 'package:flutter/material.dart';

class FavouriteBookScreen extends StatefulWidget {
  const FavouriteBookScreen({super.key});

  @override
  State<FavouriteBookScreen> createState() => _FavouriteBookScreenState();
}

class _FavouriteBookScreenState extends State<FavouriteBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Faourite Books",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),),
      ),
    );
  }
}
