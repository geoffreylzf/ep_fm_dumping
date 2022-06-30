class Store {
  int? id;
  String storeCode;
  String storeName;

  bool isSelected = false;

  Store(this.id, this.storeCode, this.storeName);

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        json['id'] as int?,
        json['store_code'] as String,
        json['store_name'] as String,
      );
}
