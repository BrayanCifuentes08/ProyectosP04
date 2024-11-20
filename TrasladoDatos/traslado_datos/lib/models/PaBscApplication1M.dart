class PaBscApplication1M {
  final int application;
  final int applicationFather;
  final String description;
  final String observacion1;

  PaBscApplication1M({
    required this.application,
    required this.applicationFather,
    required this.description,
    required this.observacion1,
  });

  factory PaBscApplication1M.fromJson(Map<String, dynamic> json) {
    return PaBscApplication1M(
      application: json['application'],
      applicationFather: json['application_Father'],
      description: json['description'],
      observacion1: json['observacion_1'],
    );
  }
}
