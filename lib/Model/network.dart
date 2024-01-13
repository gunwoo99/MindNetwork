import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Network {
  String networkName = '';
  String networkId = '';

  Network() {
    networkName = 'New Network';
    networkId = const Uuid().v4();
  }

  Network.fromJson(dynamic json) {
    networkName = json['networkName'];
    networkId = json['networkId'];
  }

  Network.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Map<String, dynamic> toJson() {
    return {
      'networkName': networkName,
      'networkId': networkId,
    };
  }
}

Future<int> createNetwork(Network network) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(network.networkId)
      .set(network.toJson());

  return 0;
}

Future<Network> getNetwork(String networkId) async {
  DocumentSnapshot<Map<String, dynamic>> result = await FirebaseFirestore
      .instance
      .collection("Network")
      .doc(networkId)
      .get();
  Network network = Network.fromSnapShot(result);
  return network;
}
