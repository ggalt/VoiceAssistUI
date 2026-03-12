// Returns a QRC URL for weather icons declared in Icons.qrc.
const ICON_NAMES = new Set([
    "blizzard",
    "blowing_snow",
    "clear_alt",
    "clear_day",
    "cloudy",
    "dew_point",
    "drizzle",
    "droplet_clear",
    "droplet_drizzle",
    "droplet_heavy",
    "droplet_light",
    "droplet_moderate",
    "dust",
    "electric_bolt",
    "flood",
    "flurries",
    "fog",
    "heavy_rain",
    "heavy_snow",
    "humidity_percentage",
    "icy",
    "isolated_scattered_thunderstorms_day",
    "isolated_scattered_thunderstorms_night",
    "isolated_thunderstorms",
    "isolated_tstorms",
    "mist",
    "mixed_rain_hail_sleet",
    "mostly_clear_night",
    "mostly_cloudy_night_alt",
    "mostly_cloudy_night",
    "mostly_cloudy",
    "mostly_sunny",
    "partly_cloudy_night",
    "partly_cloudy",
    "scattered_showers",
    "scattered_snow",
    "showers",
    "sleet_hail",
    "smoke",
    "snow_showers",
    "strong_tstorms",
    "sunny",
    "tornado",
    "tropical_storm_hurricane",
    "tsunami",
    "very_cold",
    "very_hot",
    "visibility",
    "wind",
    "wintry_mix"
]);

function normalizeIconSize(iconSize) {
    if (typeof iconSize !== "string") {
        return "60";
    }

    const trimmedSize = iconSize.trim();
    var validSizes = ["30", "60", "100", "200", "400"];
    if (validSizes.indexOf(trimmedSize) !== -1) {
        return trimmedSize;
    }

    return "60";
}

function findIcon(iconName, iconSize) {
    const size = normalizeIconSize(iconSize);

    if (typeof iconName !== "string") {
        return "qrc:/weather/images/" + size + "/wintry_mix.png";
    }

    const trimmedName = iconName.trim();
    if (ICON_NAMES.has(trimmedName)) {
        return "qrc:/weather/images/" + size + "/" + trimmedName + ".png";
    }

    return "qrc:/weather/images/" + size + "/wintry_mix.png";
}



const WEATHER_STATE_TO_ICON = {
    "blizzard": "blizzard",
    "blowing_snow": "blowing_snow",
    "clear-night": "clear_alt",
    "sunny": "sunny",
    "cloudy": "cloudy",
    "dew_point": "dew_point",
    "drizzle": "drizzle",
    "humidity_dry": "droplet_clear",
    "droplet_drizzle": "droplet_drizzle",
    "humidity_heavy": "droplet_heavy",
    "humidity_light": "droplet_light",
    "humidity_moderate": "droplet_moderate",
    "dust": "dust",
    "electric_bolt": "electric_bolt",
    "flood": "flood",
    "flurries": "flurries",
    "fog": "fog",
    "pouring": "heavy_rain",
    "snowy": "heavy_snow",
    "humidity-percent": "humidity_percentage",
    "icy": "icy",
    "isolated_scattered_thunderstorms_day": "isolated_scattered_thunderstorms_day",
    "isolated_scattered_thunderstorms_night": "isolated_scattered_thunderstorms_night",
    "lightning-rainy": "isolated_thunderstorms",
    "isolated_tstorms": "isolated_tstorms",
    "mist": "mist",
    "mixed_rain_hail_sleet": "mixed_rain_hail_sleet",
    "mostly_clear_night": "mostly_clear_night",
    "mostly_cloudy_night_alt": "mostly_cloudy_night_alt",
    "mostly_cloudy_night": "mostly_cloudy_night",
    "mostly_cloudy": "mostly_cloudy",
    "mostly_sunny": "mostly_sunny",
    "partly_cloudy_night": "partly_cloudy_night",
    "partlycloudy": "partly_cloudy",
    "scattered_showers": "scattered_showers",
    "scattered_snow": "scattered_snow",
    "rainy": "showers",
    "hail": "sleet_hail",
    "smoke": "smoke",
    "snow_showers": "snow_showers",
    "lightning": "strong_tstorms",
    "exceptional": "tornado",
    "tropical_storm_hurricane": "tropical_storm_hurricane",
    "tsunami": "tsunami",
    "very_cold": "very_cold",
    "very_hot": "very_hot",
    "visibility": "visibility",
    "windy": "wind",
    "windy-variant": "wind",
    "snowy-rainy": "wintry_mix"
};

function weatherStateToIcon(state) {
    if (typeof state === "string" && WEATHER_STATE_TO_ICON.hasOwnProperty(state)) {
        return WEATHER_STATE_TO_ICON[state];
    }
    return "";
}

// --- OpenWeatherMap data access ---

var _weatherData = null;

