import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/name_initials_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/doctor/screens/edit_profile_screen.dart';
import 'package:momona_healthcare/screens/receptionist/fragments/r_appointment_fragment.dart';
import 'package:momona_healthcare/screens/receptionist/fragments/r_doctor_list_fragment.dart';
import 'package:momona_healthcare/screens/receptionist/fragments/r_patient_list_fragment.dart';
import 'package:momona_healthcare/screens/receptionist/fragments/r_setting_fragment.dart';
import 'package:momona_healthcare/screens/receptionist/screens/edit_patient_profile_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RDashBoardScreen extends StatefulWidget {
  @override
  _RDashBoardScreenState createState() => _RDashBoardScreenState();
}

class _RDashBoardScreenState extends State<RDashBoardScreen> {
  int currentIndex = 0;

  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Observer(builder: (context) {
        Color disableIconColor = appStore.isDarkModeOn ? Colors.white : secondaryTxtColor;
        return Scaffold(
          appBar: currentIndex != 3
              ? appBarWidget(
                  '',
                  titleWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(ic_hi, width: 22, height: 22, fit: BoxFit.cover),
                          8.width,
                          Text(locale.lblHi, style: primaryTextStyle(color: appStore.isDarkModeOn ? white : secondaryTxtColor)),
                        ],
                      ),
                      2.height,
                      Text(' ${appStore.firstName.validate()} ${appStore.lastName.validate()}', style: boldTextStyle(size: 18)),
                    ],
                  ),
                  showBack: false,
                  color: context.scaffoldBackgroundColor,
                  elevation: 0,
                  systemUiOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: context.scaffoldBackgroundColor,
                    statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        if (isDoctor()) {
                          EditProfileScreen().launch(context);
                        } else {
                          EditPatientProfileScreen().launch(context);
                        }
                      },
                      child: Container(
                        decoration: boxDecorationDefault(color: context.primaryColor, border: Border.all(color: white, width: 4), shape: BoxShape.circle),
                        padding: appStore.profileImage.validate().isNotEmpty ? EdgeInsets.zero : EdgeInsets.all(12),
                        margin: EdgeInsets.only(right: 16),
                        child: appStore.profileImage.validate().isNotEmpty
                            ? CachedImageWidget(
                                url: appStore.profileImage.validate(),
                                fit: BoxFit.cover,
                                height: 46,
                                width: 46,
                                circle: true,
                                alignment: Alignment.center,
                              )
                            : NameInitialsWidget(
                                firstName: appStore.firstName.validate(value: 'K'),
                                lastName: appStore.lastName.validate(value: 'V'),
                                color: Colors.white,
                              ),
                      ),
                    )
                  ],
                )
              : null,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: currentIndex != 3 ? 16 : 0),
                child: [
                  RAppointmentFragment(),
                  RDoctorListFragment(),
                  RPatientListFragment(),
                  RSettingFragment(),
                ][currentIndex],
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) {
              currentIndex = i;
              setState(() {});
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).iconTheme.color,
            backgroundColor: context.cardColor,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
                icon: ic_calendar.iconImage(size: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_calendarFill, height: iconSize, width: iconSize),
                label: locale.lblAppointments,
              ),
              BottomNavigationBarItem(
                icon: ic_doctorIcon.iconImage(size: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_fill_doctor, height: iconSize, width: iconSize),
                label: locale.lblDoctor,
              ),
              BottomNavigationBarItem(
                icon: ic_patient.iconImage(size: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_patientFill, height: iconSize, width: iconSize),
                label: locale.lblPatients,
              ),
              BottomNavigationBarItem(
                icon: ic_more_item.iconImage(size: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_more_item_fill, height: iconSize, width: iconSize, color: primaryColor),
                label: locale.lblMoreItems,
              ),
            ],
          ),
        );
      }),
    );
  }
}
