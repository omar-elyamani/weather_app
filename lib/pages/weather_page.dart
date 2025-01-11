import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_loader.dart';
import 'package:weather_app/services/authentication/login_service.dart';
import 'package:weather_app/services/weather/weather_service.dart';
import 'package:weather_app/services/city/city_service.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const WeatherPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherService weatherService;
  late final LoginService loginService;

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService();
    loginService = LoginService();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      weatherService.isLoading = true;
    });

    await weatherService.fetchWeather();

    setState(() {
      weatherService.isLoading = false;
    });
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
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Log Out",
            onPressed: () async {
              await loginService.logUserOut(context);
              weatherService.dispose();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          String currentCity = await weatherService.getCurrentCity();
          await weatherService.fetchWeather(city: currentCity);
          setState(() {});
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
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return citySuggestions.where((String city) =>
                                  city.toLowerCase().startsWith(
                                      textEditingValue.text.toLowerCase()));
                            },
                            onSelected: (String selection) {
                              weatherService.cityController.text = selection;
                            },
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              // Sync the Autocomplete text controller with cityController
                              weatherService.cityController.addListener(() {
                                if (weatherService.cityController.text !=
                                    textEditingController.text) {
                                  textEditingController.text =
                                      weatherService.cityController.text;
                                }
                              });
                              textEditingController.addListener(() {
                                if (textEditingController.text !=
                                    weatherService.cityController.text) {
                                  weatherService.cityController.text =
                                      textEditingController.text;
                                }
                              });

                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter a city name',
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        MyButton(
                          width: 120,
                          text: "Search",
                          icon: const Icon(Icons.search, color: Colors.white),
                          onTap: () async {
                            await weatherService.fetchWeather(
                              city:
                                  weatherService.cityController.text.trim(),
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyLoader(
                    isLoading: weatherService.isLoading,
                    child: Column(
                      children: [
                        Text(
                          weatherService.weather?.cityName ??
                              "Loading your city...",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          weatherService.weather != null
                              ? "${weatherService.weather?.temperature}°C"
                              : "",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Lottie.asset(weatherService.getWeatherConditionIcon(
                            weatherService.weather?.mainCondition)),
                        const SizedBox(height: 8),
                        Text(
                          weatherService.weather?.mainCondition ?? "",
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
