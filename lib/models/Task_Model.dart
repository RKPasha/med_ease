import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<TaskModel> postModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String postModelToJson(List<TaskModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


//This file was copied from previous project

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
    required this.isDeleted,
    required this.date,
    required this.deadline,
  });

  String id;
  String title;
  String description;
  String status;
  String isDeleted;
  String date;
  String deadline;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        date: json["date"],
        deadline: json["deadline"],
        isDeleted: json["isdeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
        "date": date,
        "deadline": deadline,
        "isdeleted": isDeleted
      };

  factory TaskModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return TaskModel(
        id: document.id,
        description: data["TaskDes"],
        status: data["Status"],
        title: data["Task"],
        date: data["Date"],
        deadline: data["DeadLine"],
        isDeleted: data["IsDeleted"]);
  }
}
