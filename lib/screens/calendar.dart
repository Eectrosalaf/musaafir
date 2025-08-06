import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockH! * 5,
            vertical: SizeConfig.blockV! * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pushNamed(context, '/main'),
                  ),
                  Text(
                    "Schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockH! * 5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockV! * 2),
              // Calendar with custom header
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockV! * 2,
                  horizontal: SizeConfig.blockH! * 2,
                ),
                child: Column(
                  children: [
                    // Custom header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                            });
                          },
                        ),
                        Text(
                          "${_selectedDay?.day ?? _focusedDay.day} ${_monthName(_selectedDay ?? _focusedDay)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockH! * 4.2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _focusedDay = _focusedDay.add(const Duration(days: 7));
                            });
                          },
                        ),
                      ],
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarFormat: CalendarFormat.week,
                      headerVisible: false,
                      daysOfWeekVisible: true,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.deepOrange,
                          shape: BoxShape.rectangle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(12),
                          shape: BoxShape.rectangle,
                        ),
                        selectedTextStyle: const TextStyle(color: Colors.black),
                        defaultTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                        weekendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockV! * 2),
              // My Schedule Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockH! * 4,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: DesignColors.primaryColor,
                        fontSize: SizeConfig.blockH! * 3.5,
                      ),
                    ),
                  ),
                ],
              ),
              // Schedule List
              Expanded(
                child: ListView(
                  children: [
                    _ScheduleCard(
                      date: "26 January 2022",
                      image: "images/aa.jpg",
                      title: "Niladri Reservoir",
                      location: "Tekergat, Sunamgj",
                    ),
                    _ScheduleCard(
                      date: "26 January 2022",
                      image: "images/a.jpg",
                      title: "High Rech Park",
                      location: "Zeero Point, Sylhet",
                    ),
                    _ScheduleCard(
                      date: "26 January 2022",
                      image: "images/aaa.jpg",
                      title: "Darma Reservoir",
                      location: "Darma, Kuningan",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(DateTime date) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[date.month];
  }
}

class _ScheduleCard extends StatelessWidget {
  final String date, image, title, location;
  const _ScheduleCard({
    required this.date,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        height: SizeConfig.blockH! * 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: SizeConfig.blockH! * 30,
                height: SizeConfig.blockH! * 25,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: SizeConfig.blockH! * 2),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockH! * 4,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: SizeConfig.blockH! * 3.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: SizeConfig.blockH! * 3.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      );
    }
  }