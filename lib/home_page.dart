import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindnetwork/Network/network_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    final provider = ref.read(networkViewmodelProvider);
    provider.getUserData('WtoeVVZVxjdusnYlotQK');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(networkViewmodelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.blue[200],
          ),
          Positioned(
            child: SizedBox(
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    provider.networks.length,
                    ((index) {
                      return NetworkListTile(index: index);
                    }),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: GestureDetector(
              onTap: () => provider.addNetwork(),
              child: ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue[600],
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NetworkListTile extends ConsumerStatefulWidget {
  const NetworkListTile({super.key, required this.index});
  final int index;

  @override
  ConsumerState<NetworkListTile> createState() => _NetworkListTileState();
}

class _NetworkListTileState extends ConsumerState<NetworkListTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int index = widget.index;
    final provider = ref.watch(networkViewmodelProvider);
    return Container(
      height: 100,
      width: size.width - 40,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child:
                Text("Network Name : ${provider.networks[index].networkName}"),
          ),
          Positioned(
            right: 95,
            bottom: 5,
            child: ElevatedButton(
              onPressed: () {
                context.go('/NetworkPage');
              },
              child: const Text('Network'),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: ElevatedButton(
              onPressed: () {
                provider.deleteNetwork(index);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 253, 218, 222)),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
