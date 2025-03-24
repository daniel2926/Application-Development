import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({super.key});

  @override
  StarRatingWidgetState createState() => StarRatingWidgetState();  // Make the state public
}

class StarRatingWidgetState extends State<StarRatingWidget> {
  int _rating = 0;

  int get rating => _rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: index < _rating ? Colors.orange : Colors.grey,
            size: 36,
          ),
        );
      }),
    );
  }
}
