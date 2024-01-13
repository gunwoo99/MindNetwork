import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindnetwork/Network/network_viewmodel.dart';

class NetworkEdge extends ConsumerStatefulWidget {
  const NetworkEdge({super.key, required this.index});
  final int index;

  @override
  ConsumerState<NetworkEdge> createState() => _NetworkEdgeState();
}

class _NetworkEdgeState extends ConsumerState<NetworkEdge> {
  late int index;
  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(networkViewmodelProvider);
    String startId = provider.edges[index].startNodeId;
    String endId = provider.edges[index].endNodeId;
    return CustomPaint(
      painter: EdgePainter(
        Offset(
            provider.nodeIds[startId]!.left + 20, provider.nodeIds[startId]!.top + 20),
        Offset(
            provider.nodeIds[endId]!.left + 20, provider.nodeIds[endId]!.top + 20),
      ),
    );
  }
}

class EdgePainter extends CustomPainter {
  const EdgePainter(this.start, this.end);
  final Offset start;
  final Offset end;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(start, end, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
