import 'package:flutter/material.dart';
import 'package:my_calendar/db_helper.dart';
import 'package:my_calendar/models/event.dart';
import 'package:my_calendar/widgets/event_card.dart';
import 'package:my_calendar/screens/event_page.dart';
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
    return Material(
      child: SlidingUpPanel(
        minHeight: 80,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        collapsed: IconButton(
          icon: Icon(Icons.add_chart),
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
        panel: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getEvents(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EventPage(
                                  event: snapshot.data[index],
                                );
                              },
                            ),
                          ).then((value) async {
                            List<Event> events = await _dbHelper.getEvents();
                            updateAppointment(events);
                            setState(() {});
                          });
                        },
                        child: EventCard(
                          id: snapshot.data[index].id,
                          start: snapshot.data[index].startTime,
                          end: snapshot.data[index].endTime,
                          subject: snapshot.data[index].subject,
                          color: snapshot.data[index].color,
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
        body: Scaffold(
          appBar: AppBar(
            title: Text('My calender'),
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
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(
              bottom: 80,
            ),
            child: SfCalendar(
              view: calendarView == 'month'
                  ? CalendarView.month
                  : CalendarView.week,
              dataSource: _getCalendarDataSource(),
            ),
          ),
        ),
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
