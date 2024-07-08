let syncButton = document.getElementsByClassName('sync')[0];

let urlsWithCard = [];

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

function startDownload(card, fileName){
    let div = document.createElement("div");
    div.classList.add("arc");
    div.classList.add("animate");
    card.classList.add("bg-gray");

    let downloadContainer = card.getElementsByClassName("download-container")[0];
    downloadContainer.append(div);

    let fileTitle = card.getElementsByClassName("file-title")[0];
    fileTitle.innerHTML = fileName;
    fileTitle.classList.remove("hidden");

    card.getElementsByClassName("file-size")[0].classList.remove('hidden');
}

function stopDownload(url){
    let card = urlsWithCard[url];
    card.getElementsByClassName('animate')[0].classList.add('hidden');
    card.getElementsByClassName("file-size")[0].innerText = 'Done';
}

function updateSize(size, url)
{
    let fileSize = urlsWithCard[url].getElementsByClassName("file-size")[0];
    fileSize.classList.remove("hidden");
    fileSize.innerHTML = size;
}

document.getElementsByClassName('browse-button')[0].onclick = function(){
    requestObj.action = "browse";
    webkit.messageHandlers.controller.postMessage(JSON.stringify(requestObj));
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
                    downloadIcon.classList.add('hidden');
                    fileName.classList.add('hidden');
                    crossIcon.classList.add('hidden');
                    card.getElementsByClassName('file-url')[0].classList.add('hidden');
                    startDownload(card, fileName.value);
                } else {
                    requireFileName.innerText = "File name is require";
                    requireFileName.classList.remove("hidden");
                }
            } else {
                dirPath.classList.add("text-red");
            }
        };
        
        cards.append(card);
        urlsWithCard[url] = card;
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
