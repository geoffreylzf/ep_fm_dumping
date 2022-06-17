import 'package:ep_fm_dumping/controllers/dumps/_id/index.dart';
import 'package:ep_fm_dumping/utils/node_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DumpIdIndexPage extends StatelessWidget {
  DumpIdIndexPage({Key? key}) : super(key: key);

  final ctrl = Get.put(DumpIdIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final dump = ctrl.rxFmProdDumping.value;
          if (dump == null) {
            return const Text("Loading ... ");
          }
          return Text(dump.skuName);
        }),
      ),
      body: Obx(() {
        final dump = ctrl.rxFmProdDumping.value;
        if (dump == null) {
          return const Center(child: Text("Loading ... "));
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dump.skuCode, style: const TextStyle(fontSize: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dump.createHumanDate),
                      Text(dump.createHumanTime),
                    ],
                  ),
                  Text("QTY : ${dump.qty}"),
                  Text("WEIGHT : ${dump.weight} Kg"),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EntryForm(),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              color: Colors.grey.shade500,
              child: const Text(
                "Worker List",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            WorkerListDisplay(),
            ActionButton(),
          ],
        );
      }),
    );
  }
}

class EntryForm extends StatelessWidget {
  EntryForm({Key? key}) : super(key: key);

  final ctrl = Get.find<DumpIdIndexController>();

  @override
  Widget build(BuildContext context) {
    final isCreate = ctrl.rxIsCreate.value;
    return Form(
      key: ctrl.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: ctrl.tecSlotNo,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Slot #",
              contentPadding: EdgeInsets.all(8),
            ),
            enabled: isCreate,
            validator: (value) {
              if (value!.isEmpty) {
                return "Cannot blank";
              }
              if (int.tryParse(value) == null) {
                return "Number only";
              }
              return null;
            },
          ),
          Container(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: ctrl.tecBucketQtyTtl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bucket Total Qty",
                    contentPadding: EdgeInsets.all(8),
                  ),
                  enabled: isCreate,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cannot blank";
                    }
                    if (double.tryParse(value) == null) {
                      return "Number with decimal only";
                    }
                    return null;
                  },
                ),
              ),
              Container(width: 8),
              Expanded(
                  child: TextFormField(
                controller: ctrl.tecBagQtyTtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bag Total Qty",
                  contentPadding: EdgeInsets.all(8),
                ),
                enabled: isCreate,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Cannot blank";
                  }
                  if (int.tryParse(value) == null) {
                    return "Number only";
                  }
                  return null;
                },
              )),
            ],
          ),
          Container(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: ctrl.tecTimeStart,
                  enableInteractiveSelection: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Time Start",
                    contentPadding: EdgeInsets.all(8),
                  ),
                  enabled: isCreate,
                  onTap: () async {
                    var initTime = TimeOfDay.now();
                    if (ctrl.tecTimeStart.text.isNotEmpty) {
                      initTime =
                          TimeOfDay.fromDateTime(ctrl.timeFormat.parse(ctrl.tecTimeStart.text));
                    }
                    final selTime = await showTimePicker(
                      context: context,
                      initialTime: initTime,
                    );
                    if (selTime != null) {
                      final now = DateTime.now();

                      ctrl.tecTimeStart.text = ctrl.timeFormat.format(
                          DateTime(now.year, now.month, now.day, selTime.hour, selTime.minute));
                    }
                    FocusScope.of(Get.context!).requestFocus(FocusNode());
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cannot blank";
                    }
                    return null;
                  },
                ),
              ),
              Container(width: 8),
              Expanded(
                child: TextFormField(
                  controller: ctrl.tecTimeEnd,
                  enableInteractiveSelection: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Time End",
                    contentPadding: EdgeInsets.all(8),
                  ),
                  enabled: isCreate,
                  onTap: () async {
                    var initTime = TimeOfDay.now();
                    if (ctrl.tecTimeEnd.text.isNotEmpty) {
                      initTime =
                          TimeOfDay.fromDateTime(ctrl.timeFormat.parse(ctrl.tecTimeEnd.text));
                    }
                    final selTime = await showTimePicker(
                      context: context,
                      initialTime: initTime,
                    );
                    if (selTime != null) {
                      final now = DateTime.now();

                      ctrl.tecTimeEnd.text = ctrl.timeFormat.format(
                          DateTime(now.year, now.month, now.day, selTime.hour, selTime.minute));
                    }
                    FocusScope.of(Get.context!).requestFocus(FocusNode());
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cannot blank";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkerListDisplay extends StatelessWidget {
  WorkerListDisplay({Key? key}) : super(key: key);

  final ctrl = Get.find<DumpIdIndexController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            final wkList = ctrl.rxFmProdDumping.value?.workers ?? [];
            final isCreate = ctrl.rxIsCreate.value;

            if (wkList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("No worker is assigned"),
              );
            }
            return Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wkList.length,
                    separatorBuilder: (_, index) => const Divider(height: 0),
                    itemBuilder: (_, idx) {
                      final wk = wkList[idx];

                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: PageStorageKey(wk.fmPersonWorkerId.toString()),
                        onDismissed: (direction) {
                          ctrl.deleteWorker(wk);
                        },
                        confirmDismiss: (_) async {
                          return isCreate;
                        },
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.clear, color: Colors.white),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text("${idx + 1}. ${wk.workerName}"),
                        ),
                      );
                    }),
                const Text("Swipe left to delete worker", style: TextStyle(fontSize: 10)),
              ],
            );
          },
        ),
        Obx(() {
          final isCreate = ctrl.rxIsCreate.value;
          if (!isCreate){
            return Container();
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey.shade600,
              ),
              child: const Text("Manage Worker List"),
              onPressed: () => ctrl.gotoAddWorkersPage(),
            ),
          );
        })
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key? key}) : super(key: key);

  final ctrl = Get.find<DumpIdIndexController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (ctrl.rxIsCreate.value) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("SAVE"),
              onPressed: () async {
                if (ctrl.formKey.currentState!.validate()) {
                  ctrl.saveEntry();
                }
              },
            ),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            icon: const Icon(Icons.delete_forever),
            label: const Text("DELETE"),
            onPressed: () async {
              if (ctrl.formKey.currentState!.validate()) {
                ctrl.deleteEntry();
              }
            },
          ),
        );
      },
    ).paddingSymmetric(horizontal: 8, vertical: 4);
  }
}
