import 'package:ep_fm_dumping/models/fm_prod_dumping_entry_worker.dart';
import 'package:intl/intl.dart';

class FmProdDumping {
  int id;
  int itemPackingId;
  String skuCode;
  String skuName;
  double qty;
  double weight;
  String createDate;

  int? entryId;
  int? slotNo;
  double? bucketQtyTtl;
  int? bagQtyTtl;
  String? timeStart;
  String? timeEnd;

  List<FmProdDumpingEntryWorker> workers = [];

  FmProdDumping(
    this.id,
    this.itemPackingId,
    this.skuCode,
    this.skuName,
    this.qty,
    this.weight,
    this.createDate, {
    this.entryId,
    this.slotNo,
    this.bucketQtyTtl,
    this.bagQtyTtl,
    this.timeStart,
    this.timeEnd,
    required this.workers,
  });

  factory FmProdDumping.fromJson(Map<String, dynamic> json) => FmProdDumping(
        json['id'] as int,
        json['item_packing_id'] as int,
        json['sku_code'] as String,
        json['sku_name'] as String,
        json['qty'] is int ? (json['qty'] as int).toDouble() : json['qty'] as double,
        json['weight'] is int ? (json['weight'] as int).toDouble() : json['weight'] as double,
        json['create_date'] as String,
        entryId: json['entry_id'] as int?,
        slotNo: json['slot_no'] as int?,
        bucketQtyTtl: json['bucket_qty_ttl'] is int
            ? (json['bucket_qty_ttl'] as int).toDouble()
            : json['bucket_qty_ttl'] as double?,
        bagQtyTtl: json['bag_qty_ttl'] as int?,
        timeStart: json['time_start'] as String?,
        timeEnd: json['time_end'] as String?,
        workers: (json['workers'] as List?)
                ?.map((e) => FmProdDumpingEntryWorker.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toEntryJson() => <String, dynamic>{
        'id': id,
        'entry_id': entryId,
        'slot_no': slotNo,
        'bucket_qty_ttl': bucketQtyTtl,
        'bag_qty_ttl': bagQtyTtl,
        'time_start': timeStart,
        'time_end': timeEnd,
        'workers': workers.map((e) => e.toJson()).toList(),
      };

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final timeFormat = DateFormat('HH:mm:ss');

  String get createHumanDate {
    return DateFormat.yMMMd().format(dateFormat.parse(createDate));
  }

  String get createHumanTime {
    return DateFormat.jm().format(dateFormat.parse(createDate));
  }

  bool get isHavingEntry {
    return entryId != null;
  }

  String get humanTimeStart {
    if (timeStart != null) {
      return DateFormat.jm().format(timeFormat.parse(timeStart!));
    }
    return '';
  }

  String get humanTimeEnd {
    if (timeEnd != null) {
      return DateFormat.jm().format(timeFormat.parse(timeEnd!));
    }
    return '';
  }
}
