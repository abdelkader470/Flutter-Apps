import 'package:flutter/material.dart';
import 'package:flutter_app0/models/social_app/social_user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({
    this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                userModel.image,
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            // Text(
            //   userModel.name,
            // ),
          ],
        ),
      ),
    );
  }
}
