// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
// class SendEmail extends StatelessWidget {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _subjectController = TextEditingController();
//   TextEditingController _bodyController = TextEditingController();
//   _sendEmail() async {
//     final String _email = 'mailto:' +
//         _emailController.text +
//         '?subject=' +
//         _subjectController.text +
//         '&body=' +
//         _bodyController.text;
//     try {
//       await launch(_email);
//     } catch (e) {
//       throw 'Could not Call Phone';
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Call Phone from App Example')),
//       body: Center(
//           child: Column(
//         children: <Widget>[
//           TextField(
//             controller: _emailController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Email',
//             ),
//           ),
//           TextField(
//             controller: _subjectController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Subject',
//             ),
//           ),
//           TextField(
//             controller: _bodyController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Message',
//             ),
//           ),
//           TextButton(
//             child: Text('Send Email'),
//             //color: Colors.red,
//             onPressed: _sendEmail,
//           ),
//         ],
//       )),
//     );
//   }
// }