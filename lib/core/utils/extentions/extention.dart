import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

// extension Dimentions on num {
//   SizedBox get hs => SizedBox(height: toDouble().w);

//   SizedBox get ws => SizedBox(width: toDouble().w);
// }

extension TimeTranslate on Jiffy {
  String get jmAr => jm.replaceAll("PM", "م").replaceAll("AM", "ص");
}


extension ObjectToJson on Object {
  Map<String, dynamic> get toMapJson {
    var body = jsonEncode(this);
    var json = jsonDecode(body) as Map<String,dynamic>;

    return json;
  }
}



extension StringToJson on String {
  Map<String, dynamic> get toMap {
    log(this);

    Map<String, dynamic> json = jsonDecode(this);
    return json;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
