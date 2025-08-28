# Weather Forecasting App

A Flutter application providing **real-time weather data** and a **5-day forecast**, along with interactive maps using Google Maps and OpenWeather API. The app features a clean, modern UI and robust architecture using **Bloc** for state management.

---

## Overview

This app allows users to:

* Get current weather information (temperature, humidity, conditions) based on **GPS location**.
* View a **5-day forecast** with intuitive and visually appealing UI.
* Explore weather data on a **Google Map** with temperature and precipitation overlays.
* Search for any city and get weather updates instantly.
* Experience smooth navigation and **robust error handling** for network, API, or input errors.

---

## Features & Navigation

### **Home Screen**

* Displays current temperature, weather condition, and a relevant icon (sunny, rainy, etc.).
* Shows a **5-day forecast** with clear UI.
* Automatically detects user location via GPS.
* Tap map icon/button to go to **Map Page**.
* Tap search icon to go to **Search Screen**.

### **Search Screen**

* Enter a city name to fetch weather data.
* Updates Home and Map pages automatically.
* Handles invalid input or city not found errors gracefully.
* Network or API errors display user-friendly messages.

### **Map Screen**

* Google Maps integration with weather overlays for temperature and precipitation.
* **Markers**:

  * Blue marker: Current or selected location.
  * Red marker: When tapped, shows temperature & humidity in an info window or bottom sheet.

### **Error Handling**

* Handles:

  * Network failures
  * API errors (invalid key, rate limits)
  * Location permission denial
  * Invalid city input
* Error messages are clear and actionable; retry options are provided.

---

## Architecture

* Follows **SOLID principles** and **clean architecture** for maintainability.
* **Bloc** is used for state management, separating business logic from UI.
* Project structure:

  * `lib/` – Core logic, features, and UI
  * `test/` – Unit and widget tests
* API keys managed securely via **`dart-define`**; not committed to repo.

---

## Assignment Satisfaction

* Real-time weather updates & 5-day forecast ✅
* GPS and manual city search ✅
* Google Maps with interactive weather overlays ✅
* Smooth navigation between Home, Search, and Map screens ✅
* Error handling and user-friendly messages ✅
* Clean architecture & Bloc state management ✅
* API key management using environment variables ✅

---

## Screenshots

### 🔐 Permission Check

![Location Permission Check](screen_shots/permission_check.png)

### 🏠 Home Screen

![Home Loading](screen_shots/home_loading.png)
![Home Screen 1](screen_shots/home_1.png)
![Home Screen 2](screen_shots/home_2.png)

### 🗺️ Map Screen

![Map Screen 1](screen_shots/map_1.png)
![Map Screen 2](screen_shots/map_2.png)
![Marker Info Window](screen_shots/marker_window.png)

### 🔍 Search Screen

![Search Screen 1](screen_shots/search_1.png)
![Search Suggestion Tap](screen_shots/suggestion_tap_search.png)
![Manual Search Input](screen_shots/manual_type_search.png)

---

## 🎥 Demo Video

▶️ [Watch Demo Video](#) <!-- Replace `#` with your Google Drive or video link -->

---

## Setup Instructions

1. **Clone the repository**

```bash
[git clone https://github.com/yourusername/weatherapp.git](https://github.com/ShashwatSamadhiya/weather_app.git)
cd weather_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure API Keys**

* Add your **Google Maps API key** in `AndroidManifest.xml` or pass by `--dart-define`.
* Pass your **Weather API key** using `--dart-define`:


```bash
flutter run --dart-define=WEATHER_API_ACCESS_KEY=your_api_key --dart-define=GOOGLE_MAPS_KEY=your_google_map_key
```

4. **Run the app**

```bash
flutter run --dart-define=WEATHER_API_ACCESS_KEY=your_api_key --dart-define=GOOGLE_MAPS_KEY=your_google_map_key
```

5. **Build APK**

```bash
flutter build apk --dart-define=WEATHER_API_ACCESS_KEY=your_api_key --dart-define=GOOGLE_MAPS_KEY=your_google_map_key
```

6. **Run Tests**

```bash
flutter test
```

---

## Architectural Decisions

* **State Management:** Bloc separates business logic from UI for maintainable and testable code.
* **Clean Architecture:** Divided into **Domain, Data, and Presentation layers**.
* **Error Handling:** All API, network, and location errors provide clear feedback to users.
* **API Key Management:** Securely injected via environment variables; no hardcoding.

---

## Tests

* Run all tests with `flutter test`.
* Critical logic and widgets covered to ensure reliability.
