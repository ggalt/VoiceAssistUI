// Returns a QRC URL for weather icons declared in Icons.qrc.
const ICON_NAMES = new Set([
    "air",
    "bedtime",
    "bedtime_off",
    "clear_day",
    "cloud",
    "cyclone",
    "dew_point",
    "electric_bolt",
    "flood",
    "foggy",
    "mist",
    "partly_cloudy_day",
    "partly_cloudy_night",
    "rainy",
    "rainy_heavy",
    "rainy_light",
    "severe_cold",
    "snowflake",
    "snowing",
    "snowing_heavy",
    "storm",
    "sunny",
    "sunny_snowing",
    "tornado",
    "tsunami",
    "weather_hail",
    "weather_mix",
    "weather_snowy"
]);

function findIcon(iconName) {
    if (typeof iconName !== "string") {
        return "qrc:/weather/images/weather_mix.svg";
    }

    const trimmedName = iconName.trim();
    if (ICON_NAMES.has(trimmedName)) {
        return "qrc:/weather/images/" + trimmedName + ".svg";
    }

    return "qrc:/weather/images/weather_mix.svg";
}
