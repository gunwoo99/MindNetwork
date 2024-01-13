import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindnetwork/Network/network_viewmodel.dart';

import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NetworkNode extends ConsumerStatefulWidget {
  const NetworkNode({super.key, required this.index});
  final int index;

  @override
  ConsumerState<NetworkNode> createState() => _NetworkNodeState();
}

class _NetworkNodeState extends ConsumerState<NetworkNode> {
  late int index;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(networkViewmodelProvider);
    index = widget.index;
    return Positioned(
      top: provider.nodes[index].top,
      left: provider.nodes[index].left,
      child: Row(
        children: [
          GestureDetector(
            onTapDown: (details) {
              provider.selectTree(index);
            },
            onTapUp: (details) {
              provider.cancelSelectTree();
              provider.clickNode(index);
            },
            
            onLongPressStart: (details) {
              provider.setNodeOriginPosition(
                  Offset(provider.nodes[index].left, provider.nodes[index].top),
                  index);
            },
            onLongPressMoveUpdate: (details) {
              provider.moveNode(details.localOffsetFromOrigin, index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              height: provider.isDetailed[index] ? 200 : 40,
              width:  provider.isDetailed[index] ? 100 : 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: provider.isNodeSelected[index] ? Colors.blue : Colors.white.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "$index",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      "${provider.nodes[index].left}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      "${provider.nodes[index].top}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            height: 40,
            width: provider.isClicked[index] ? 120 : 0,
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      provider.addNodeasChild(provider.nodes[index].left + 100,
                          provider.nodes[index].top, index);
                    },
                    child: const Text(
                      "Add Node as Child",
                      overflow: TextOverflow.ellipsis,
                    )),
                GestureDetector(
                    onTap: () {
                      provider.clickNodeDetail(index);
                    },
                    child: const Text(
                      "Details",
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
