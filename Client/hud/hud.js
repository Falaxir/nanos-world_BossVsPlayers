function secondsToTime(timer) {
    var sec_num = parseInt(timer, 10);
    var hours   = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);

    // if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    // hours+':'+
    return minutes+':'+seconds;
}

Events.Subscribe("BVP_HUD_Image_Background", function(image) {
    if (image == null)
        document.querySelector("html").style.background = "no-repeat center center fixed";
    else
        document.querySelector("html").style.background = "url(" + image + ") no-repeat center center fixed";
    // if (image == null) {
    //     var htmlClass = document.getElementsByClassName("html")
    //     for (var i = 0; i < htmlClass.length; i++) {
    //         htmlClass[i].style.background = "none";
    //     }
    // } else {
    //     var htmlClass = document.getElementsByClassName("html")
    //     for (var i = 0; i < htmlClass.length; i++) {
    //         htmlClass[i].style.background = "url(" + image + ") no-repeat center center fixed";
    //     }
    // }
});

Events.Subscribe("BVP_HUD_Boss_Container_Display", function(display) {
    if (display === 1)
        document.querySelector("#hud-bottom-boss-container-id").style.display = "inline";
    else
        document.querySelector("#hud-bottom-boss-container-id").style.display = "none";
});

Events.Subscribe("BVP_HUD_Boss_Rage", function(txt) {
    document.querySelector("#hud-boss-rage").innerHTML = txt;
});

Events.Subscribe("BVP_HUD_Boss_Jump", function(txt) {
    document.querySelector("#hud-boss-jump").innerHTML = txt;
});

Events.Subscribe("BVP_HUD_Boss_Special", function(txt) {
    document.querySelector("#hud-boss-special").innerHTML = txt;
});

Events.Subscribe("BVP_HUD_Timer", function(timer) {
    document.querySelector("#hud_time").innerHTML = secondsToTime(timer);
});

Events.Subscribe("BVP_HUD_Boss_Health", function(health) {
    document.querySelector("#hud_boss").innerHTML = health;
});

Events.Subscribe("BVP_HUD_Players_Remaining", function(players) {
    document.querySelector("#hud_players").innerHTML = players;
});

Events.Subscribe("BVP_HUD_Advert_top_one", function(txt) {
    if (txt == null)
        return document.querySelector("#hud_advert_one").style.display = "none";
    document.querySelector("#hud_advert_one").innerHTML = txt;
    document.querySelector("#hud_advert_one").style.display = "block";
});

Events.Subscribe("BVP_HUD_Advert_important", function(txt) {
    if (txt == null)
        return document.querySelector("#advert_important").style.display = "none";
    document.querySelector("#advert_important").innerHTML = txt;
    document.querySelector("#advert_important").style.display = "block";
});

Events.Subscribe("BVP_HUD_Advert_top_two", function(txt) {
    if (txt == null)
        return document.querySelector("#hud_advert_two").style.display = "none";
    document.querySelector("#hud_advert_two").innerHTML = txt;
    document.querySelector("#hud_advert_two").style.display = "block";
});

Events.Subscribe("BVP_HUD_Advert_bottom_one", function(txt) {
    if (txt == null)
        return document.querySelector("#hud_bottom_advert_one").style.display = "none";
    document.querySelector("#hud_bottom_advert_one").innerHTML = txt;
    document.querySelector("#hud_bottom_advert_one").style.display = "block";
});

Events.Subscribe("BVP_HUD_Advert_bottom_two", function(txt) {
    if (txt == null)
        return document.querySelector("#hud_bottom_advert_two").style.display = "none";
    document.querySelector("#hud_bottom_advert_two").innerHTML = txt;
    document.querySelector("#hud_bottom_advert_two").style.display = "block";
});

// Registers for ToggleVoice from Scripting
Events.Subscribe("ToggleVoice", function(name, enable) {
    const existing_span = document.querySelector(`.voice_chat#${name}`);

    if (enable) {
        if (existing_span)
            return;

        const span = document.createElement("span");
        span.classList.add("voice_chat");
        span.id = name;
        span.innerHTML = name;

        document.querySelector("#voice_chats").prepend(span);
    } else {
        if (existing_span == null)
            return;
        existing_span.remove();
    }
});

// Register for UpdateWeaponAmmo custom event (from Lua)
Events.Subscribe("UpdateWeaponAmmo", function(enable, clip, bag) {
    if (enable)
        document.querySelector("#weapon_ammo_container").style.display = "block";
    else
        document.querySelector("#weapon_ammo_container").style.display = "none";

    // Using JQuery, overrides the HTML content of these SPANs with the new Ammo values
    document.querySelector("#weapon_ammo_clip").innerHTML = clip;
    document.querySelector("#weapon_ammo_bag").innerHTML = bag;
});

// Register for UpdateHealth custom event (from Lua)
Events.Subscribe("UpdateHealth", function(health) {
    // Overrides the HTML content of the SPAN with the new health value
    document.querySelector("#health_current").innerHTML = health;

    // Bonus: make the background red when health below 25
    document.querySelector("#health_container").style.backgroundColor = health <= 25 ? "#ff05053d" : "#0000003d";
});