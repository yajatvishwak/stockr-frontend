// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  double currentSliderValue = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.chevron_left_rounded)),
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Stockr",
                          style: TextStyle(fontSize: 34),
                        ),
                        Text("Stalk the stock"),
                      ],
                    ),
                  ],
                ),
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
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales)
                    ]),
                SizedBox(
                  height: 40,
                ),
                Text("Stock details for ITC today"),
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
                        const Text(
                          "12",
                          style: TextStyle(fontSize: 34),
                        ),
                        const Text("Open"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "15",
                          style: TextStyle(fontSize: 34),
                        ),
                        const Text("Close"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "15",
                          style: TextStyle(fontSize: 34),
                        ),
                        const Text("Close"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "15",
                          style: TextStyle(fontSize: 34),
                        ),
                        const Text("Close"),
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
                                    MediaQuery.of(context).size.height * 0.30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(25.0),
                                    topRight: const Radius.circular(25.0),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 30, 18, 30),
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
                                            style: TextStyle(fontSize: 20),
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
                    items: [
                      Center(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  '₹ 452',
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '12/12/2022',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )),
                          ),
                        ),
                      ),
                      Center(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  '₹ 452',
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '12/12/2022',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
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
