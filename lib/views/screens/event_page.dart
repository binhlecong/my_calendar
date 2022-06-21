import 'package:flutter/material.dart';
import 'package:my_calendar/data/db_helper.dart';
import 'package:my_calendar/data/models/event.dart';

// Datetime input
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:my_calendar/views/widgets/color_selector.dart';

class EventPage extends StatefulWidget {
  final Event event;

  EventPage({@required this.event});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  DatabaseHelper _dbHelper = DatabaseHelper();
  final myController = TextEditingController();

  int _eventId = 0;
  String _eventStart = DateTime.now().toString();
  String _eventEnd = DateTime.now().add(Duration(hours: 1)).toString();
  String _eventSubject = "Add a subject...";
  String _eventLocation = "Add a location...";
  int _eventColor = 0;

  FocusNode _startFocus;
  FocusNode _endFocus;
  FocusNode _subjectFocus;
  FocusNode _locationFocus;
  FocusNode _colorFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    if (widget.event != null) {
      _contentVisile = true;

      _eventId = widget.event.id;
      _eventStart = widget.event.startTime;
      _eventEnd = widget.event.endTime;
      _eventSubject = widget.event.subject;
      _eventLocation = widget.event.location;
      _eventColor = widget.event.color;
    }

    _startFocus = FocusNode();
    _endFocus = FocusNode();
    _subjectFocus = FocusNode();
    _locationFocus = FocusNode();
    _colorFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _startFocus.dispose();
    _endFocus.dispose();
    _subjectFocus.dispose();
    _locationFocus.dispose();
    _colorFocus.dispose();

    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
          child: Column(
            children: [
              getSubjectInput(),
              SizedBox(
                height: 30,
              ),
              getLocationInput(),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Start time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: DateTimeField(
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        labelText: _eventStart,
                        isDense: true,
                        contentPadding: EdgeInsets.all(2),
                      ),
                      focusNode: _startFocus,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );

                          _eventStart =
                              DateTimeField.combine(date, time).toString();
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'End time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: DateTimeField(
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        labelText: _eventEnd,
                        isDense: true,
                        contentPadding: EdgeInsets.all(2),
                      ),
                      focusNode: _endFocus,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );

                          _eventEnd =
                              DateTimeField.combine(date, time).toString();
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Importance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ColorSelector(
                      numOptions: 5,
                      checkedIndex: _eventColor,
                      myOnChange: (index) {
                        _eventColor = index;
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.delete),
                        label: Text('Delete'),
                        onPressed: () async {
                          await _dbHelper.delete(_eventId);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.check,
                        ),
                        label: Text('Save'),
                        onPressed: () async {
                          if (widget.event == null) {
                            Event newEvent = Event(
                              startTime: _eventStart,
                              endTime: _eventEnd,
                              subject: _eventSubject,
                              location: _eventLocation,
                              color: _eventColor,
                            );

                            _eventId = await _dbHelper.insert(newEvent);
                          } else {
                            Event thisEvent =
                                await _dbHelper.getEvent(_eventId);
                            thisEvent.startTime = _eventStart;
                            thisEvent.endTime = _eventEnd;
                            thisEvent.subject = _eventSubject;
                            thisEvent.location = _eventLocation;
                            thisEvent.color = _eventColor;

                            _eventId = await _dbHelper.update(thisEvent);
                          }

                          setState(() {
                            _contentVisile = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row getLocationInput() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Location',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            focusNode: _locationFocus,
            onChanged: (value) async {
              _eventLocation = value;
            },
            onSubmitted: (value) async {
              _startFocus.requestFocus();
            },
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(
              labelText: _eventLocation,
              isDense: true,
              contentPadding: EdgeInsets.all(2),
            ),
          ),
        ),
      ],
    );
  }

  Row getSubjectInput() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Subject',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            focusNode: _subjectFocus,
            onChanged: (value) async {
              _eventSubject = value;
            },
            onSubmitted: (value) async {
              _locationFocus.requestFocus();
            },
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(
              labelText: _eventSubject,
              isDense: true,
              contentPadding: EdgeInsets.all(2),
            ),
          ),
        ),
      ],
    );
  }
}
