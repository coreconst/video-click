browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {

    if('iframeSrc' in request) {
        let response = await fetch(request.iframeSrc);

        let html = await response.text();
        let fileSrc = getFileSrcFromHtml(html);

        if(!fileSrc) sendResponse('error')

        await sendNative(fileSrc, sendResponse);
    }

   if('src' in request) {
       await sendNative(request.src, sendResponse);
   }
});

async function sendNative(src, sendResponse){
    let status = await browser.runtime.sendNativeMessage("application.id", src);
    await sendResponse(status['status']);
}


function getFileSrcFromHtml(html, playerKeyword = "new Playerjs", fileKeyword = "file:") {
    if(!html.includes(playerKeyword)) return false;

    let firstIndex = html.indexOf(playerKeyword);
    let secondIndex = html.indexOf('})', firstIndex);
    let playerObject = (html.slice(firstIndex, secondIndex)).slice(playerKeyword.length) + '})';

    let firstFileIndex = playerObject.indexOf(fileKeyword) + fileKeyword.length;
    let secondFileIndex = playerObject.indexOf(",", firstFileIndex);
    let srcStr =  playerObject.substring(firstFileIndex, secondFileIndex);

    for(let str of srcStr.split('"')){
        if(str.length > 4) return str;
    }
    return false;
}
