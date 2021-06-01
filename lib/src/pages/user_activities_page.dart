import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_gbp/src/models/activity_model.dart';
import 'package:prueba_gbp/src/models/user_model.dart';
import 'package:prueba_gbp/src/providers/activities_provider.dart';

// ignore: must_be_immutable
class UserActivitiesPage extends StatefulWidget {
  UserModel user;

  UserActivitiesPage({Key key, @required this.user}) : super(key: key);
  @override
  _UserActivitiesPageState createState() => _UserActivitiesPageState();
}

class _UserActivitiesPageState extends State<UserActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Actividades de usuario"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            String text = "";
            showDialog(
              context: context,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 50),
                child: AlertDialog(
                    title: Text(
                      "Crear Actividad",
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    content: Form(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: TextFormField(
                            initialValue: text,
                            onChanged: (value) => text = value,
                            maxLines: 5,
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Crear",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          activitiesProvider.insertActivity(
                              widget.user.login, text);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                    ]),
              ),
            );
          },
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              cardTitle(widget.user),
              Container(
                child: Text(
                  "Pendientes",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(color: Colors.orange[300]),
                height: 45,
                width: double.infinity,
              ),
              activityWidget(context, widget.user.login, 'pendiente'),
              Container(
                child: Text(
                  "Realizados",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(color: Colors.green[400]),
                height: 45,
                width: double.infinity,
              ),
              activityWidget(context, widget.user.login, 'realizado'),
            ],
          ),
        ),
      ),
    );
  }

  Widget activityWidget(BuildContext context, String user, String state) {
    final activitiesProvider =
        Provider.of<ActivitiesProvider>(context, listen: false);
    return FutureBuilder(
      future: activitiesProvider.getActivities(user, state),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ActivityModel> activity = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activity.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return _cardActivity(activity[index]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Card cardTitle(UserModel user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: listTileTitle(user),
        ),
      ),
    );
  }

  ListTile listTileTitle(UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: CircleAvatar(
        radius: 30,
        // backgroundImage: (user.avatarUrl == null)
        //     ? AssetImage("assets/no-image.png")
        //     : NetworkImage(user.avatarUrl),
        backgroundImage: AssetImage("assets/no-image.png"),
      ),
      title: Text(
        user.login,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.htmlUrl,
                style: TextStyle(color: Colors.grey),
              ),
              //Divider(height: StaticVariables.dividirAlturaListTile),
            ],
          ),
        ],
      ),
      onTap: () {},
    );
  }

  Card _cardActivity(ActivityModel activity) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: _listTileActivity(activity),
        ),
      ),
    );
  }

  ListTile _listTileActivity(ActivityModel activity) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    String estado = activity.state;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: Radio(
        toggleable: true,
        value: estado,
        groupValue: 'realizado',
        onChanged: (value) {
          estado = (estado == 'pendiente') ? "realizado" : "pendiente";
          activity.state =
              (activity.state == 'pendiente') ? "realizado" : "pendiente";
          activitiesProvider.updateState(activity);
          setState(() {});
        },
      ),
      title: Text(
        activity.text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        activity.date.split(" ")[0],
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {},
    );
  }
}
