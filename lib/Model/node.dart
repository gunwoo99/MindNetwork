import 'package:mindnetwork/Model/edge.dart';
import 'package:uuid/uuid.dart';

class Node{
  Node(){
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
}
