import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

AppBar dashboardAppbarAlpha(int index, context) {
  return AppBar(
    toolbarHeight: 100,
    centerTitle: true,
    elevation: 50,
    bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: Colors.white,
          height: 4.0,
        )),
    backgroundColor: Theme.of(context).unselectedWidgetColor,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 10,
      children: [
        Shimmer.fromColors(
          period: Duration(milliseconds: 4000),
          baseColor: Colors.red,
          highlightColor: Colors.yellow,
          child: Text(
            'TUTORLY'.toUpperCase(),
            style: TextStyle(
              fontSize: 36,
            ),
          ),
        ),
        Text(
          ['Home', 'Schedule', 'Chat', 'Profile'][index].toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () async {},
      ),
    ],
  );
}
