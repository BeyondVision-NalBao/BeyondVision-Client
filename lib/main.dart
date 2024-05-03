import 'package:beyond_vision/provider/date_provider.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/provider/routine_provider.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:beyond_vision/service/user_service.dart';
import 'package:beyond_vision/ui/watch_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beyond_vision/service/date_service.dart';
import 'package:beyond_vision/ui/home/home.dart';
import 'package:beyond_vision/ui/login/google_login.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserService userService = UserService();
  DateService dateService = DateService();
  bool isLogined = false;
  int memberId = -1;
  int exerciseGoal = 0;
  int weight = 70;

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("memberId") != null) {
      if (dateService.compareDate(prefs.getString("loginDate")!)) {
        prefs.setString("loginDate", dateService.loginDate(DateTime.now()));
        setState(() {
          memberId = prefs.getInt("memberId")!;
          exerciseGoal = prefs.getInt("exerciseGoal")!;
          //weight = prefs.getInt("weight")!;
          isLogined = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DateProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => RoutineProvider()),
          ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ],
        child: MaterialApp(
          title: 'Beyond Vision',
          home: isLogined
              ? HomePage(
                  memberId: memberId,
                  exerciseGoal: exerciseGoal,
                  weight: weight,
                  isFirst: true)
              : const LoginPage(),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!);
          },
        ));
    //home: MyAndroidApp()));
  }
}
