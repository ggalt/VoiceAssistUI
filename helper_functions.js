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
    "heat",
    "mist",
    "moon_stars",
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
    "water",
    "weather_hail",
    "weather_mix",
    "weather_snowy"
]);

function normalizeIconSize(iconSize) {
    if (typeof iconSize !== "string") {
        return "small";
    }

    const trimmedSize = iconSize.trim().toLowerCase();
    if (trimmedSize === "small" || trimmedSize === "large") {
        return trimmedSize;
    }

    return "small";
}

function findIcon(iconName, iconSize) {
    const size = normalizeIconSize(iconSize);

    if (typeof iconName !== "string") {
        return "qrc:/weather/images/" + size + "/weather_mix.svg";
    }

    const trimmedName = iconName.trim();
    if (ICON_NAMES.has(trimmedName)) {
        return "qrc:/weather/images/" + size + "/" + trimmedName + ".svg";
    }

    return "qrc:/weather/images/" + size + "/weather_mix.svg";
}
