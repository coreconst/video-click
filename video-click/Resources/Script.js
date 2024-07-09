let haveAllTools = true;

showPage("how-it-works-temp");

let downloadNav = document.getElementsByClassName("download-nav")[0];
let howItWorksNav = document.getElementsByClassName("how-it-works-nav")[0];

downloadNav.onclick = function() {
    if(haveAllTools) {
        showPage("download-temp");
        howItWorksNav.classList.remove("header-active");
        downloadNav.classList.add("header-active");
    }
}

howItWorksNav.onclick = function() {
    showPage("how-it-works-temp");
    downloadNav.classList.remove("header-active");
    howItWorksNav.classList.add("header-active");
}

function showPage(temp)
{
    if(haveAllTools){
        const showPage = document.getElementsByClassName(temp)[0];
        const hiddePage = document.getElementsByClassName(temp === "download-temp" ? "how-it-works-temp" : "download-temp")[0];
        hiddePage.classList.add("hidden");
        showPage.classList.remove("hidden");
    }
}

function suggestInstallTools(brew, ffmpeg)
{
    haveAllTools = false;
    let alert = document.getElementsByClassName("alert")[0];
    alert.classList.remove("hidden");
}


