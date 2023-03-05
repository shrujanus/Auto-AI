import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class securityPage extends StatelessWidget {
  securityPage({super.key});

  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: "AC40c5aa71068752f3f2f9421b831c8b35",
      authToken: "b226169a88c295b181d15f1dd565fdb0",
      twilioNumber: "+18449311327");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TransparentImageCard(
              title: Text(
                'Child Lock',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              description: Text(
                'Set Remainders about your childs speed limit, location and car condition',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 15,
                ),
              ),
              height: 250,
              imageProvider: AssetImage('assets/card_images/child.jpg')),
          GestureDetector(
            onTap: () {
              print("msg sent");
              twilioFlutter.sendSMS(
                  toNumber: '+16316013970',
                  messageBody:
                      "Your Child's current speed is above 70 m/h and they are at an unusual location");
            },
            child: const TransparentImageCard(
              contentPadding: EdgeInsets.all(10),
              height: 250,
              imageProvider: AssetImage('assets/card_images/emg.png'),
              description: Text(
                'Add two emeargency contacts in case of Emergancy such as car crash, engine failure, break failure',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 15,
                ),
              ),
              title: Text(
                'Emergency Contacts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
