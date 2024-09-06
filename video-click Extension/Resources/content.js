browser.runtime.onMessage.addListener((request) => {
    if(request.select){
        let videos = document.querySelectorAll('video');
        checkValidElements(videos);

        let iframes = specialUrlCheck() ?? document.querySelectorAll('iframe');
        checkValidElements(iframes, true);
    }
});

function checkValidElements(elements, itsIframes = false)
{
    if(elements && elements.length > 0){
        elements.forEach(element => {
            if(element.hasAttribute('src') && containFormats(element.src, itsIframes)){
                let button = document.createElement('div');
                button.style.position = 'absolute';
                button.style.padding = '3px 6px';
                button.style.border = '1px solid black'
                button.style.borderRadius = '10%';
                button.style.background = 'white';
                button.style.cursor = 'pointer';
                button.style.visibility = 'hidden';
                button.style.zIndex = '999';
                button.style.color = 'black';
                button.classList.add('video-click-save-button');
                button.innerHTML = 'Save';

                button.onclick = function(){
                    if(button.innerHTML === 'Saved' || button.innerHTML === 'Error') return;

                    let requestData = itsIframes ? { iframeSrc: element.src} : { src: element.src};
                        browser.runtime.sendMessage(requestData).then((response) => {
                        if(response === "saved"){
                            button.innerHTML = 'Saved';
                            button.style.color = "rgb(66, 172, 0)";
                        }
                        if(response === "error"){
                            button.innerHTML = 'Error';
                            button.style.color = "red";
                        }
                    });
                }

                element.insertAdjacentElement('beforebegin', button);
                element.onmouseover = (event) => {
                    button.style.visibility = 'visible';
                };
            }
        })
    }
}

function containFormats(src, itsIframes = false){
    if(itsIframes) return true;

    const formats = ['.mp4', '.webm', '.mov', '.mkv', '.m3u8'];
    for(let format in formats){
        if(src.includes(format)) return true;
    }

    return false;
}

function specialUrlCheck()
{
    // temporary solution
    const urlOrigin = window.location.origin;
    switch (urlOrigin){
        case 'https://uaserials.pro':  // shadow root
            let shadowPlayer= document.querySelector('player-control').shadowRoot;
            return [shadowPlayer.querySelector('iframe')];
        case 'https://uaserial.com': // double document nesting
        case 'https://uaserial.tv':
            let iframe = document.querySelector('iframe').contentDocument;
            return [iframe.getElementsByTagName('iframe')[0]];
        default:
            return null;
    }
}


