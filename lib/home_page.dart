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
    final provider = ref.watch(networkViewmodelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: ListView.builder(
        itemCount: provider.networks.length,
        itemBuilder: (context, index) {
          return NetworkListTile(index: index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.addNetwork(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
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
            child: Text(
              "Network Name : ${provider.networks[index].networkName}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 195,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      EditNetworkNamePopUp(index: index),
                );
              },
              child: const Text('EditName'),
            ),
          ),
          Positioned(
            right: 95,
            bottom: 5,
            child: ElevatedButton(
              onPressed: () {
                provider.loadNetworkData(
                    provider.networks[index].networkId, index);
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

class EditNetworkNamePopUp extends ConsumerStatefulWidget {
  const EditNetworkNamePopUp({super.key, required this.index});
  final int index;

  @override
  ConsumerState<EditNetworkNamePopUp> createState() =>
      _EditNetworkNamePopUpState();
}

class _EditNetworkNamePopUpState extends ConsumerState<EditNetworkNamePopUp> {
  late String edittedNetworkName;
  @override
  void initState() {
    super.initState();
    final provider = ref.read(networkViewmodelProvider);
    edittedNetworkName = provider.networks[widget.index].networkName;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(networkViewmodelProvider);
    return AlertDialog(
      title: const Text('Edit Network Name'),
      content: TextField(
        onChanged: (value) {
          edittedNetworkName = value;
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await provider
                .updateNetworkName(edittedNetworkName, widget.index)
                .then((value) {
              context.pop();
            });
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }
}
