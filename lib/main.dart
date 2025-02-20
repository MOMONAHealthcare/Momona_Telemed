import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momona_healthcare/app_theme.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/locale/app_localizations.dart';
import 'package:momona_healthcare/locale/base_language_key.dart';
import 'package:momona_healthcare/locale/language_en.dart';
import 'package:momona_healthcare/model/language_model.dart';
import 'package:momona_healthcare/network/services/auth_service.dart';
import 'package:momona_healthcare/network/services/default_firebase_config.dart';
import 'package:momona_healthcare/screens/patient/store/patient_store.dart';
import 'package:momona_healthcare/screens/splash_screen.dart';
import 'package:momona_healthcare/store/AppStore.dart';
import 'package:momona_healthcare/store/AppointmentAppStore.dart';
import 'package:momona_healthcare/store/EditProfileAppStore.dart';
import 'package:momona_healthcare/store/ListAppStore.dart';
import 'package:momona_healthcare/store/MultiSelectStore.dart';
import 'package:momona_healthcare/utils/app_widgets.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'utils/app_common.dart';

late PackageInfoData packageInfo;

AppStore appStore = AppStore();
PatientStore patientStore = PatientStore();
ListAppStore listAppStore = ListAppStore();
AppointmentAppStore appointmentAppStore = AppointmentAppStore();
EditProfileAppStore editProfileAppStore = EditProfileAppStore();
MultiSelectStore multiSelectStore = MultiSelectStore();
AuthService authService = AuthService();

BaseLanguage locale = LanguageEn();

PickedFile? image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultBlurRadius = 0;
  defaultSpreadRadius = 0.0;

  defaultAppBarElevation = 2;
  appBarBackgroundColorGlobal = primaryColor;
  appButtonBackgroundColorGlobal = primaryColor;

  defaultAppButtonTextColorGlobal = Colors.white;
  defaultAppButtonElevation = 0.0;

  defaultRadius = 12;
  defaultLoaderAccentColorGlobal = primaryColor;

  await initialize();
  localeLanguageList = languageList();

  Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions).then((value) {
    setupRemoteConfig();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  });

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: DEFAULT_LANGUAGE));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  await defaultValue();

  HttpOverrides.global = HttpOverridesSkipCertificate();

  packageInfo = await getPackageInfo();

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: APP_NAME,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        navigatorKey: navigatorKey,
        supportedLocales: Language.languagesLocale(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        // ],
      ),
    );
  }
}
