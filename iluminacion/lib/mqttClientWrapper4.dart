import 'package:mqtt_client/mqtt_client.dart';
import 'package:vrcelights/models.dart';

class MQTTClientWrapper {
  MqttClient clientColor;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  MQTTClientWrapper();

  void prepareMqttClients() async {
    _setupMqttClients();
    await _connectClient();
    /*_subscribeToTopic(Constants.topicName);*/
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await clientColor.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientColor.disconnect();
    }

    if (clientColor.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Mosquitto client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${clientColor.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientColor.disconnect();
    }
  }

  void _setupMqttClients() {
    clientColor = MqttClient.withPort('192.168.0.7', 'color', 1883);
    clientColor.logging(on: false);
    clientColor.keepAlivePeriod = 20;
    clientColor.onDisconnected = _onDisconnected;
    clientColor.onConnected = _onConnected;
    clientColor.onSubscribed = _onSubscribed;
  }

  void publishColor(String status) {
    _publishColor(status);
  }

  void _publishColor(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic color');
    clientColor.publishMessage('color', MqttQos.exactlyOnce, builder.payload);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');

    if (clientColor.connectionStatus.returnCode ==
        MqttConnectReturnCode.solicited) {
      print(
          'MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    }
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
  }
}
