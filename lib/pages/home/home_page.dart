// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';
import 'package:pia_cien3_vino_app/models/wine.dart';
import 'package:pia_cien3_vino_app/services/predict_service.dart';
import 'package:fl_chart/fl_chart.dart';


class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WineDto? wineDto;
  WineDao? wineDao;
  PredictService predictService = PredictService();
  late List<double> qualities;

  TextEditingController fixedAcidityController = TextEditingController();
  TextEditingController volatileAcidityController = TextEditingController();
  TextEditingController citricAcidController = TextEditingController();
  TextEditingController residualSugarController = TextEditingController();
  TextEditingController chloridesController = TextEditingController();
  TextEditingController freeSulfurDioxideController = TextEditingController();
  TextEditingController totalSulfurDioxideController = TextEditingController();
  TextEditingController densityController = TextEditingController();
  TextEditingController phController = TextEditingController();
  TextEditingController sulphatesController = TextEditingController();
  TextEditingController alcoholController = TextEditingController();

  @override
  void initState(){
    super.initState();
    clearQualities();
    wineDto = WineDto(quality: null);
  }

  clearQualities(){
    setState(() {
      qualities = [];
      if(wineDto != null)wineDto!.quality = null;
    }); 
  }

  parseWineProperties(){
    wineDao = WineDao(
      fixedAcidity: [double.parse(fixedAcidityController.text)], 
      volatileAcidity:[double.parse(volatileAcidityController.text ?? '0')], 
      citricAcid: [double.parse( citricAcidController.text ?? '0')], 
      residualSugar: [double.parse(residualSugarController.text ?? '0')], 
      chlorides:[ double.parse(chloridesController.text ?? '0')], 
      freeSulfurDioxide: [double.parse( freeSulfurDioxideController.text ?? '0')], 
      totalSulfurDioxide: [double.parse(totalSulfurDioxideController.text ?? '0')], 
      density: [double.parse(densityController.text ?? '0')], 
      ph: [double.parse(phController.text ?? '0')], 
      sulphates: [double.parse( sulphatesController.text ?? '0')], 
      alcohol: [double.parse(alcoholController.text ?? '0')]
    );
  }

  Future<void> predict ()async{
    parseWineProperties();
  
    wineDto = await predictService.predictQuality(wineDao!);
    setState(() {
      qualities.add(wineDto!.quality!);
    });  
  }

  void showChartDialog(){
    List<BarChartGroupData> dataChart = [];
    for(int i=0;i<qualities.length;i++){
      dataChart.add(
         BarChartGroupData(
          x: i+1,
          barRods: [BarChartRodData(toY: qualities[i])],
        )
      );
    }
    showDialog(
      context: context, 
      builder: (BuildContext context){
         return Dialog(
          child: ChartPredictions(qualities: dataChart)
        );
      }
    );
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Color.fromARGB(15, 141, 77, 196),
        ),
        padding: const EdgeInsets.only(
          top: 30,
          left: 30,
          right: 30
        ),
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Predecir calidad del vino',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeTextField(controller: fixedAcidityController,label: 'Acidez fija',),
                        HomeTextField(controller: volatileAcidityController,label: 'Acidez volatil',),
                        HomeTextField(controller: citricAcidController,label: "Acidez citrica",),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeTextField(controller: residualSugarController, label: 'Azucar residual',),
                        HomeTextField(controller: chloridesController,label: 'Cloruros'),
                        HomeTextField(controller: freeSulfurDioxideController,label: 'Dióxido de azufre libre'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeTextField(controller: phController,label: 'pH'),
                        HomeTextField(controller: totalSulfurDioxideController,label: 'Dióxido de azufre total'),
                        HomeTextField(controller: densityController,label: 'Densidad'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeTextField(
                          controller: alcoholController,
                          label: 'Alcohol',
                        ),
                        HomeTextField(
                          controller: sulphatesController,
                          label: 'Sulfatos',
                        ),
                        Container(
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          child: TextField(
                            enabled: false,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: wineDto!.quality!=null ? wineDto!.quality.toString() : null),
                            style: const TextStyle(
                              color:Colors.black 
                            ),
                            decoration: InputDecoration(
                              labelText:'Calidad',
                              labelStyle: TextStyle(
                              color: wineDto!.quality!=null ? Colors.purple : Colors.black
                            ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: wineDto!.quality!=null ? Colors.purple : Colors.black
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(93, 141, 77, 196),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
              ),
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
                right: 200,
                left: 200
              ),
              margin: const EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    label: 'Predecir',
                    predict: predict,
                    color: Colors.purple,
                  ),
                  HomeButton(
                    label: 'Borrar datos',
                    predict: clearQualities,
                    color: Colors.red,
                  ),
                  ChartButton(
                    showChart: showChartDialog,
                    enable: qualities.isNotEmpty,
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class HomeTextField extends StatelessWidget{
  final TextEditingController controller;
  final String label;
  final double? width;

  const HomeTextField({super.key, required this.controller, required this.label, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 150,
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }  
}

class HomeButton extends StatefulWidget{
  const HomeButton({
    Key? key, 
    required this.predict, required this.label, required this.color
  }): super(key:key);

  final dynamic predict;
  final String label;
  final Color color;

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {

  late PredictService predictService = PredictService();


  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical:5),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          backgroundColor: widget.color,
        ),
        onPressed: widget.predict, 
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        )
      ),
    );
  }
}

class ChartButton extends StatelessWidget{
  final dynamic showChart;
  final bool enable;

  const ChartButton({super.key, this.showChart, required this.enable});
 @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical:5),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.black,
        ),
        onPressed:enable ?  showChart : null, 
        child: const Text(
          'Generar gráfico',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        )
      ),
    );
  }
}


class ChartPredictions extends StatelessWidget{
  const ChartPredictions({super.key, required this.qualities});
  final List<BarChartGroupData> qualities;

  @override
  Widget build(BuildContext context) {
   return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: Color.fromARGB(15, 141, 77, 196),
    ),
    padding: const EdgeInsets.all(30.0),
    margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: const FlTitlesData(
          show: true,
          leftTitles: AxisTitles(),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: qualities
      ),
    )
   );
  }
}