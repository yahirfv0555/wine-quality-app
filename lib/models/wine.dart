
import 'dart:convert';

List<WineDto> wineFromJson(String str) => List<WineDto>.from(json.decode(str).map((x) => WineDto.fromJson(x)));
String wineToJson(WineDao data) => json.encode(data.toJson());

class WineDto{
  WineDto({
    this.quality
  });

  double? quality;

  factory WineDto.fromJson(Map<String,dynamic> json) => WineDto(
    quality: json['quality'],
  );

}

class WineDao
{
  WineDao({
    required this.fixedAcidity,
    required this.volatileAcidity,
    required this.citricAcid,
    required this.residualSugar,
    required this.chlorides,
    required this.freeSulfurDioxide,
    required this.totalSulfurDioxide,
    required this.density,
    required this.ph,
    required this.sulphates,
    required this.alcohol,
  });

  List<double> fixedAcidity = [];
  List<double> volatileAcidity = [];
  List<double> citricAcid = [];
  List<double> residualSugar = [];
  List<double> chlorides = [];
  List<double> freeSulfurDioxide = [];
  List<double> totalSulfurDioxide = [];
  List<double> density = [];
  List<double> ph = [];
  List<double> sulphates = [];
  List<double> alcohol = [];

  
  Map<String, dynamic> toJson() => {
    "fixed_acidity": fixedAcidity,
    "volatile_acidity": volatileAcidity,
    "citric_acid": citricAcid,
    "residual_sugar": residualSugar,
    "chlorides": chlorides,
    "free_sulfur_dioxide":  freeSulfurDioxide,
    "total_sulfur_dioxide": totalSulfurDioxide,
    "density":density,
    "ph": ph,
    "sulphates": sulphates,
    "alcohol": alcohol
  };
}