import 'package:mqtt_client/mqtt_client.dart';
import 'package:vrcelights/models.dart';

class MQTTClientWrapper {
  MqttClient clientTime;

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

      await clientTime.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;

      clientTime.disconnect();
    }

    if (clientTime.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Mosquitto client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${clientTime.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientTime.disconnect();
    }
  }

  void _setupMqttClients() {
    clientTime = MqttClient.withPort('192.168.0.7', 'time', 1883);
    clientTime.logging(on: false);
    clientTime.keepAlivePeriod = 20;
    clientTime.onDisconnected = _onDisconnected;
    clientTime.onConnected = _onConnected;
    clientTime.onSubscribed = _onSubscribed;
  }

  void publishTime(String status) {
    _publishTime(status);
  }

  void _publishTime(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic time');
    clientTime.publishMessage('time', MqttQos.exactlyOnce, builder.payload);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');

    if (clientTime.connectionStatus.returnCode ==
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
