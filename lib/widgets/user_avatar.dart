import 'package:flutter/material.dart';
import 'package:onboarding_project/models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final double radius;

  const UserAvatar({
    super.key,
    required this.user,
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
            backgroundImage: NetworkImage(user.image),
            child: Icon(Icons.person, size: radius)),
      ),
    );
  }
}
