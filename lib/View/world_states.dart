import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:covid_tracker/Models/world_states_model.dart';
import 'package:covid_tracker/Services/api_service_fuction.dart';
import 'package:covid_tracker/View/countries_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';


class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1aa260),
        elevation: 6,
        
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.coronavirus, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Global COVID-19 Tracker",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            FutureBuilder(
                future: ApiService().getWorldStates(),
                builder: (context, AsyncSnapshot<worldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.teal.shade400,
                          size: 50.0,
                          controller: _controller,
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 20,),
                        PieChart(
                          dataMap: {
                            "Total": double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(snapshot.data!.recovered.toString()),
                            "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                          },
                          animationDuration: const Duration(milliseconds: 1500),
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                            showLegendsInRow: false,
                            showLegends: true,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            decimalPlaces: 1,
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 3,
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CasesAndDeathsContainer(
                                  title: "Cases",
                                  value: "${snapshot.data!.cases}",
                                  backgroundColor: const Color(0xff4a90e2),
                                  icon: FontAwesomeIcons.virus,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CasesAndDeathsContainer(
                                  title: "Deaths",
                                  value: "${snapshot.data!.deaths}",
                                  backgroundColor: const Color(0xffde5246),
                                  icon: FontAwesomeIcons.skullCrossbones,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            CardWidget(
                                title: "Recovered",
                                value: "${snapshot.data!.recovered}",
                                icon: FontAwesomeIcons.heart,
                                color: const Color(0xff1aa260)),
                            CardWidget(
                                title: "Active",
                                value: "${snapshot.data!.active}",
                                icon: FontAwesomeIcons.chartLine,
                                color: const Color(0xff4a90e2)),
                            CardWidget(
                                title: "Critical",
                                value: "${snapshot.data!.critical}",
                                icon: FontAwesomeIcons.triangleExclamation,
                                color: const Color(0xffde5246)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CountriesListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                              color: const Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Track Countries",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

// Reusable Widgets

class CasesAndDeathsContainer extends StatelessWidget {
  final String title, value;
  final Color backgroundColor;
  final IconData icon;
  const CasesAndDeathsContainer({
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const CardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
