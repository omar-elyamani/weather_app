class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  //Factory constructor for converting json to model object
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
