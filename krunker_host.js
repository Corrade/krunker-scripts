/*
Run this script on your browser* when you're on the 'host game' menu, input your exported map data** when prompted and wait for your game to start with all the settings automatically inputted.

You can input nothing and the script will by default set the match time to 0 and make the lobby private.

Comment out the final line to disable automatically starting the server.

* On Chrome, press F12 to open DevTools, go to the console tab, copy-paste the code and press enter. Alternatively save the script as a snippet for easy future access (see https://developers.google.com/web/tools/chrome-devtools/javascript/snippets). You may have to adjust the size of your game window on DevTools so that it's big enough for Krunker to not mistake it for a mobile app. If you don't do this you may see mobile controls show up.

** When you host from the editor, you'll have your export data automatically placed in the 'raw game data' input field. You can just copy that and give it to this script.

@Corrade#0901
*/

let data = prompt('Enter map data:');
let config;

try {
    let json = JSON.parse(data);
    config = json.config;
} catch (e) {
    config = { "settings": { "gameTime": 0 } };
}

let keydownEvent = new Event('input', {"keydown": ""});

function setValue(ele, settingValue) {
    if (ele.type === "range") {
        ele.value = settingValue;
        ele.dispatchEvent(keydownEvent);
    } else if (ele.type === "checkbox") {
        if (Boolean(settingValue) !== Boolean(ele.checked)) {
            ele.click();
        }
    } else {
        alert("Unrecognised element type");
    }
}

// Modes
if (config.modes !== undefined) {
    for (let modeId = 0; modeId <= 24; modeId++) {
        let ele = document.querySelector(`#gameMode${modeId}`);
        if (ele !== null && (config.modes.includes(modeId) !== Boolean(ele.checked))) {
            ele.click();
        }
    }
}

// Classes
if (config.classes !== undefined) {
    for (let classId = 0; classId <= 14; classId++) {
        let ele = document.querySelector(`#gameClass${classId}`);
        if (ele !== null && (config.classes.includes(classId) !== Boolean(ele.checked))) {
            ele.click();
        }
    }
}

// Settings
if (config.settings !== undefined) {
    for (let [settingName, settingValue] of Object.entries(config.settings)) {
        let ele = document.querySelector(`#customS${settingName}`);
        setValue(ele, settingValue);
    }
}

// Weapons
if (config.weps !== undefined) {
    // Enable weapon config
    document.querySelector(`#forcedSettings .settName.b .switch input`).click();

    for (let [weaponId, wepSettings] of Object.entries(config.weps)) {
        for (let [settingName, settingValue] of Object.entries(wepSettings)) {
            let ele = document.querySelector(`#customW${weaponId}${settingName}`);
            setValue(ele, settingValue);
        }
    }
}

// Make private
let ele = document.getElementById('makePrivate');
if (!ele.checked) {
    ele.click();
}

// Start server
document.querySelectorAll('#menuWindow .menuLink')[1].click();
