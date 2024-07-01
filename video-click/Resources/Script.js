let syncButton = document.getElementsByClassName('sync')[0];

//function show(enabled, useSettingsInsteadOfPreferences) {
//    if (useSettingsInsteadOfPreferences) {
//        document.getElementsByClassName('state-on')[0].innerText = "video-click’s extension is currently on. You can turn it off in the Extensions section of Safari Settings.";
//        document.getElementsByClassName('state-off')[0].innerText = "video-click’s extension is currently off. You can turn it on in the Extensions section of Safari Settings.";
//        document.getElementsByClassName('state-unknown')[0].innerText = "You can turn on video-click’s extension in the Extensions section of Safari Settings.";
//        syncButton.innerText = "Sync";
//    }
//}
let allUrls = [];

function receiveUrls(urls) {
    let cards = document.getElementsByClassName('cards')[0];
    
    for(let i = 0; i < urls.length; i++){
        let url = urls[i];
        if(allUrls.includes(url)){
            continue;
        }
        let card = document.getElementsByClassName('card')[0].cloneNode(true);
        card.getElementsByClassName('file-url')[0].innerText = url;
        card.classList.remove('hidden');
        card.classList.remove('prototype');
        card.classList.add('flex');
        let crossIcon = card.getElementsByClassName('cross-icon')[0];
        crossIcon.onclick = function (){
            card.classList.remove('flex');
            card.classList.add('hidden');
           removeUrl(i);
        };
        cards.append(card);
    }
    allUrls = urls;
}

function syncUrl() {
    webkit.messageHandlers.controller.postMessage("sync");
}

function removeUrl(index){
    webkit.messageHandlers.controller.postMessage("remove:" + index);
}


syncButton.addEventListener("click", syncUrl);
