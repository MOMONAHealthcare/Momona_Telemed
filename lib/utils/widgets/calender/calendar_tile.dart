import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/widgets/calender/date_utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback? onDateSelected;
  final DateTime? date;
  final String? dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool inMonth;
  final List? events;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? dateStyles;
  final Widget? child;
  final Color? selectedColor;
  final Color? todayColor;
  final Color? eventColor;
  final Color? eventDoneColor;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyle,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.inMonth: true,
    this.events,
    this.selectedColor,
    this.todayColor,
    this.eventColor,
    this.eventDoneColor,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            dayOfWeek!,
            style: dayOfWeekStyle,
          ),
        ),
      );
    } else {
      int eventCount = 0;

      return InkWell(
        onTap: onDateSelected,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor != null
                        ? Utils.isSameDay(this.date!, DateTime.now())
                            ? primaryColor
                            : selectedColor
                        : Theme.of(context).primaryColor,
                  )
                : BoxDecoration(),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat("d").format(date!),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : Utils.isSameDay(this.date!, DateTime.now())
                              ? todayColor
                              : inMonth
                                  ? appStore.isDarkModeOn
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.grey),
                ),
                events != null && events!.length > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events!.map((event) {
                          eventCount++;
                          if (eventCount > 1) return Container();
                          return Container(
                            margin: EdgeInsets.only(left: 2.0, right: 2.0, top: 1.0),
                            width: 5.0,
                            height: 5.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? appSecondaryColor : primaryColor,
                            ),
                          );
                        }).toList())
                    : Container(),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return new InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return new Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
