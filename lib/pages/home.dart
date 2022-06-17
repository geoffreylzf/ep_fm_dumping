import 'package:ep_fm_dumping/controllers/home.dart';
import 'package:ep_fm_dumping/utils/node_util.dart';
import 'package:ep_fm_dumping/widgets/nav_drawer_start.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const NavDrawerStart(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: TextField(
              controller: ctrl.tecDumpingDate,
              enableInteractiveSelection: false,
              focusNode: AlwaysDisabledFocusNode(),
              onTap: () async {
                var iniDate = DateTime.now();
                if (ctrl.tecDumpingDate.text.isNotEmpty) {
                  iniDate = ctrl.dateFormat.parse(ctrl.tecDumpingDate.text);
                }

                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: iniDate,
                  firstDate: DateTime.now().add(const Duration(days: -1000)),
                  lastDate: DateTime.now().add(const Duration(days: 1000)),
                );

                if (selectedDate != null) {
                  ctrl.tecDumpingDate.text = ctrl.dateFormat.format(selectedDate);
                }

                FocusScope.of(Get.context!).requestFocus(FocusNode());
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range),
                labelText: "Visit Date",
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await ctrl.refreshDumpingList(),
              child: Obx(() {
                final list = ctrl.rxFmProdDumpingList.value;
                if (list.isEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (_, idx) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: Text("No record found")),
                        );
                      });
                }
                return ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, index) => const Divider(height: 0),
                    itemBuilder: (_, idx) {
                      final dump = list[idx];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            ctrl.gotoDump(dump);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dump.createHumanDate),
                                  Text(dump.createHumanTime),
                                ],
                              ),
                              Text(
                                "${idx + 1}. ${dump.skuName}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(dump.skuCode, style: const TextStyle(fontSize: 10)),
                              Text("QTY : ${dump.qty}"),
                              Text("WEIGHT : ${dump.weight} Kg"),
                              if (dump.isHavingEntry)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "SLOT # : ${dump.slotNo ?? ''}\n"
                                      "BUCKET QTY : ${dump.bucketQtyTtl ?? ''}\n"
                                      "BAG QTY : ${dump.bagQtyTtl ?? ''}",
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded, color: Colors.green),
                                        Text(
                                          "${dump.humanTimeStart} ~ ${dump.humanTimeEnd}",
                                          style: const TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              else
                                const Text(
                                  "This dumping does not have entry yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                )
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          )
        ],
      ),
    );
  }
}
