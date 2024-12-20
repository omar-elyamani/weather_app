import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Creating a weather service instance
  final _weatherService = WeatherService('82e05f089d6ebf7888e999452491f6c5');
  
  // Creating a weather model object
  WeatherModel? _weather;

  // Implementing the function to fetch the weather
  _fetchWeather() async {
    String city = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching weather: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Implementing the function to fetch the weather of a specific city
  _fetchCityWeather(String city) async {
    if(city.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a city name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching weather: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Implementing the function to get the weather condition icon
  String getWeatherConditionIcon(String? condition) {
    if (condition == null) return 'assets/sunny.json';

    switch (condition.toLowerCase()) { 
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }


  // Initializing the state at the beginning of the app
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView( // Add this to allow scrolling
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Row for TextField and Search Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a city name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Text('Search'),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          final city = cityController.text.trim();
                          if (city.isNotEmpty) {
                            _fetchCityWeather(city);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Weather condition
                Text(
                  _weather?.cityName ?? "Loading your city...",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _weather != null ? "${_weather?.temperature}°C" : "",
                  style: const TextStyle(fontSize: 24),
                ),

                // Weather icon
                _weather?.mainCondition != null
                    ? Lottie.asset(getWeatherConditionIcon(_weather?.mainCondition))
                    : Container(),

                // General weather condition
                Text(
                  _weather?.mainCondition ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}