class TvAppModel {
  final String name;
  final String package;
  final String? icon;

  TvAppModel(this.name, this.package, this.icon);

  factory TvAppModel.fromJson(Map<String, dynamic> json) {
    return TvAppModel(
        json['name'],
        json['package'],
        json['icon']
    );
  }
}
