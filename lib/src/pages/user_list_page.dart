import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_gbp/src/models/user_model.dart';
import 'package:prueba_gbp/src/pages/user_activities_page.dart';
import 'package:prueba_gbp/src/providers/user_provider.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text("Prueba GBP"),
          centerTitle: true,
        ),
        body: Container(child: userListWidget(context)),
      ),
    );
  }

  Widget userListWidget(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder(
      future: userProvider.getUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<UserModel> users = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: users.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return card(context, users[index]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Card card(BuildContext context, UserModel user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: listTile(context, user),
      ),
    );
  }

  ListTile listTile(BuildContext context, UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: (user.avatarUrl == null)
            ? AssetImage("assets/no-image.png")
            : NetworkImage(user.avatarUrl),
      ),
      title: Text(
        user.login,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.htmlUrl,
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    UserActivitiesPage(user: user)));
      },
    );
  }
}
