class PackageType {
  final int id;
  final String name;

  PackageType({required this.id, required this.name});

  factory PackageType.fromJson(Map<String, dynamic> json) {
    return PackageType(
      id: json['id'],
      name: json['name'],
    );
  }
}
