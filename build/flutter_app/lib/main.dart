import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/app_view_model.dart';
import 'views/content_view.dart';
import 'extensions/color_absher.dart';

void main() {
  runApp(const ABSHERApp());
}

class ABSHERApp extends StatelessWidget {
  const ABSHERApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: MaterialApp(
        title: 'أبشر',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Tajawal',
          scaffoldBackgroundColor: AbsherColors.background,
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const ContentView(),
      ),
    );
  }
}
