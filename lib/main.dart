// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/details.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tickers = ["RELIANCE.NS"];

  List<dynamic> arr = [
    {
      "ticker": "REL",
      "name": "Reliance",
      "img": "https://logo.clearbit.com/itcportal.com"
    },
  ];
  TextEditingController tickerEditing = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInitVals();
  }

  void getInitVals() async {
    final prefs = await SharedPreferences.getInstance();
    tickers = prefs.getStringList("tickers") ?? [];
    arr = [];
    var arr2 = [];
    for (String i in tickers) {
      Map payload = {
        "ticker": i,
      };
      var url = Uri.parse('${dotenv.env['BASEURL']!}get-name');
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(payload));
      Map res = json.decode(response.body);
      arr2.add({"name": res["name"], "ticker": i, "img": res["logo"]});
    }
    setState(() {
      for (var item in arr2) {
        arr.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Stockr",
                    style: TextStyle(fontSize: 34),
                  ),
                  Text("Stalk the stock"),
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your WatchListed Stocks"),
                      IconButton(
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  return SafeArea(
                                    child: Container(
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
                                                "Add Ticker to watch",
                                                style: TextStyle(fontSize: 23),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                controller: tickerEditing,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Add ticker here..."),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      final pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      tickers.add(
                                                          tickerEditing.text);
                                                      pref.setStringList(
                                                          "tickers", tickers);
                                                      getInitVals();
                                                    },
                                                    child: Text("Save")),
                                              )
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          icon: Icon(Icons.add)),
                    ],
                  ),
                  ListView.builder(
                    itemCount: arr.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details(
                                        ticker: arr[index]["ticker"],
                                      )),
                            );
                          },
                          leading: Image.network(arr[index]["img"]),
                          title: Text(arr[index]["name"]),
                          subtitle: Text(
                              arr[index]["ticker"] + ' - Stock being watched'),
                          trailing: IconButton(
                              onPressed: () async {
                                final pref =
                                    await SharedPreferences.getInstance();
                                tickers.remove(arr[index]["ticker"]);
                                pref.setStringList("tickers", tickers);
                                getInitVals();
                              },
                              icon: Icon(Icons.delete_forever)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
