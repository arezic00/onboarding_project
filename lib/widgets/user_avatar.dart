import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final double radius;

  const UserAvatar({
    super.key,
    required this.image,
    required this.onTap,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'user-avatar',
        child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(image),
            child: Icon(Icons.person, size: radius)),
      ),
    );
  }
}
