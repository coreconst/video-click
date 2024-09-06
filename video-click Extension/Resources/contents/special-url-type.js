let specialTypeObject = {
    shadow: ['https://uaserials.pro'],
    nesting: ['https://uaserial.com', 'https://uaserial.tv']
}

getSpecialTypeByUrl = function (url)
{
    for (let key in specialTypeObject) {
        if (specialTypeObject[key].includes(url)) {
            return key;
        }
    }
    return null;
}