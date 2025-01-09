import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/my_message.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_loader.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback toggleTheme; // Function to toggle theme
  final bool isDarkMode; // Indicates if dark mode is active

  const WeatherPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  late WeatherService _weatherService;
  
  WeatherModel? _weather;

  bool _isLoading = false;

  final cityController = TextEditingController();

  final List<String> _citySuggestions = citySuggestions;

  // Fetch weather function from the API
  _fetchWeather({String? city}) async {
    
    setState(() {_isLoading = true;});

    String targetCity = city ?? await _weatherService.getCurrentCity();

    if (targetCity.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a city name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final weather = await _weatherService.getWeather(targetCity);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching the weather!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resetSearch() {
    cityController.clear();
    _fetchWeather();
  }

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

  void logUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    final String weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? ''; // Access API key here
    _weatherService = WeatherService(weatherApiKey); // Initialize the service here
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Weather App", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: widget.toggleTheme,
            tooltip: "Toggle Theme",
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: logUserOut,
            tooltip: "Log Out",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchWeather(
              city: cityController.text.trim().isEmpty
                  ? null
                  : cityController.text.trim());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return _citySuggestions.where((String city) =>
                                  city.toLowerCase().startsWith(
                                      textEditingValue.text.toLowerCase()));
                            },
                            displayStringForOption: (String option) => option,
                            fieldViewBuilder: (context, autocompleteController,
                                focusNode, onFieldSubmitted) {
                              cityController.addListener(() {
                                if (cityController.text !=
                                    autocompleteController.text) {
                                  autocompleteController.text =
                                      cityController.text;
                                }
                              });
                              autocompleteController.addListener(() {
                                if (autocompleteController.text !=
                                    cityController.text) {
                                  cityController.text =
                                      autocompleteController.text;
                                }
                              });
                              return TextField(
                                controller: autocompleteController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter a city name',
                                ),
                              );
                            },
                            onSelected: (String selection) {
                              cityController.text = selection;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        MyButton(
                          width: 120,
                          text: "Search",
                          icon: const Icon(Icons.search,
                              color: Colors.white, size: 24),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            final city = cityController.text.trim();
                            if (city.isNotEmpty) {
                              _fetchWeather(city: city);
                            } else {
                              const MyMessage(
                                message: "Please enter a city name",
                                backgroundColor: Colors.orange,
                                textColor: Colors.white,
                              ).show();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyLoader(
                    isLoading: _isLoading,
                    child: Column(
                      children: [
                        Text(
                          _weather?.cityName ?? "Loading your city...",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              _weather != null
                                  ? "${_weather?.temperature}°C"
                                  : "",
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(
                              _weather != null ? "${_weather?.humidity}%" : "",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _weather?.mainCondition != null
                            ? Lottie.asset(
                                getWeatherConditionIcon(
                                    _weather?.mainCondition))
                            : Container(),
                        const SizedBox(height: 8),
                        Text(
                          _weather?.mainCondition ?? "",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
