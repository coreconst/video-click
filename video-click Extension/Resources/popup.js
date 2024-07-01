let select = document.getElementById('select');

select.onclick = function(event) {

    browser.tabs.query({ currentWindow: true, active: true }).then((tabs) => {
        browser.tabs.sendMessage(tabs[0].id, {
            select: true,
        });
    });
};
