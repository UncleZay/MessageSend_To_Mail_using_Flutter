
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  final formKey = GlobalKey<FormState>();

  // creating smtp server for gmail
    final gmailSmtp = gmail(dotenv.env["GMAIL_MAIL"]!, dotenv.env["GMAIL_PASSWORD"]!);



  // send mail to the user using smtp
    sendMailFromGmail(String sender, sub, text) async {
    final message = Message()
      ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Custom Support Stuff')
      ..recipients.add(sender)
      ..subject = sub
      ..text = text;
   
    try {
      final sendReport = await send(message, gmailSmtp);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text(
          "Send Message To Mail Using Flutter",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple,),
          
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                    controller: _recipientController,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.shade50,
                        filled: true,
                        label: const Text("Recipient Mail")),
                    validator: (value) =>
                        value!.isEmpty ? "Cannot be empty" : null),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.shade50,
                        filled: true,
                        label: const Text("Subject")),
                    validator: (value) =>
                        value!.isEmpty ? "Cannot be empty" : null),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.shade50,
                        filled: true,
                        label: const Text("Content")),
                    validator: (value) =>
                        value!.isEmpty ? "Cannot be empty" : null),
                const SizedBox(height: 20),
               
                ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        sendMailFromGmail(_recipientController.text, _subjectController.text, _contentController.text);
                      }
                    }, child: const Text("Send Mail")),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

