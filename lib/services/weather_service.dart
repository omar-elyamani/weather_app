import "dart:convert";
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String API_KEY;

  WeatherService(this.API_KEY);

  //Fettching the weather method (GET)
  Future<WeatherModel> getWeather(String city) async {
    final url = '$BASE_URL?q=$city&appid=$API_KEY&units=metric'; //preparing the URL 
    final response = await http.get(Uri.parse(url));             //fetching from the URL

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //Fettching the current location with permission (GET)
  Future<String>  getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission(); //checking the permission
    
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); //getting the current position

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude); //getting the current city

    String? city = placemarks[0].locality; //getting the city from the placemark

    return city ?? ""; //returning the city or an empty string if it's null
  }
}