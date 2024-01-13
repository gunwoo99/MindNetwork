import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindnetwork/Model/edge.dart';
import 'package:uuid/uuid.dart';

class Node {
  Node() {
    id = const Uuid().v4();
  }
  String id = '';
  double top = 0;
  double left = 0;
  double originTop = 0;
  double originLeft = 0;
  String name = '';
  List<Edge> upperEdges = [];
  List<Edge> lowerEdges = [];

  Node.fromJson(dynamic json) {
    id = json['id'];
    top = json['top'];
    left = json['left'];
    name = json['name'];
    for (dynamic edge in json['upperEdges']) {
      upperEdges.add(Edge.fromJson(edge));
    }
    for (dynamic edge in json['lowerEdges']) {
      lowerEdges.add(Edge.fromJson(edge));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'top': top,
      'left': left,
      'name': name,
      'upperEdges': List<dynamic>.from(upperEdges.map((x) => x.toJson())),
      'lowerEdges': List<dynamic>.from(lowerEdges.map((x) => x.toJson())),
    };
  }
}

Future<void> createNode(String networkId, Node node) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Node')
      .doc(node.id)
      .set(node.toJson());
  return;
}

Future<void> updateNode(String networkId, Node node) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Node')
      .doc(node.id)
      .update(node.toJson());
  return;
}

Future<void> deleteNode(String networkId, String nodeId) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Node')
      .doc(nodeId)
      .delete();
  return;
}

Future<List<Node>> getNodes(String networkId) async {
  QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Node')
      .get();
  List<Node> nodes = [];
  for (DocumentSnapshot<Map<String, dynamic>> doc in result.docs) {
    nodes.add(Node.fromJson(doc.data()));
  }
  return nodes;
}
