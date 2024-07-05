let select = document.getElementById('select');

select.onclick = function(event) {

    if(select.classList.contains('active')) return;
    
    browser.tabs.query({ currentWindow: true, active: true }).then((tabs) => {
        browser.tabs.sendMessage(tabs[0].id, {
            select: true,
        });
        select.classList.add('active');
    });
};
