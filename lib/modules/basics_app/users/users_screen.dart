import 'package:flutter/material.dart';
import 'package:flutter_app0/models/user/user_model.dart';

class UsersModel extends StatelessWidget {
  List<UserModel> users = [
    UserModel(id: 1, name: 'abdelkader rafat', phone: '01025265653'),
    UserModel(id: 2, name: 'ahmed rafat', phone: '010656523556'),
    UserModel(id: 3, name: 'ali ahmed', phone: '010565656888'),
    UserModel(id: 4, name: 'mohamed ahmed', phone: '012656565656'),
    UserModel(id: 5, name: 'osama ali', phone: '01165668556'),
    UserModel(id: 6, name: 'ali tarek', phone: '01025265653'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'users',
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => buildUserItem(users[index]),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: users.length),
    );
  }

  Widget buildUserItem(UserModel user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              child: Text(
                '${user.id}',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${user.phone}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      );
}
