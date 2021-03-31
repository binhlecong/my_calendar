import 'package:flutter/material.dart';
import 'package:my_calendar/models/event.dart';

class EventCard extends StatelessWidget {
  final int id;
  final String start;
  final String end;
  final String subject;
  final int color;

  EventCard({this.id, this.start, this.end, this.subject, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: 60,
      decoration: BoxDecoration(color: Color(0x9988f0ff)),
      child: ListTile(
        leading: Icon(
          Icons.star,
          color: Event().getColor(color),
          size: 36,
        ),
        title: Text(
          subject,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              _extractDate(start),
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text('  '),
            Text(_extractTime(start)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _extractDate(String rawDate) {
    DateTime date = DateTime.parse(rawDate);
    return date.day.toString() +
        '/' +
        date.month.toString() +
        '/' +
        date.year.toString();
  }

  String _extractTime(String rawDate) {
    DateTime date = DateTime.parse(rawDate);
    return date.hour.toString() + ':' + date.minute.toString();
  }
}
