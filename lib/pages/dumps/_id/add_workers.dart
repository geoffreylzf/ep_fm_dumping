import 'package:ep_fm_dumping/controllers/dumps/_id/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DumpIdIndexAddWorkersPage extends StatelessWidget {
  DumpIdIndexAddWorkersPage({Key? key}) : super(key: key);

  final ctrl = Get.find<DumpIdIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Workers')),
      body: Column(
        children: [
          Expanded(child: WorkerSelectionListView()),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Insert Selected Worker".toUpperCase()),
              onPressed: () => ctrl.insertSelectedWorkers(),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerSelectionListView extends StatelessWidget {
  WorkerSelectionListView({Key? key}) : super(key: key);

  final ctrl = Get.find<DumpIdIndexController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final wkList = ctrl.rxFmPersonWorkerList.value;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: wkList.length,
          separatorBuilder: (_, idx) => const Divider(height: 0),
          itemBuilder: (_, idx) {
            final wk = wkList[idx];

            return ListTile(
              title: Text(wk.workerCode),
              subtitle: Text(wk.workerName),
              onTap: () => ctrl.toggleWorkerSelection(wk),
              trailing: Checkbox(
                value: wk.isSelected,
                onChanged: (_) => ctrl.toggleWorkerSelection(wk),
              ),
            );
          },
        );
      },
    );
  }
}
