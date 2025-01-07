class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity;

  WeatherModel({
    required this.cityName,
    required this.humidity,
    required this.temperature,
    required this.mainCondition,
  });

  //Factory constructor for converting json to model object
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      humidity: json['main']['humidity'] as int,
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
