browser.runtime.onMessage.addListener((request) => {
    if(request.select){
        let iframes = document.querySelectorAll('iframe');
        for(let i = 0; i < iframes.length; i++){
            if(iframes[i].src){
                let button = document.createElement('button');
                button.style.position = 'absolute';
                button.style.padding = '3px';
                button.style.borderRadius = '10%';
                button.style.background = 'white';
                button.style.cursor = 'pointer';
                button.style.visibility = 'hidden';
                button.innerHTML = 'Save';

                button.onclick = function(){
                    browser.runtime.sendMessage({ iframeSrc: iframes[i].src }).then((response) => {
                        console.log(response);
                    });
                }

                iframes[i].insertAdjacentElement('beforebegin', button);

                
                iframes[i].onmouseover = (event) => {
                    button.style.visibility = 'visible';
                };
            }
        }
    }
});
