import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static Function? onConnected;
 static MqttServerClient? client;
  static var pongCount = 0;
  static late String _identifier;

  static void subscribe() async {
    _identifier = '';
    client = MqttServerClient('10.0.2.2', '');
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.logging(on: true);
   client!.onConnected = () {
      print('connected');
      onConnected?.call();
    };
    client!.onSubscribed = onSubscribed;

    try {
      await client?.connect('guest', 'guest');
      client!.subscribe('Todo', MqttQos.atLeastOnce);
      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        messages.forEach((message) {
          final MqttPublishMessage receivedMessage =
              message.payload as MqttPublishMessage;
          final String payload = MqttPublishPayload.bytesToStringAsString(
              receivedMessage.payload.message);
          print('Received message: $payload');
       
        });
      });
      // data();
    } on NoConnectionException catch (e) {
      print('[MQTT SERVICE] client connection fails');
      client?.disconnect();
    }
  }

  static void publish(String topic, String data) async {
    _identifier = '';
    client = MqttServerClient('10.0.2.2', '');
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.logging(on: true);
    client!.onConnected = () {
      print('connected');
      onConnected?.call();
    };

    try {
      await client?.connect('guest', 'guest');
      publish(topic, data);
    } on NoConnectionException catch (e) {
      print('[MQTT SERVICE] client connection fails');
    }
  }


  static void onSubscribed(String topic) {
    print('[MQTT SERVICE] Subscription confirmed to topic $topic');
  }

  static void onDisconnected() {
    print('[MQTT SERVICE] client dissconected');
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('[MQTT SERVICE] client disconnected because soliciated');
    } else {
      print('[MQTT SERVICE] client disconnected ');
      exit(-1);
    }
    if (pongCount == 3) {
      print('[MQTT SERVICE] Pong count is correct');
    } else {
      print('[MQTT SERVICE] Pong count is incorrect');
    }
  }

   static void subscribeTo(String topic, Function(String) onMessage) {
    client!.subscribe(topic, MqttQos.atLeastOnce);
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      messages.forEach((message) {
        final MqttPublishMessage receivedMessage =
            message.payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        print('Received message: $payload');
        onMessage(payload);
      });
    });

}
  static void publishTo(String topic, String data) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(data);
    client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!); 
  }

}