import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/date_provider.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final DateProvider provider;
  const Calendar({super.key, required this.provider});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = widget.provider.selectedDay;
    AuthProvider auth = Provider.of<AuthProvider>(context);
    DateProvider date = Provider.of<DateProvider>(context);

    bool getEventsForDay(List<double> records, int day) {
      if (records.length < day) {
        if (records[day] >= auth.goal) {
          return true;
        }
      }

      return false;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TableCalendar(
        // eventLoader: (day) {
        //   bool isSuccess = getEventsForDay(
        //       widget.provider.thisWeekExerciseTime, day.weekday);
        //   return isSuccess ? [true] : [];
        // },

        daysOfWeekStyle:
            const DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white)),
        calendarStyle: const CalendarStyle(
          defaultTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          weekendTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          selectedDecoration: BoxDecoration(
              color: Color(fontYellowColor), shape: BoxShape.circle),
          selectedTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          todayTextStyle: TextStyle(
            color: Color(fontYellowColor),
            fontSize: 20,
          ),
          todayDecoration: BoxDecoration(color: Colors.black),
        ),
        daysOfWeekHeight: 28.0,
        startingDayOfWeek: StartingDayOfWeek.monday,
        focusedDay: selectedDay,
        firstDay: DateTime(2023, 1, 1),
        lastDay: DateTime.now(),
        calendarFormat: CalendarFormat.week,
        onDaySelected: widget.provider.updateSelectedDay,
        onPageChanged: widget.provider.moveWeek,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        headerStyle: HeaderStyle(
          titleTextFormatter: (yearMonth, Locale) {
            int year = yearMonth.year;
            int month = yearMonth.month;
            // 한국어로 월을 표시하는 형식으로 제목을 반환합니다.
            return '$year년 $month월';
          },
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: Colors.white),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            for (var record in date.records) {
              if ((record.exerciseTime! / 60) >= auth.goal &&
                  isSameDay(record.exerciseDate!, day)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Color(fontYellowColor),
                        shape: BoxShape.circle,
                      )),
                );
              }
            }
            return null;
          },
          dowBuilder: (context, day) {
            switch (day.weekday) {
              case 1:
                return const Center(
                  child: Text(
                    '월',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 2:
                return const Center(
                  child: Text(
                    '화',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 3:
                return const Center(
                  child: Text(
                    '수',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 4:
                return const Center(
                  child: Text(
                    '목',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 5:
                return const Center(
                  child: Text(
                    '금',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 6:
                return const Center(
                  child: Text(
                    '토',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              case 7:
                return const Center(
                  child: Text(
                    '일',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
            }
            return null;
          },
        ),
      ),
    );
  }
}
