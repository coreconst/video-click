let syncButton = document.getElementsByClassName('sync')[0];

function show(enabled, useSettingsInsteadOfPreferences) {
    if (useSettingsInsteadOfPreferences) {
        document.getElementsByClassName('state-on')[0].innerText = "video-click’s extension is currently on. You can turn it off in the Extensions section of Safari Settings.";
        document.getElementsByClassName('state-off')[0].innerText = "video-click’s extension is currently off. You can turn it on in the Extensions section of Safari Settings.";
        document.getElementsByClassName('state-unknown')[0].innerText = "You can turn on video-click’s extension in the Extensions section of Safari Settings.";
        syncButton.innerText = "Sync";
    }
}

function receiveUrls(urls) {
    document.getElementsByClassName('state-check')[0].innerText = urls[0]
}

function syncUrl() {
    webkit.messageHandlers.controller.postMessage("sync");
}

syncButton.addEventListener("click", syncUrl);
