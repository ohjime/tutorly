import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardAppbarBeta extends StatelessWidget
    implements PreferredSizeWidget {
  const DashboardAppbarBeta({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth * 4;
        return ClipRect(
          child: OverflowBox(
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            child: SizedBox(
              width: width,
              height: width,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: width / 2 - preferredSize.height / 2),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Shimmer.fromColors(
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}
