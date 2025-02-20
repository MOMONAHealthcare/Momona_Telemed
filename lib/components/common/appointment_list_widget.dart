import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/screens/patient/components/common_appointment_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentListWidget extends StatelessWidget {
  final List<UpcomingAppointment> upcomingAppointment;

  AppointmentListWidget({required this.upcomingAppointment});

  @override
  Widget build(BuildContext context) {
    if (upcomingAppointment.isEmpty) return NoDataFoundWidget().center();

    return AnimatedListView(
      shrinkWrap: true,
      itemCount: upcomingAppointment.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        UpcomingAppointment data = upcomingAppointment[index];
        return CommonAppointmentWidget(upcomingData: data, index: index).paddingOnly(bottom: 16);
      },
    );
  }
}
