// import {elem} from "./js/navigation";
showPage("download-temp");

let downloadNav = document.getElementsByClassName("download-nav")[0];
let howItWorksNav = document.getElementsByClassName("how-it-works-nav")[0];

downloadNav.onclick = function() {
    showPage("download-temp");
    howItWorksNav.classList.remove("header-active");
    downloadNav.classList.add("header-active");
}

howItWorksNav.onclick = function() {
    showPage("how-it-works-temp");
    downloadNav.classList.remove("header-active");
    howItWorksNav.classList.add("header-active");
}

function showPage(temp)
{
    const template = document.getElementsByClassName(temp)[0];
    const content = document.getElementsByClassName("content")[0];

    while (content.firstChild) {
        content.removeChild(content.firstChild);
    }

    // Клонування та додавання нового контенту з шаблону
    const clone = document.importNode(template.content, true);
    content.appendChild(clone);
}

