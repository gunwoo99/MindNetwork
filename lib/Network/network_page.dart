import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindnetwork/Network/network_edge.dart';
import 'package:mindnetwork/Network/network_node.dart';
import 'package:mindnetwork/Network/network_viewmodel.dart';

class NetworkPage extends ConsumerStatefulWidget {
  const NetworkPage({super.key});

  @override
  ConsumerState<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends ConsumerState<NetworkPage> {
  List<String> mapData = List.generate(100, (index) => 'Map Block $index');

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(networkViewmodelProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: const NetworkView(),
          ),
          const Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Network Page",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                provider.addNode(100, 100);
              },
              child: ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkView extends ConsumerStatefulWidget {
  const NetworkView({super.key});

  @override
  ConsumerState<NetworkView> createState() => _NetworkState();
}

class _NetworkState extends ConsumerState<NetworkView> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(networkViewmodelProvider);
    return InteractiveViewer(
      clipBehavior: Clip.none,
      constrained: false,
      minScale: 0.1,
      child: Container(
        height: 10000,
        width: 10000,
        color: Colors.red,
        child: Stack(
          children: List.generate(
              provider.edges.length + provider.nodes.length, (index) {
                if (index < provider.edges.length){
                  return NetworkEdge(index: index);
                }
                else{
                  return NetworkNode(index: index - provider.edges.length);
                }
              }),
        ),
      ),
    );
  }
}
