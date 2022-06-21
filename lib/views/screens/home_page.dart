import 'package:flutter/material.dart';
import 'package:my_calendar/data/db_helper.dart';
import 'package:my_calendar/data/models/event.dart';
import 'package:my_calendar/views/widgets/event_card.dart';
import 'package:my_calendar/views/screens/event_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int cnt = 0;
  String calendarView = 'week';
  List<Appointment> appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    List<Event> events = await _dbHelper.getEvents();
    updateAppointment(events);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BCalender'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Year'),
              trailing: Icon(calendarView == 'year'
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
              onTap: () {
                setState(() {
                  calendarView = 'year';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Month'),
              trailing: Icon(calendarView == 'month'
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
              onTap: () {
                setState(() {
                  calendarView = 'month';
                });
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Week'),
              trailing: Icon(calendarView == 'week'
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
              onTap: () {
                setState(() {
                  calendarView = 'week';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Day'),
              trailing: Icon(calendarView == 'day'
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
              onTap: () {
                setState(() {
                  calendarView = 'day';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: SfCalendar(
          view:
              calendarView == 'month' ? CalendarView.month : CalendarView.week,
          dataSource: _getCalendarDataSource(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1.0,
        child: const Icon(Icons.add_chart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EventPage(
                  event: null,
                );
              },
            ),
          ).then((value) async {
            List<Event> events = await _dbHelper.getEvents();
            updateAppointment(events);
            setState(() {});
          });
        },
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    return _AppointmentDataSource(appointments);
  }

  void updateAppointment(List<Event> events) {
    appointments.clear();
    for (var event in events) {
      appointments.add(event.toAppointment());
    }
  }

  CalendarView setView(String view) {
    return CalendarView.day;
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
