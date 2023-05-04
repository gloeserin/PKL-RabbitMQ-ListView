

import 'package:flutter/material.dart';
import 'package:flutter_project_mqtt/mqtt_service.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();



  
}

 class _HomeScreenState extends State<HomeScreen>{
  List<String> messages = [];
  String publish = '';
  
  late String message;
  
  // var MqttManager;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  void initState() {
    super.initState();
    MqttService.subscribe();
    MqttService.onConnected = () {
      MqttService.subscribeTo('Todo', (String message) {
        setState(() {
          messages.add(message);
          print(messages);
         
        });
      });
    };
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: ((value) {
                publish = value;
              }),
              decoration: InputDecoration(
                labelText: "Enter message",
                prefixIcon: Icon(Icons.people),
                border: myinputborder(),
                focusedBorder: myinputborder(),
                enabledBorder: myinputborder()
              ),
            ),
            Container(height: 20),
    
    ElevatedButton (

      onPressed: (() {
        MqttService.publishTo('Todo', publish);
        }), child: const Text('Publish'),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: StadiumBorder(),
        ),
    )
          ],
        ),
      ),
    );

    ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(messages[index]),
          ),
        );
      },
      itemCount: messages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
    
  }


  
  myinputborder() {}
}

class string {
}

OutlineInputBorder myinputborder(){ 
    return OutlineInputBorder( 
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
          color:Colors.redAccent,
          width: 3,
        )
    );
  }
