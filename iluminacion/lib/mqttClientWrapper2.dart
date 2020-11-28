import 'package:mqtt_client/mqtt_client.dart';
import 'package:vrcelights/models.dart';

class MQTTClientWrapper2 {
  MqttClient clientDistance;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  MQTTClientWrapper2();

  void prepareMqttClients() async {
    _setupMqttClients();
    await _connectClient();
    /*_subscribeToTopic(Constants.topicName);*/
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;

      await clientDistance.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientDistance.disconnect();
    }

    if (clientDistance.connectionStatus.state ==
        MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Mosquitto client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${clientDistance.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientDistance.disconnect();
    }
  }

  void _setupMqttClients() {
    clientDistance = MqttClient.withPort('192.168.0.7', 'distance', 1883);
    clientDistance.logging(on: false);
    clientDistance.keepAlivePeriod = 20;
    clientDistance.onDisconnected = _onDisconnected;
    clientDistance.onConnected = _onConnected;
    clientDistance.onSubscribed = _onSubscribed;
  }

  void publishDistance(String status) {
    _publishDistance(status);
  }

  void _publishDistance(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic distance');
    clientDistance.publishMessage(
        'distance', MqttQos.exactlyOnce, builder.payload);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');

    if (clientDistance.connectionStatus.returnCode ==
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
