import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindnetwork/Model/edge.dart';
import 'package:mindnetwork/Model/network.dart';
import 'package:mindnetwork/Model/node.dart';
import 'package:mindnetwork/Model/user.dart';
import 'package:mindnetwork/common_fireservice.dart';

final networkViewmodelProvider =
    ChangeNotifierProvider((ref) => NetworkViewmodel());

class NetworkViewmodel extends ChangeNotifier {
  User me = User();
  Network selectedNetwork = Network();
  List<Network> networks = [];
  Offset center = const Offset(0, 0);
  List<Edge> edges = [];
  List<Node> nodes = [];
  Map<String, Node> nodeIds = {};
  List<bool> isNodeSelected = [];
  List<bool> isClicked = [];
  List<bool> isDetailed = [];

  Future<void> loadNetworkData(String networkId, int index) async {
    selectedNetwork = networks[index];
    nodes = await getNodes(networkId);
    edges = await getEdges(networkId);
    for (Node node in nodes) {
      nodeIds[node.id] = node;
    }
    isNodeSelected = List.generate(nodes.length, (index) => false);
    isClicked = List.generate(nodes.length, (index) => false);
    isDetailed = List.generate(nodes.length, (index) => false);
    notifyListeners();
    return;
  }

  Future<void> updateNetwork() async {
    for (Node node in nodes) {
      await updateNode(selectedNetwork.networkId, node);
    }
    for (Edge edge in edges) {
      await updateEdge(selectedNetwork.networkId, edge);
    }
    notifyListeners();
    return;
  }

  Future<void> updateNetworkName(String networkName, int index) async {
    networks[index].networkName = networkName;
    await FireService().updateDoc('Network', networks[index].networkId, networks[index].toJson());
    notifyListeners();
    return;
  }

  void getUserData(String userId) async {
    me = await getUser(userId);
    for (String networkId in me.networkIds) {
      networks.add(await getNetwork(networkId));
    }
    notifyListeners();
  }

  void deleteNetwork(int index) async {
    await FireService().deleteDoc('Network', networks[index].networkId);
    // print('delete network');

    me.networkIds.remove(networks[index].networkId);
    await FireService().updateDoc('User', me.userId, me.toJson());
    // print('remove network');

    networks.removeAt(index);
    notifyListeners();
  }

  void addNetwork() async {
    Network network = Network();
    await createNetwork(network);
    // print('create network');

    me.networkIds.add(network.networkId);
    await FireService().updateDoc('User', me.userId, me.toJson());
    // print('add network');

    networks.add(network);
    notifyListeners();
  }

  void setCenter(Offset offset) {
    center = offset;
    notifyListeners();
  }

  void clickNode(int index) {
    isClicked[index] = !isClicked[index];
    notifyListeners();
  }

  void clickNodeDetail(int index) {
    isDetailed[index] = !isDetailed[index];
    notifyListeners();
  }

  void selectTree(index){
    Map<String, bool> visited = {};
    Map<String, int> idToIndex = {};
    for (int i = 0; i < nodes.length; i++) {
      idToIndex[nodes[i].id] = i;
    }
    for (String id in nodeIds.keys) {
      visited[id] = false;
    }
    List<int> queue = [];
    isNodeSelected = List.generate(nodes.length, (index) => false);
    queue.add(index);

    while(queue.isNotEmpty){
      int curIndex = queue.removeAt(0);
      visited[nodes[curIndex].id] = true;
      isNodeSelected[curIndex] = true;

      for(Edge edge in nodes[curIndex].lowerEdges){
        if(!visited[edge.endNodeId]!){
          queue.add(idToIndex[edge.endNodeId]!);
        }
      }
    }
    notifyListeners();
  }

  void cancelSelectTree(){
    isNodeSelected = List.generate(nodes.length, (index) => false);
    notifyListeners();
  }

  void addNodeasChild(double left, double top, int index) async {
    // 새로운 노드 생성
    Node node = Node();
    node.left = left;
    node.top = top;

    // 새로운 노드의 엣지 생성
    Edge edge = Edge();
    edge.startNodeId = nodes[index].id;
    edge.endNodeId = node.id;
    edge.startLeft = nodes[index].left;
    edge.startTop = nodes[index].top;
    edge.endLeft = left;
    edge.endTop = top;

    // 노드들에 엣지 추가
    nodes[index].lowerEdges.add(edge);
    node.upperEdges.add(edge);
    
    // 노드와 엣지를 Network에 추가
    edges.add(edge);
    nodes.add(node);
    nodeIds[node.id] = node;
    isNodeSelected.add(false);
    isClicked.add(false);
    isDetailed.add(false);
    await createNode(selectedNetwork.networkId, node);
    await createEdge(selectedNetwork.networkId, edge);
    notifyListeners();
  }

  void addNode(double left, double top) {
    Node node = Node();
    node.left = left;
    node.top = top;
    nodes.add(node);
    nodeIds[node.id] = node;
    isNodeSelected.add(false);
    isClicked.add(false);
    isDetailed.add(false);
    createNode(selectedNetwork.networkId, node);
    notifyListeners();
  }

  void setNodeOriginPosition(Offset offset, int index) {
    nodes[index].originTop = offset.dy;
    nodes[index].originLeft = offset.dx;
    notifyListeners();
  }
  
  void moveNode(Offset offset, int index){
    nodes[index].top = nodes[index].originTop + offset.dy;
    nodes[index].left = nodes[index].originLeft + offset.dx;
    notifyListeners();
  }
}
