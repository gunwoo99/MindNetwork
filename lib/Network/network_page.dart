import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        title: const Text("NetworkPage"),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const NetworkView(),
          Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        onPressed: () {
                          provider.addNode(100, 100);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text("Add Node"),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text("Network Saving ..."),
                            ),
                          );
                          provider.updateNetwork().then((value) {
                            context.pop();
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          "Save Network",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
          children: List.generate(provider.edges.length + provider.nodes.length,
              (index) {
            if (index < provider.edges.length) {
              return NetworkEdge(index: index);
            } else {
              return NetworkNode(index: index - provider.edges.length);
            }
          }),
        ),
      ),
    );
  }
}
