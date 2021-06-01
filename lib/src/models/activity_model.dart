import 'dart:convert';

ActivityModel activityModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  ActivityModel({
    this.id,
    this.user,
    this.text,
    this.date,
    this.state,
  });

  String id;
  String user;
  String text;
  String date;
  String state;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        user: json["user"],
        text: json["text"],
        date: json["date"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "text": text,
        "date": date,
        "state": state,
      };
}
