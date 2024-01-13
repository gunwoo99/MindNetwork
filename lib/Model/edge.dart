import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Edge {
  Edge() {
    id = const Uuid().v4();
  }
  String id = '';
  String startNodeId = '';
  String endNodeId = '';
  double startTop = 0;
  double startLeft = 0;
  double endTop = 0;
  double endLeft = 0;

  Edge.fromJson(dynamic json) {
    id = json['id'];
    startNodeId = json['startNodeId'];
    endNodeId = json['endNodeId'];
    startTop = json['startTop'];
    startLeft = json['startLeft'];
    endTop = json['endTop'];
    endLeft = json['endLeft'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startNodeId': startNodeId,
      'endNodeId': endNodeId,
      'startTop': startTop,
      'startLeft': startLeft,
      'endTop': endTop,
      'endLeft': endLeft,
    };
  }
}

Future<void> createEdge(String networkId, Edge edge) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Edge')
      .doc(edge.id)
      .set(edge.toJson());
  return;
}

Future<void> updateEdge(String networkId, Edge edge) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Edge')
      .doc(edge.id)
      .update(edge.toJson());
  return;
}

Future<void> deleteEdge(String networkId, String edgeId) async {
  await FirebaseFirestore.instance
      .collection('Network')
      .doc(networkId)
      .collection('Edge')
      .doc(edgeId)
      .delete();
  return;
}

Future<List<Edge>> getEdges(String networkId) async {
  QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
      .instance
      .collection('Network')
      .doc(networkId)
      .collection('Edge')
      .get();
  List<Edge> edges = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> edge in result.docs) {
    edges.add(Edge.fromJson(edge.data()));
  }
  return edges;
}
