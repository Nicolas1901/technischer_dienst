import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendMail{

  static Future<void> send() async {
    final Email email = Email(
      body: "Eine Email von meiner App",
      subject: "Test Email",
      recipients: ["nicolas.will01@gmail.com"],
    );

    try{
      await FlutterEmailSender.send(email);
    } catch(e){
      print(e.toString());
    }
  }
}