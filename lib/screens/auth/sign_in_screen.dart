import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_common_dialog.dart';
import 'package:momona_healthcare/components/app_logo.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/demo_login_model.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/screens/auth/components/login_register_widget.dart';
import 'package:momona_healthcare/screens/auth/sign_up_screen.dart';
import 'package:momona_healthcare/screens/demo_scanners/qr_info_screen.dart';
import 'package:momona_healthcare/screens/demo_scanners/scanner_screen.dart';
import 'package:momona_healthcare/screens/doctor/doctor_dashboard_screen.dart';
import 'package:momona_healthcare/screens/patient/p_dashboard_screen.dart';
import 'package:momona_healthcare/screens/receptionist/r_dashboard_screen.dart';
import 'package:momona_healthcare/utils/app_widgets.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'components/forgot_password_dailog_component.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = false;

  List<DemoLoginModel> demoLoginData = demoLoginList();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (getBoolAsync(IS_REMEMBER_ME)) {
      isRemember = true;
      emailCont.text = getStringAsync(USER_NAME);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  saveForm() async {
    if (appStore.isLoading) return;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);
      appStore.setLoading(true);

      Map req = {
        'username': emailCont.text,
        'password': passwordCont.text,
      };

      await login(req).then((value) {
        if (isRemember) {
          setValue(USER_NAME, emailCont.text);
          setValue(USER_PASSWORD, passwordCont.text);
          setValue(IS_REMEMBER_ME, true);
        }

        // toast(value.role.validate());
        appStore.setLoading(false);
        if (appStore.userRole!.toLowerCase() == UserRoleDoctor) {
          toast(locale.lblLoginSuccessfully);

          DoctorDashboardScreen().launch(context, isNewTask: true);
        } else if (appStore.userRole!.toLowerCase() == UserRolePatient) {
          toast(locale.lblLoginSuccessfully);

          PatientDashBoardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        } else if (appStore.userRole!.toLowerCase() == UserRoleReceptionist) {
          toast(locale.lblLoginSuccessfully);

          RDashBoardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        } else {
          toast(locale.lblWrongUser);
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
      setState(() {});
    }
  }

  void forgotPasswordDialog(BuildContext context) {
    showInDialog(
      context,
      shape: RoundedRectangleBorder(borderRadius: radius()),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.scaffoldBackgroundColor,
      builder: (context) {
        return AppCommonDialog(
          title: locale.lblForgotPassword,
          child: ForgotPasswordDialogComponent().cornerRadiusWithClipRRect(defaultRadius),
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                96.height,
                AppLogo(),
                Text(locale.lblSignInToContinue, style: secondaryTextStyle()).center(),
                32.height,
                AppTextField(
                  controller: emailCont,
                  focus: emailFocus,
                  nextFocus: passwordFocus,
                  textStyle: primaryTextStyle(),
                  textFieldType: TextFieldType.EMAIL,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblEmail,
                  ).copyWith(suffixIcon: ic_user.iconImage(size: 18, color: context.iconColor).paddingAll(14)),
                ),
                24.height,
                AppTextField(
                  controller: passwordCont,
                  focus: passwordFocus,
                  textStyle: primaryTextStyle(),
                  textFieldType: TextFieldType.PASSWORD,
                  suffixPasswordVisibleWidget: ic_showPassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                  suffixPasswordInvisibleWidget: ic_hidePassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                  decoration: inputDecoration(context: context, labelText: locale.lblPassword),
                ),
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        4.width,
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: Theme(
                            data: ThemeData(unselectedWidgetColor: context.iconColor),
                            child: Checkbox(
                              activeColor: appSecondaryColor,
                              value: isRemember,
                              onChanged: (value) async {
                                isRemember = value.validate();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        8.width,
                        TextButton(
                          onPressed: () {
                            isRemember = !isRemember;
                            setState(() {});
                          },
                          child: Text(locale.lblRememberMe, style: secondaryTextStyle()),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        return forgotPasswordDialog(context);
                      },
                      child: Text(
                        locale.lblForgotPassword,
                        style: secondaryTextStyle(color: appSecondaryColor, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                24.height,
                AppButton(
                  width: context.width(),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                  onTap: () {
                    saveForm();
                  },
                  color: primaryColor,
                  padding: EdgeInsets.all(16),
                  child: Text(locale.lblSignIn, style: boldTextStyle(color: textPrimaryDarkColor)),
                ),
                60.height,
                HorizontalList(
                  itemCount: demoLoginData.length,
                  spacing: 16,
                  itemBuilder: (context, index) {
                    DemoLoginModel data = demoLoginData[index];
                    bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        selectedIndex = index;
                        setState(() {});

                        if (index == 0) {
                          if (appStore.tempBaseUrl != BASE_URL) {
                            emailCont.text = appStore.demoPatient.validate();
                            passwordCont.text = loginPassword;
                          } else {
                            emailCont.text = patientEmail;
                            passwordCont.text = loginPassword;
                          }
                        } else if (index == 1) {
                          if (appStore.tempBaseUrl != BASE_URL) {
                            emailCont.text = appStore.demoReceptionist.validate();
                            passwordCont.text = loginPassword;
                          } else {
                            emailCont.text = receptionistEmail;
                            passwordCont.text = loginPassword;
                          }
                        } else if (index == 2) {
                          if (appStore.tempBaseUrl != BASE_URL) {
                            emailCont.text = appStore.demoDoctor.validate();
                            passwordCont.text = loginPassword;
                          } else {
                            emailCont.text = doctorEmail;
                            passwordCont.text = loginPassword;
                          }
                        }
                      },
                      child: Container(
                        child: Image.asset(
                          data.loginTypeImage.validate(),
                          height: 22,
                          width: 22,
                          fit: BoxFit.cover,
                          color: isSelected ? white : appSecondaryColor,
                        ),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor: isSelected
                              ? appSecondaryColor
                              : appStore.isDarkModeOn
                                  ? cardDarkColor
                                  : white,
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                    );
                  },
                ),
                16.height,
                LoginRegisterWidget(
                  title: locale.lblNewMember,
                  subTitle: locale.lblSignUp,
                  onTap: () {
                    SignUpScreen().launch(context);
                  },
                ),
                32.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner_sharp, color: primaryColor),
                    16.width,
                    Text('Scan to test', style: primaryTextStyle(color: primaryColor)),
                  ],
                ).onTap(() {
                  ScannerScreen().launch(context);
                }),
                TextButton(
                  onPressed: () {
                    QrInfoScreen().launch(context);
                  },
                  child: Text('How to generate QR code for Testing?', style: secondaryTextStyle()),
                ),
                32.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
