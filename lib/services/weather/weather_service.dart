import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String baseURL = dotenv.env['WEATHER_API_BASE_URL'] ?? '';
  final String apiKEY = dotenv.env['WEATHER_API_KEY'] ?? '';
  final TextEditingController cityController = TextEditingController();
  bool isLoading = false;
  WeatherModel? weather;

  WeatherService();

  // Fetch weather data by city name
  Future<void> fetchWeather({String? city}) async {
    isLoading = true;

    try {
      String targetCity = city ?? await getCurrentCity();
      if (targetCity.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter a city name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return;
      }

      final url = '$baseURL?q=$targetCity&appid=$apiKEY&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        weather = WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching the weather!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading = false;
    }
  }

  // Get the current city using geolocation
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    return city ?? "";
  }

  // Map weather condition to icon asset
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

  // Clear the search field
  void resetSearch() {
    cityController.clear();
  }

  // Dispose resources
  void dispose() {
    cityController.dispose();
  }
}
