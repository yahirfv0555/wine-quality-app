import 'package:pia_cien3_vino_app/models/wine.dart';
import '../config/enviroment.dart';
import 'package:http/http.dart' as http;

class PredictService{
  
  final Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type":"application/json"
  };

  Future<WineDto?> predictQuality(WineDao wineDao)async{
    final Uri uri = Uri.parse('http://127.0.0.1:5000/api/v1/predict');
    try{
      final body = wineToJson(wineDao);
      print(body);
      var response = await http.post(
        uri,
        body: body,
        headers: headers
      );

      if(response.statusCode == 200){
        var wineJson = response.body;
        final wine = wineFromJson(wineJson)[0];
        return wine; 
      }
      else{
        return null;
      }
    }
    catch(e){
      print(e);
      return null;
    }
  }

}