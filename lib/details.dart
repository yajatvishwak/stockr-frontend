// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => DetailsState();
}

class DetailsState extends State<Details> {
  double currentSliderValue = 10.0;
  String stockName = "";
  String ticker = "ITC.NS";
  String summary = "";
  String logo = "";
  double open = 0.1;
  double close = 0.1;
  double high = 0.1;
  double low = 0.1;
  bool loading = false;

  List<dynamic> prediction = [
    {"yhat": 23, "ds": "2/12/03"},
  ];

  @override
  void initState() {
    super.initState();
    getInitVals();
  }

  void getInitVals() async {
    // setState(() {
    //   name = prefs.getString("name") ?? "name";
    // });
    loading = true;
    Map payload = {"ticker": ticker, "days": currentSliderValue.toInt()};
    print('${dotenv.env['BASEURL']!}get-prediction');
    var url = Uri.parse('${dotenv.env['BASEURL']!}get-prediction');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload));
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      print(res);
      setState(() {
        stockName = res["details"]["name"];
        summary = res["details"]["summary"];
        logo = res["details"]["logo"];
        open = res["today"]["open"];
        close = res["today"]["close"];
        high = res["today"]["high"];
        low = res["today"]["low"];
        prediction = res["forecast"];
      });

      // if (res["code"] == "success") {
      //   setState(() {
      //     pdfs = res["items"];
      //   });
      // }
    }
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: loading
                ? Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Center(
                        child: Text("Loading..."),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.chevron_left_rounded)),
                          Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                stockName,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(ticker),
                            ],
                          ),
                          Image.network(logo,
                              height: 50, width: 50, fit: BoxFit.fitWidth)
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(summary),
                      SizedBox(
                        height: 40,
                      ),
                      SfCartesianChart(
                          // Initialize category axis
                          primaryXAxis: CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: [
                            LineSeries(
                                // Bind data source
                                dataSource: [
                                  SalesData('Jan', 35),
                                  SalesData('Feb', 28),
                                  SalesData('Mar', 34),
                                  SalesData('Apr', 32),
                                  SalesData('May', 40)
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales),
                            LineSeries(
                                // Bind data source
                                dataSource: [
                                  SalesData('Jan', 135),
                                  SalesData('Feb', 128),
                                  SalesData('Mar', 134),
                                  SalesData('Apr', 132),
                                  SalesData('May', 140)
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales)
                          ]),
                      SizedBox(
                        height: 40,
                      ),
                      Text("Stock details for " + stockName + " today"),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                open.toString(),
                                style: TextStyle(fontSize: 34),
                              ),
                              const Text("Open"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                close.toString(),
                                style: TextStyle(fontSize: 34),
                              ),
                              const Text("Close"),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                low.toString(),
                                style: TextStyle(fontSize: 34),
                              ),
                              const Text("Low"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                high.toString(),
                                style: TextStyle(fontSize: 34),
                              ),
                              const Text("High"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Predicted Stock Price"),
                          IconButton(
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                enableDrag: true,
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 30, 18, 30),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                "Adjust Days for prediction",
                                                style: TextStyle(fontSize: 23),
                                              ),
                                              Slider(
                                                min: 1,
                                                max: 10,
                                                divisions: 10,
                                                label: currentSliderValue
                                                    .round()
                                                    .toString(),
                                                value: currentSliderValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentSliderValue = value;
                                                  });
                                                },
                                              ),
                                              Center(
                                                child: Text(
                                                  "${currentSliderValue.round()} day(s)",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text("Save")),
                                              )
                                            ]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.settings),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CarouselSlider(
                          items: prediction
                              .map((e) => Center(
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Text(
                                              '₹ ${e["yhat"].toStringAsFixed(3)}',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              e["ds"].toString(),
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        )),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                              height: 100.0, enableInfiniteScroll: false)),
                      SizedBox(
                        height: 19,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("Read More")),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
