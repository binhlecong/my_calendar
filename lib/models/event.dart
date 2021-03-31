import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Event {
  int id;
  String startTime;
  String endTime;
  String subject;
  String location;
  int color;

  Event({
    this.id,
    this.startTime,
    this.endTime,
    this.subject,
    this.location,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'subject': subject,
      'location': location,
      'color': color,
    };
  }

  Event.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    startTime = map['startTime'];
    endTime = map['endTime'];
    subject = map['subject'];
    location = map['location'];
    color = map['color'];
  }

  Appointment toAppointment() {
    Appointment appointment = Appointment(
      startTime: DateTime.parse(startTime),
      endTime: DateTime.parse(endTime),
      subject: subject,
      location: location,
      color: getColor(color),
    );
    return appointment;
  }

  Color getColor(int color) {
    switch (color) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
