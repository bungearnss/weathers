import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/forcast_fiveday.dart';
import '../services/theme_setting.dart';
import '../services/temperature_unit_helper.dart';

class ForcastNextFiveday extends StatefulWidget {
  List<FiveDay> FivedayData;

  ForcastNextFiveday(this.FivedayData);

  @override
  _ForcastNextFivedayState createState() => _ForcastNextFivedayState();
}

class _ForcastNextFivedayState extends State<ForcastNextFiveday> {
  late TooltipBehavior _tooltipBehavior;
  List<FiveDay>? sharedfiveDay;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'temperature',
      color: Colors.blueAccent,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDarkTheme = ThemeSetting.instance.status;
    var isFahrenheit = TemperatureUnitHelper.instance.isFahrenheit;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.24,
      child: Card(
        elevation: isDarkTheme == true ? 1 : 1.3,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 5,
            right: 5,
            top: 10,
          ),
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            enableAxisAnimation: true,
            tooltipBehavior: _tooltipBehavior,
            primaryYAxis: NumericAxis(
              axisLine:
                  AxisLine(width: 1, color: Theme.of(context).highlightColor),
              decimalPlaces: 2,
              rangePadding: ChartRangePadding.additional,
              labelFormat: isFahrenheit ? '{value} \u2109' : '{value} \u2103',
              plotOffset: 0,
              labelStyle:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 13),
            ),
            primaryXAxis: CategoryAxis(
              labelPlacement: LabelPlacement.onTicks,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              axisLine:
                  AxisLine(width: 1, color: Theme.of(context).highlightColor),
              labelStyle:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 11),
              plotOffset: 0,
            ),
            series: <ChartSeries<FiveDay, String>>[
              SplineSeries<FiveDay, String>(
                cardinalSplineTension: 2,
                enableTooltip: true,
                animationDuration: 500,
                animationDelay: 500,
                dataSource: widget.FivedayData,
                xValueMapper: (FiveDay f, _) => f.date,
                yValueMapper: (FiveDay f, _) =>
                    isFahrenheit ? f.tempF : f.tempC,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
