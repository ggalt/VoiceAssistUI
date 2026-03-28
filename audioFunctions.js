.pragma library

// --- Configuration ---
var serverUrl = "http://192.168.1.10:9000/jsonrpc.js"
// var playerId = _readMacAddress()
var playerId = "e4:5f:01:fa:ff:aa"

function _readMacAddress() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "file:///sys/class/net/wlan0/address", false);
    xhr.send();
    if ((xhr.status === 200 || xhr.status === 0) && xhr.responseText) {
        var mac = xhr.responseText.trim();
        console.log("audioFunctions: detected player MAC: " + mac);
        return mac;
    }
    console.error("audioFunctions: failed to read MAC, using fallback");
    return "00:00:00:00:00:00";
}

// --- Internal helper ---

function _sendRequest(playerCmd, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", serverUrl, true);
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    var response = JSON.parse(xhr.responseText);
                    if (callback) {
                        callback(response.result);
                    }
                } catch (e) {
                    console.error("audioFunctions: JSON parse error: " + e);
                }
            } else {
                console.error("audioFunctions: HTTP error " + xhr.status);
            }
        }
    };

    var body = JSON.stringify({
        id: 1,
        method: "slim.request",
        params: [playerId, playerCmd]
    });

    xhr.send(body);
}

// --- Playback control (fire-and-forget) ---

function pause() {
    _sendRequest(["pause", "1"]);
}

function play() {
    _sendRequest(["pause", "0"]);
}

function skipNext() {
    _sendRequest(["playlist", "index", "+1"]);
}

function skipPrevious() {
    _sendRequest(["playlist", "index", "-1"]);
}

// --- Getters/setters ---

function getShuffle(callback) {
    _sendRequest(["playlist", "shuffle", "?"], function (result) {
        if (callback) callback(result._shuffle);
    });
}

function setShuffle(value) {
    _sendRequest(["playlist", "shuffle", "" + value]);
}

function getRepeat(callback) {
    _sendRequest(["playlist", "repeat", "?"], function (result) {
        if (callback) callback(result._repeat);
    });
}

function setRepeat(value) {
    _sendRequest(["playlist", "repeat", "" + value]);
}

function getVolume(callback) {
    _sendRequest(["mixer", "volume", "?"], function (result) {
        if (callback) callback(result._volume);
    });
}

function setVolume(value) {
    _sendRequest(["mixer", "volume", "" + value]);
}

// --- Status compound query ---

function getStatus(callback) {
    _sendRequest(["status", "-", "1", "tags:aldKJ"], callback);
}

// --- Cover art URL ---

function getCoverArtUrl(trackInfo) {
    if (!trackInfo) return "";

    if (trackInfo.artwork_url && trackInfo.artwork_url.indexOf("http") === 0) {
        return trackInfo.artwork_url;
    }

    if (trackInfo.artwork_track_id !== undefined) {
        var baseUrl = serverUrl.replace("/jsonrpc.js", "");
        return baseUrl + "/music/" + trackInfo.artwork_track_id + "/cover.jpg";
    }

    if (trackInfo.artwork_url) {
        var base = serverUrl.replace("/jsonrpc.js", "");
        return base + "/" + trackInfo.artwork_url;
    }

    return "";
}

// --- Polling wrapper ---

function pollStatus(callback) {
    getStatus(function (result) {
        if (!result) return;

        var track = {};
        if (result.playlist_loop && result.playlist_loop.length > 0) {
            track = result.playlist_loop[0];
        }

        var status = {
            mode: result.mode || "stop",
            volume: (result["mixer volume"] !== undefined) ? result["mixer volume"] : 0,
            shuffle: result.playlist_shuffle || 0,
            repeat: result.playlist_repeat || 0,
            elapsed: result.time || 0,
            duration: result.duration || 0,
            title: track.title || "",
            artist: track.artist || "",
            album: track.album || "",
            coverArtUrl: getCoverArtUrl(track)
        };

        if (callback) callback(status);
    });
}

// --- Utility ---

function formatTime(seconds) {
    if (isNaN(seconds) || seconds < 0) return "00:00";
    var totalSeconds = Math.floor(seconds);
    var m = Math.floor(totalSeconds / 60);
    var s = totalSeconds % 60;
    var mm = (m < 10 ? "0" : "") + m;
    var ss = (s < 10 ? "0" : "") + s;
    return mm + ":" + ss;
}
