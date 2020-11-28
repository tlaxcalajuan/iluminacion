import 'package:mqtt_client/mqtt_client.dart';
import 'package:vrcelights/models.dart';

class MQTTClientWrapper {
  MqttClient clientLight;

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
      await clientLight.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientLight.disconnect();
    }

    if (clientLight.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Mosquitto client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${clientLight.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      clientLight.disconnect();
    }
  }

  void _setupMqttClients() {
    clientLight = MqttClient.withPort('192.168.0.7', 'light', 1883);
    clientLight.logging(on: false);
    clientLight.keepAlivePeriod = 20;
    clientLight.onDisconnected = _onDisconnected;
    clientLight.onConnected = _onConnected;
    clientLight.onSubscribed = _onSubscribed;
  }

  void publishStatus(String status) {
    _publishStatus(status);
  }

  void _publishStatus(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic light');
    clientLight.publishMessage('light', MqttQos.exactlyOnce, builder.payload);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    if (clientLight.connectionStatus.returnCode ==
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
