browser.runtime.onMessage.addListener((request) => {
    if(request.select){
        let videos = document.querySelectorAll('video');
        checkValidElements(videos);

        let iframes = specialUrlCheck() ?? document.querySelectorAll('iframe');
        checkValidElements(iframes, true);
    }
});

function specialUrlCheck()
{
    // temporary solution
    const urlOrigin = window.location.origin;
    const type = getSpecialTypeByUrl(urlOrigin);

    switch (type){
        case 'shadow':  // shadow root
            let shadowPlayer= document.querySelector('player-control').shadowRoot;
            return [shadowPlayer.querySelector('iframe')];
        case 'nesting': // double document nesting
            let iframe = document.querySelector('iframe').contentDocument;
            return [iframe.getElementsByTagName('iframe')[0]];
        default:
            return null;
    }
}