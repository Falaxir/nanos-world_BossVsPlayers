var ResetBossPointsId
var ResetBossPointsNumbers
var VolumeMusicPlus
var VolumeMusicNumber
var VolumeMusicMinus
var VolumeEffectPlus
var VolumeEffectNumber
var VolumeEffectMinus
var LanguageContainer
var LanguageHaveBeenDisplayed = false

function ResetBossPointsFCT() {
    Events.Call("BVP_Client_ResetBossPoints", 0);
    ResetBossPointsNumbers.innerHTML = 0
}

function VolumeMusicPlusFCT() {
    var test = parseInt(VolumeMusicNumber.innerHTML)
    if (test >= 100)
        return
    test += 5
    Events.Call("BVP_Client_ChangeVolumeMusic", test);
    VolumeMusicNumber.innerHTML = test
}

function VolumeMusicMinusFCT() {
    var test = parseInt(VolumeMusicNumber.innerHTML)
    if (test <= 0)
        return
    test -= 5
    Events.Call("BVP_Client_ChangeVolumeMusic", test);
    VolumeMusicNumber.innerHTML = test
}

function VolumeEffectPlusFCT() {
    var test = parseInt(VolumeEffectNumber.innerHTML)
    if (test >= 100)
        return
    test += 5
    Events.Call("BVP_Client_ChangeVolumeEffects", test);
    VolumeEffectNumber.innerHTML = test
}

function VolumeEffectMinusFCT() {
    var test = parseInt(VolumeEffectNumber.innerHTML)
    if (test <= 0)
        return
    test -= 5
    Events.Call("BVP_Client_ChangeVolumeEffects", test);
    VolumeEffectNumber.innerHTML = test
}

function DisplayLanguage(langs) {
    if (LanguageHaveBeenDisplayed)
        return
    LanguageHaveBeenDisplayed = true
    var pos = 0
    for (let key of langs) {
        var newDiv = document.createElement("div");
        newDiv.className = "OptionsVolumeNumber"
        newDiv.id = "LanguageDiv_" + key.Language
        newDiv.onclick = function () {
            Events.Call("BVP_Client_ChangeLanguage", key.Language);
        }
        var newContent = document.createTextNode(key.Language);
        newDiv.appendChild(newContent);
        LanguageContainer.appendChild(newDiv);
        pos++
    }
}

Events.Subscribe("BVP_OptionsDisplayLanguage", function(langs) {
    langs = JSON.parse(langs);
    DisplayLanguage(langs)
});

Events.Subscribe("BVP_OptionsSetBossPoints", function(points) {
    document.querySelector("#BossPointNumberValue").innerHTML = points
});

Events.Subscribe("BVP_OptionsSetVolumeMusic", function(value) {
    document.querySelector("#VolumeMusicNumber").innerHTML = value
});

Events.Subscribe("BVP_OptionsSetVolumeEffects", function(value) {
    document.querySelector("#VolumeEffectNumber").innerHTML = value
});

function LoadEventClick() {
    ResetBossPointsId = document.getElementById("BossPointReset")
    ResetBossPointsNumbers = document.getElementById("BossPointNumberValue")
    VolumeMusicPlus = document.getElementById("VolumeMusicPlus")
    VolumeMusicNumber = document.getElementById("VolumeMusicNumber")
    VolumeMusicMinus = document.getElementById("VolumeMusicMinus")
    VolumeEffectPlus = document.getElementById("VolumeEffectPlus")
    VolumeEffectNumber = document.getElementById("VolumeEffectNumber")
    VolumeEffectMinus = document.getElementById("VolumeEffectMinus")
    LanguageContainer = document.getElementById("LanguageContainer")
    ResetBossPointsId.onclick = ResetBossPointsFCT
    VolumeMusicPlus.onclick = VolumeMusicPlusFCT
    VolumeMusicMinus.onclick = VolumeMusicMinusFCT
    VolumeEffectPlus.onclick = VolumeEffectPlusFCT
    VolumeEffectMinus.onclick = VolumeEffectMinusFCT
}

window.onload = LoadEventClick