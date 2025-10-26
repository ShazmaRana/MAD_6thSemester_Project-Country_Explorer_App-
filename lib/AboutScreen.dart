import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class AboutScreen extends StatelessWidget{


AboutScreen({super.key});

  // Function to open the URL
  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://restcountries.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

@override
  Widget build(BuildContext context) {
   return Scaffold(
    
    appBar: AppBar(
      leading: const BackButton(color: Colors.white,),
      title: Text('About',
    style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
   ),
    backgroundColor:Colors.blue),


    body: SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(16.0),
      child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
  const SizedBox(height: 40,),
  const Icon(Icons.public , size: 80, color: Colors.blue,),
  SizedBox(height: 20,),

  Text('Country Explorer', 
  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold , color: Colors.black),
  ),
  Text('Version 2.0.0', style: TextStyle(color: Colors.grey),),

SizedBox(height: 20,),

  Text('Country Explrer is a mobile application that'
  'allows you to explore countries around the world.'
  'You can search countries,'
  'view details about them and save you favourite '
  'ones for easy access.\n'
  ,textAlign: TextAlign.center,),


RichText(
  textAlign: TextAlign.center,
  text: 
TextSpan(style: const TextStyle(color: Colors.black),
children: [

  const TextSpan(
    text: 'This app uses the '
  ),
  TextSpan(
    text: 'REST Countries API',
    style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
    ..onTap = (){

     _launchURL();
    },
  ),
  const TextSpan(text: 'to fetch country data'),
]

),
),
const SizedBox(height: 30,),
const Text('Developed by Shazma Rana & Zoya Zahid\n Copyright @2025 All rights reserved',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey),)


  
],
      
      ),
      ),
    ),
  );


  }

}