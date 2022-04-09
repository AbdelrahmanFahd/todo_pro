import 'package:flutter/material.dart';

class Task {
  int? id;
  String title;
  String note;
  int color;
  String dateTime;
  String startTime;
  String endTime;
  int reminder;
  String repeat;
  int isComplete;

  Task(
      {this.id,
      required this.title,
      required this.note,
      required this.color,
      required this.dateTime,
      required this.startTime,
      required this.endTime,
      required this.reminder,
      required this.repeat,
      required this.isComplete});

  Task toTask(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      color: map['color'],
      dateTime: map['dateTime'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      reminder: map['reminder'],
      repeat: map['repeat'],
      isComplete: map['isComplete'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'color': color,
      'dateTime': dateTime,
      'startTime': startTime,
      'endTime': endTime,
      'reminder': reminder,
      'repeat': repeat,
      'isComplete': isComplete,
    };
  }
}
