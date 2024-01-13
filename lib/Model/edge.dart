import 'package:uuid/uuid.dart';

class Edge{
  Edge(){
    id = const Uuid().v4();
  }
  String id = '';
  String startNodeId = '';
  String endNodeId = '';
  double startTop = 0;
  double startLeft = 0;
  double endTop = 0;
  double endLeft = 0;
}