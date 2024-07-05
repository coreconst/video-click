let syncButton = document.getElementsByClassName('sync')[0];

let requestObj = {
    action: "",
    url: "",
    name: ""
}

let dirPath = document.getElementsByClassName("directory-name")[0];
function showPath(dir){
    dirPath.innerText = dir;
    dirPath.classList.remove("empty-dir");
    dirPath.classList.remove("text-red");
}

document.getElementsByClassName('browse-button')[0].onclick = function(){
    requestObj.action = "browse";
    webkit.messageHandlers.controller.postMessage(requestObj);
}

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
        card.classList.add('flex');
        
        let crossIcon = card.getElementsByClassName('cross-icon')[0];
        crossIcon.onclick = function (){
            card.classList.remove('flex');
            card.classList.add('hidden');
           removeUrl(url);
        };
        
        let fileName = card.getElementsByClassName('file-name')[0];
        let requireFileName = document.getElementsByClassName('require-name')[0];

        let downloadIcon = card.getElementsByClassName('download-icon')[0];
        downloadIcon.onclick = function (){
            if(!dirPath.classList.contains("empty-dir")){
                if(fileName.value.length > 0){
                    requireFileName.classList.add("hidden");
                    download(url, fileName.value);
                } else {
                    requireFileName.innerText = "File name is require";
                    requireFileName.classList.remove("hidden");
                }
            } else {
                dirPath.classList.add("text-red");
            }
        };
        
        cards.append(card);
    }
    allUrls = urls;
}

function syncUrl() {
    requestObj.action = "sync";
    webkit.messageHandlers.controller.postMessage(JSON.stringify(requestObj));
}

function removeUrl(url){
    requestObj.action = "remove";
    requestObj.url = url;
    webkit.messageHandlers.controller.postMessage(JSON.stringify(requestObj));
}

function download(url, name){
    requestObj = {action: "download", url: url, name: name};
    webkit.messageHandlers.controller.postMessage(JSON.stringify(requestObj));
}


syncButton.addEventListener("click", syncUrl);
