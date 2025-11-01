import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/earning_insight.dart';
import 'package:deligo_delivery/models/profile_mode.dart';
import 'package:deligo_delivery/models/rating.dart';
import 'package:deligo_delivery/models/rating_summary.dart';
import 'package:deligo_delivery/models/ride_summary.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const InsightStateful(),
      );
}

class InsightStateful extends StatefulWidget {
  const InsightStateful({super.key});

  @override
  State<InsightStateful> createState() => _InsightStatefulState();
}

class _InsightStatefulState extends State<InsightStateful> {
  List<BarChartData> chartData = [];
  late FetcherCubit _fetcherCubit;
  EarningInsight _earningInsight = EarningInsight.getDefault();
  RideSummary? _rideSummary;
  String _popupSelection = 'today';
  Rating? _rating;

  @override
  void initState() {
    _fetcherCubit = BlocProvider.of<FetcherCubit>(context);
    super.initState();
    _fetcherCubit.initFetchProfileRating();
    _fetcherCubit.initFetchRideEarnings(_popupSelection);
    _fetcherCubit.initFetchRideInsight(_popupSelection);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      drawer: const DrawerWidget(),
      //backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
            ),
          ),
        ),
        title: Text(
          AppLocalization.instance.getLocalizationFor("insight"),
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            color: theme.scaffoldBackgroundColor,
            onSelected: (String value) {
              if (_popupSelection != value) {
                _fetcherCubit.initFetchRideEarnings(value);
                _fetcherCubit.initFetchRideInsight(value);
                setState(() => _popupSelection = value);
              }
            },
            child: Row(
              children: <Widget>[
                Text(
                  _popupSelection.toUpperCase(),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 15.0,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Icon(
                  Icons.keyboard_arrow_down,
                ),
                const SizedBox(width: 20.0)
              ],
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "today",
                child: Text(
                  AppLocalization.instance
                      .getLocalizationFor("insight_filter_today"),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 15.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: "weekly",
                child: Text(
                  AppLocalization.instance
                      .getLocalizationFor("insight_filter_week"),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 15.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: "monthly",
                child: Text(
                  AppLocalization.instance
                      .getLocalizationFor("insight_filter_month"),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 15.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: "yearly",
                child: Text(
                  AppLocalization.instance
                      .getLocalizationFor("insight_filter_year"),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 15.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: BlocListener<FetcherCubit, FetcherState>(
        listener: (context, state) {
          if (state is RideSummaryLoaded) {
            _rideSummary = state.rideSummary;
            setState(() {});
          }
          if (state is LoadedEarningInsightState) {
            _earningInsight = state.earningInsight;
            chartData = _earningInsight.chartData
                .map((data) => BarChartData(
                    time: _getPeriodLabel(data.period.toString()),
                    earning: double.tryParse(data.total) ?? 0))
                .toList();
            setState(() {});
          }
          if (state is InsightLoaded) {
            _rating = state.rating;
            setState(() {});
          }
        },
        child: ListView(
          children: [
            Container(
              color: theme.cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Row(
                  children: [
                    buildColumn(
                        theme,
                        AppLocalization.instance.getLocalizationFor(
                            _rideSummary?.ridesCount == null
                                ? "orders"
                                : "rides"),
                        "${_rideSummary?.ridesCount ?? _rideSummary?.ordersCount ?? 0}"),
                    Expanded(
                      child: Center(
                        child: buildColumn(
                            theme,
                            AppLocalization.instance
                                .getLocalizationFor("driven"),
                            _rideSummary?.distanceTravelledFormatted ?? "0"),
                      ),
                    ),
                    buildColumn(
                        theme,
                        AppLocalization.instance.getLocalizationFor("earnings"),
                        "${AppSettings.currencyIcon} ${_rideSummary?.earnings ?? 0}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                AppLocalization.instance.getLocalizationFor("earnings"),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  //color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: theme.hintColor),
                  axisLine: AxisLine(color: theme.hintColor),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  numberFormat: NumberFormat.decimalPattern(),
                  labelStyle: TextStyle(color: theme.hintColor),
                ),
                series: <CartesianSeries<BarChartData, String>>[
                  StackedColumnSeries<BarChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (BarChartData data, _) => data.time,
                    yValueMapper: (BarChartData data, _) => data.earning,
                    // trackColor:
                    //     isDark ? Colors.grey.shade100 : Colors.grey.shade800,
                    //color: isDark ? Colors.white : Colors.black,
                    trackColor: theme.primaryColor.withValues(alpha: 0.3),
                    color: theme.primaryColor,
                    isTrackVisible: true,
                    //width: 0.4,
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.scaffoldBackgroundColor,
                            fontSize: 12)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: CustomButton(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.walletPage),
                // onTap: () {
                //   bool isDark = BlocProvider.of<ThemeCubit>(context).isDark;
                //   BlocProvider.of<ThemeCubit>(context).setTheme(!isDark);
                // },
                label: AppLocalization.instance
                    .getLocalizationFor("viewAllTransactions"),
                //labelColor: isDark ? Colors.black : Colors.white,
                //bgColor: isDark ? Colors.white : Colors.black,
              ),
            ),
            FutureBuilder<ProfileMode?>(
              future: LocalDataLayer().getProfileMode(),
              builder: (BuildContext context,
                      AsyncSnapshot<ProfileMode?> snapshot) =>
                  snapshot.data?.riding_mode == "riding"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Text(
                                AppLocalization.instance
                                    .getLocalizationFor("ratings"),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFF009D06),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          (_rating?.averageRating ?? 0)
                                              .toStringAsFixed(2),
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${_rating?.totalRatings ?? 0} ${AppLocalization.instance.getLocalizationFor("peopleRated")}",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            SizedBox(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: 200, // Constrain the width as well
                                      height: 200,
                                      child: SfCircularChart(
                                        margin: EdgeInsets.zero,
                                        series: <CircularSeries>[
                                          DoughnutSeries<RatingSummary, int>(
                                            innerRadius: '44',
                                            dataSource: _rating?.summary ?? [],
                                            pointColorMapper:
                                                (RatingSummary data, _) =>
                                                    data.color,
                                            xValueMapper:
                                                (RatingSummary data, _) =>
                                                    data.roundedRating,
                                            yValueMapper:
                                                (RatingSummary data, _) =>
                                                    data.total,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Center the ratings vertically
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (_rating?.summary ?? [])
                                          .map(
                                            (element) => buildRatingCount(
                                                theme, element),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingCount(ThemeData theme, RatingSummary summary) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: summary.color,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    summary.roundedRating.toStringAsFixed(1),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              summary.total.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 8),
            Text(
              "(${summary.percent?.toStringAsFixed(2) ?? "0.0"}%)",
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );

  Column buildColumn(ThemeData theme, String title, String subtitle) => Column(
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );

  String _getPeriodLabel(String periodValue) {
    List<String> months = [
      "jan",
      "feb",
      "mar",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "oct",
      "nov",
      "dec"
    ];
    if (periodValue.contains("_") || periodValue.contains("-")) {
      return Helper.formatDate(periodValue, false);
    } else if (_popupSelection == "monthly") {
      int index = int.tryParse(periodValue) ?? 0;
      return AppLocalization.instance
          .getLocalizationFor(months[index > 0 ? index - 1 : index]);
    } else if (_popupSelection == "today") {
      String toReturn = periodValue;
      if (periodValue.length == 1) toReturn = "0$toReturn";
      if (int.tryParse(periodValue) != null) toReturn = toReturn += ":00";
      DateTime dateTime = DateTime.parse("2024-02-27T$toReturn:00Z");
      DateTime istTime =
          dateTime.add(const Duration(hours: 5, minutes: 30)); // Convert to IST
      toReturn = DateFormat('hh:mm').format(istTime);
      return toReturn;
    } else {
      return periodValue;
    }
  }
}

class BarChartData {
  String time;
  num earning;

  BarChartData({required this.time, required this.earning});
}
