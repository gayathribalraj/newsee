import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/feature/globalconfig/bloc/global_config_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_state.dart';
import 'package:newsee/routes/app_routes.dart';
import 'package:newsee/widgets/custom_loading.dart';

class RouterApp extends StatefulWidget {
  @override
  State<RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<RouterApp> {
  void getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission status: ${settings.authorizationStatus}");
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getFcmToken();
    setupInteractedMessage();
    // when app is in open state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title ?? message.data['title'];
      String? body = message.notification?.body ?? message.data['body'];

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          payload: {"screen": message.data["screen"], "id": message.data["id"]},
        ),
      );
    });
  }

  // App opened from terminated state
  void setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print('Initial Message: $initialMessage');
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("Notification Tapped: ${message.data}");
    print("Notification Tapped: ${message.notification}");
    if (message.data['screen'] == 'query_module') {
      Future.delayed(Duration(milliseconds: 500), () {
        routes.push(
          '/chatwindow',
          extra: {
            "queryId": message.data['id'],
            "proposalNo": message.data['propNo'].toString(),
            "queryType": message.notification?.body ?? "",
            "userName": message.notification?.title ?? "",
          },
        );
      });
      // Future.delayed(Duration(milliseconds: 500), () {
      //   routes.push(
      //     '/queryinbox',
      //     extra: {
      //       "title": message.notification?.title ?? "",
      //       "body": message.notification?.body ?? "",
      //     },
      //   );
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GlobalLoadingBloc()),
        BlocProvider(create: (context) => GlobalConfigBloc()),
        BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository)),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocBuilder<GlobalLoadingBloc, GlobalLoadingState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center, // Non-directional alignment
              children: [
                MaterialApp.router(
                  routerConfig: routes,
                  debugShowCheckedModeBanner: false,
                ),
                if (state.isLoading)
                  Center(child: CustomLoading(message: state.message)),
              ],
            );
          },
        ),
      ),
    );
  }
}
