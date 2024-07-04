let syncButton = document.getElementsByClassName('sync')[0];


let dirPath = document.getElementsByClassName("directory-name")[0];
function showPath(dir){
    dirPath.innerText = dir;
    dirPath.classList.remove("empty-dir");
    dirPath.classList.remove("text-red");
}

document.getElementsByClassName('browse-button')[0].onclick = function(){
    webkit.messageHandlers.controller.postMessage("browse");
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
           removeUrlByIndex(i);
        };
        
        let fileName = card.getElementsByClassName('file-name')[0];
        let requireFileName = document.getElementsByClassName('require-name')[0];

        let downloadIcon = card.getElementsByClassName('download-icon')[0];
        downloadIcon.onclick = function (){
            if(!dirPath.classList.contains("empty-dir")){
                if(fileName.value.length > 0){
                    requireFileName.classList.add("hidden");
                    downloadByIndex(i, fileName.value);
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
    webkit.messageHandlers.controller.postMessage("sync");
}

function removeUrlByIndex(index){
    webkit.messageHandlers.controller.postMessage("remove:" + index);
}

function downloadByIndex(index, name){
    webkit.messageHandlers.controller.postMessage("download:" + index + ":" + name);
}


syncButton.addEventListener("click", syncUrl);
