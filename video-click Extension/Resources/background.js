browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {

    if('iframeSrc' in request) {
        let response = await fetch(request.iframeSrc);

        let html = await response.text();
        let fileSrc = getFileSrcFromHtml(html);

        browser.runtime.sendNativeMessage("application.id", fileSrc, function(response) {
            console.log(response);
        });
    }
    
//    let port = browser.runtime.connectNative("application.id");
//    
//    port.onMessage.addListener(function(message) {
//        sendResponse({response: message});
//    });
});

//let port = browser.runtime.connectNative("com.pk.video-click.Extension");
//console.log(port);

function getFileSrcFromHtml(html, playerKeyword = "new Playerjs", fileKeyword = "file:") {
    let firstIndex = html.indexOf(playerKeyword);
    let secondIndex = html.indexOf('})', firstIndex);
    let playerObject = (html.slice(firstIndex, secondIndex)).slice(playerKeyword.length) + '})';

    let firstFileIndex = playerObject.indexOf(fileKeyword) + fileKeyword.length;
    let secondFileIndex = playerObject.indexOf(",", firstFileIndex)
    let fileSrc = playerObject.slice(firstFileIndex, secondFileIndex);
    return fileSrc.slice(0, fileSrc.length);
}