// Load weather JSON from a local file path and store it.
// filePath should be an absolute path, e.g. "/home/user/data/openweathermap.json"
function loadWeatherData(filePath) {
    console.log("loadWeatherData: attempting to load " + filePath);
    var url = "file://" + filePath;
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, false);  // synchronous
    xhr.send();

    console.log("loadWeatherData: xhr.status=" + xhr.status +
                " responseText length=" + (xhr.responseText ? xhr.responseText.length : 0));

    if ((xhr.status === 200 || xhr.status === 0) && xhr.responseText) {
        var data = JSON.parse(xhr.responseText);
        setWeatherData(data);
        console.log("loadWeatherData: success, state=" + data.state +
                     ", attributes keys=" + Object.keys(data.attributes));
        return true;
    }

    console.error("loadWeatherData: failed to load " + filePath +
                   " (status " + xhr.status + ")");
    return false;
}

// Store the parsed weather JSON object directly.
function setWeatherData(data) {
    _weatherData = data;
}

// Look up a weather value by key.
// Top-level keys: "pulled_at_utc", "entity_id", "state", "last_changed", "last_updated"
// Attribute keys (accessed directly): "temperature", "apparent_temperature", "dew_point",
//   "temperature_unit", "humidity", "cloud_coverage", "pressure", "pressure_unit",
//   "wind_bearing", "wind_gust_speed", "wind_speed", "wind_speed_unit",
//   "visibility", "visibility_unit", "precipitation_unit",
//   "attribution", "friendly_name", "supported_features"
function getWeatherValue(key) {
    if (!_weatherData || typeof key !== "string") {
        console.log("getWeatherValue: _weatherData is " +
                     (_weatherData ? "loaded" : "null") + ", key=" + key);
        return undefined;
    }

    // Check top-level keys first
    if (_weatherData.hasOwnProperty(key)) {
        return _weatherData[key];
    }

    // Then check inside attributes
    if (_weatherData.attributes && _weatherData.attributes.hasOwnProperty(key)) {
        return _weatherData.attributes[key];
    }

    return undefined;
}

// --- Forecast data access ---

// Returns the full daily forecast array, or an empty array if data is missing.
function getDailyForecast() {
    if (!_weatherData || !_weatherData.forecast || !_weatherData.forecast.daily) {
        return [];
    }
    return _weatherData.forecast.daily;
}

// Returns the full hourly forecast array, or an empty array if data is missing.
function getHourlyForecast() {
    if (!_weatherData || !_weatherData.forecast || !_weatherData.forecast.hourly) {
        return [];
    }
    return _weatherData.forecast.hourly;
}

// Returns a single daily forecast entry by index (0-based), or null if out of range.
function getDailyForecastDay(index) {
    var daily = getDailyForecast();
    if (index < 0 || index >= daily.length) {
        return null;
    }
    return daily[index];
}

// Returns a single hourly forecast entry by index (0-based), or null if out of range.
function getHourlyForecastHour(index) {
    var hourly = getHourlyForecast();
    if (index < 0 || index >= hourly.length) {
        return null;
    }
    return hourly[index];
}

// Generic accessor: type is "daily" or "hourly", index is the array position,
// key is the property name (e.g. "temperature", "condition").
// Returns the value or undefined if anything is missing.
function getForecastValue(type, index, key) {
    var entry = null;
    if (type === "daily") {
        entry = getDailyForecastDay(index);
    } else if (type === "hourly") {
        entry = getHourlyForecastHour(index);
    }
    if (!entry || !entry.hasOwnProperty(key)) {
        return undefined;
    }
    return entry[key];
}

// Returns the number of daily forecast entries, or 0.
function getDailyForecastCount() {
    return getDailyForecast().length;
}

// Returns the number of hourly forecast entries, or 0.
function getHourlyForecastCount() {
    return getHourlyForecast().length;
}

function getTime(element, showColon) {
    var now = new Date();
    var hours = now.getHours();
    var minutes = now.getMinutes();
    var seconds = now.getSeconds();
    var period = hours < 12 ? "AM" : "PM";

    console.log("call is:", element, showColon)

    hours = hours % 12;
    if (hours === 0) {
        hours = 12;
    }

    var hh = (hours < 10 ? "0" : "") + hours;
    var mm = (minutes < 10 ? "0" : "") + minutes;
    var ss = (seconds < 10 ? "0" : "") + seconds;
    var colon = (showColon ? ":" : " ");

    if(element === "t0") {
        return hh+colon+mm;
    } else if(element === "t1") {
        return hh+colon+mm+" "+period;
    } else if(element === "h") {
        return hh;
    } else if(element === "m") {
        return mm;
    } else if(element === "s") {
        return ss;
    } else if(element === "p") {
        console.log("period = ", period)
        return period;
    } else {
        return "";
    }
}

var COMPASS_DIRECTIONS = [
    "N", "NNE", "NE", "ENE",
    "E", "ESE", "SE", "SSE",
    "S", "SSW", "SW", "WSW",
    "W", "WNW", "NW", "NNW"
];

function degreesToCompass(degrees) {
    if (typeof degrees !== "number" || degrees < 0 || degrees > 360) {
        return "";
    }
    var index = Math.round(degrees / 22.5) % 16;
    return COMPASS_DIRECTIONS[index];
}
