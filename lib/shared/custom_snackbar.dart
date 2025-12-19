import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

SnackBar customSnakBar(String errormsg  , {Color? color}) {
  return   SnackBar(
              backgroundColor: color ?? Colors.red,
              elevation: 15,

              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  Gap(10),
                  Text(errormsg),
                ],
              ),
            );
}