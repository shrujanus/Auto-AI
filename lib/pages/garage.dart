import 'package:flutter/material.dart';
import '../widget/info_card.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:web_socket_channel/io.dart';
import 'package:alan_voice/alan_voice.dart';

class garagePage extends StatefulWidget {
  garagePage({super.key});

  @override
  State<garagePage> createState() => _garagePageState();
}

class _garagePageState extends State<garagePage> {
  late bool isConnected;
  late IOWebSocketChannel channel;

  @override
  void initState() {
    AlanVoice.addButton(
      "8385791ad0deea6e53e8e230ec834dae2e956eca572e1d8b807a3e2338fdd0dc/prod",
      buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    );
    isConnected = false;
    super.initState();
    Future.delayed(Duration.zero, () async {
      channelconnect();
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          setState(() {
            if (message == "connected") {
              isConnected = true;
            }
          });
        },
        onDone: () {
          setState(() {
            isConnected = false;
          });
        },
      );
    } catch (_) {
      channelconnect();
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (isConnected == true) {
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: const Color(0xFF121212),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          const Text('Welcome to the Garage.',
                              style: TextStyle(fontSize: 35)),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/Car_gg.png',
                                fit: BoxFit.cover,
                                height: 250,
                                width: 500,
                              ),
                              isConnected
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.signal_wifi_4_bar_outlined,
                                          color: Color.fromARGB(255, 3, 186, 0),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text('Connected'),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.signal_wifi_bad_outlined,
                                            color:
                                                Color.fromARGB(255, 215, 0, 0)),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text('Disconnected'),
                                        )
                                      ],
                                    )
                            ],
                          ),
                        ],
                      ),
                      info_card(
                          title: 'Vachile speed',
                          icon: const Icon(
                            Ionicons.speedometer_outline,
                            color: Color(0xFF808080),
                          ),
                          value: '50 km/h'),
                      info_card(
                          title: 'Fuel Level',
                          icon: const Icon(
                            Icons.local_gas_station,
                            color: Color(0xFF808080),
                          ),
                          value: '50%'),
                      info_card(
                          title: 'Engine Temp',
                          icon: const Icon(
                            Icons.thermostat,
                            color: Color(0xFF808080),
                          ),
                          value: '175 C'),
                      info_card(
                          title: 'Gauge Pressure',
                          icon: const Icon(
                            Icons.trending_up,
                            color: Color(0xFF808080),
                          ),
                          value: '565kPa'),
                      info_card(
                          title: 'RPM',
                          icon: const Icon(
                            Icons.speed,
                            color: Color(0xFF808080),
                          ),
                          value: '7000'),
                      info_card(
                          title: 'O2 sen',
                          icon: const Icon(
                            Icons.leaderboard,
                            color: Color(0xFF808080),
                          ),
                          value: '99.2%'),
                      info_card(
                          title: 'ABP',
                          icon: const Icon(
                            Icons.tab,
                            color: Color(0xFF808080),
                          ),
                          value: '200kPa'),
                      info_card(
                          title: 'Fuel Type',
                          icon: const Icon(
                            Icons.local_gas_station,
                            color: Color(0xFF808080),
                          ),
                          value: 'Petrol'),
                      info_card(
                          title: 'Battery',
                          icon: const Icon(
                            Icons.battery_4_bar_rounded,
                            color: Color(0xFF808080),
                          ),
                          value: 'Full'),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              )
            ]),
      )),
    );
  }
}
