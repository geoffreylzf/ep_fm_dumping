class FmPersonWorker {
  int id;
  String workerCode;
  String workerName;

  bool isSelected = false;

  FmPersonWorker(this.id, this.workerCode, this.workerName);

  factory FmPersonWorker.fromJson(Map<String, dynamic> json) => FmPersonWorker(
        json['id'] as int,
        json['worker_code'] as String,
        json['worker_name'] as String,
      );

  toggleSelect() {
    isSelected = !isSelected;
  }
}
