import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app0/layout/news_app/cubit/cubit.dart';
import 'package:flutter_app0/layout/news_app/news_layout.dart';
import 'package:flutter_app0/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_app0/layout/shop_app/shop_layout.dart';
import 'package:flutter_app0/layout/social_app/cubit/cubit.dart';
import 'package:flutter_app0/layout/social_app/social_layout.dart';
import 'package:flutter_app0/modules/social_app/social_login/social_login_screen.dart';
import 'package:flutter_app0/shared/bloc_observer.dart';
import 'package:flutter_app0/shared/components/constants.dart';
import 'package:flutter_app0/shared/cubit/cubit.dart';
import 'package:flutter_app0/shared/cubit/states.dart';
import 'package:flutter_app0/shared/network/local/cache_helper.dart';
import 'package:flutter_app0/shared/network/remote/dio_helper.dart';
import 'package:flutter_app0/shared/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  uId = CacheHelper.getData(key: 'uId');
  // if (onBoarding != null) {
  //   if (token != null)
  //     widget = ShopLayout();
  //   else
  //     widget = ShopLoginScreen();
  // } else {
  //   widget = OnBoardingScreen();
  // }
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;
  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
        BlocProvider(
          create: (context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPosts(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            // darkTheme: darkTheme,
            themeMode: AppCubit().get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: ShopLayout(),
          );
        },
      ),
    );
  }
}
