import 'dart:convert';

import 'package:intl/intl.dart';

class FiveDay {
  final String? date;
  final int? tempC;
  final int? tempF;
  final String? dt_txt;
  final String? main;

  FiveDay({this.date, this.tempC, this.tempF, this.dt_txt, this.main});

  factory FiveDay.fromJson(Map<String, dynamic> json) {
    // var day = json['dt_txt'].split(' ')[0].split('-')[2];
    // var month = json['dt_txt'].split(' ')[0].split('-')[1];
    var dtDate = json['dt_txt'].split(' ')[0];
    var dateFormat = DateFormat('MMMd').format(DateTime.parse(dtDate));
    var hour = json['dt_txt'].split(' ')[1].split(':')[0];

    var _dateTime = '$dateFormat\n$hour:00';

    return FiveDay(
      date: _dateTime,
      tempC: double.parse(json['main']['temp'].toString()).round(),
      tempF:
          double.parse(((json['main']['temp'] * 1.8) + 32).toString()).round(),
    );
  }

  static Map<String, dynamic> toMap(FiveDay fiveday) => {
        'date': fiveday.date,
        'tempC': fiveday.tempC,
        'tempF': fiveday.tempF,
      };

  static String encode(List<FiveDay> fivedays) => json.encode(
        fivedays
            .map<Map<String, dynamic>>(
                (fivedayData) => FiveDay.toMap(fivedayData))
            .toList(),
      );

  // static List<FiveDay> decode(String fivedays) =>
  //     (json.decode(fivedays) as List<dynamic>)
  //         .map<FiveDay>((item) => FiveDay(date: item.date, ))
  //         .toList();
}
