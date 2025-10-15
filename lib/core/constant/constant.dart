part of weather_app;

const _apiAccessKey = String.fromEnvironment('WEATHER_API_ACCESS_KEY');

const _baseApiPath = 'https://api.openweathermap.org/data/2.5';

const _weeklyWeatherBaseApiPath =
    'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

const _mapLayerBaseApiPath = 'https://tile.openweathermap.org/map';
