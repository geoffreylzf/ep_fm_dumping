class FmProdDumpingEntryWorker {
  int? id;
  int fmPersonWorkerId;
  String workerCode;
  String workerName;

  FmProdDumpingEntryWorker({
    this.id,
    required this.fmPersonWorkerId,
    required this.workerCode,
    required this.workerName,
  });

  factory FmProdDumpingEntryWorker.fromJson(Map<String, dynamic> json) => FmProdDumpingEntryWorker(
        id: json['id'] as int?,
        fmPersonWorkerId: json['fm_person_worker_id'] as int,
        workerCode: json['worker_code'] as String,
        workerName: json['worker_name'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'fm_person_worker_id': fmPersonWorkerId,
      };
}
