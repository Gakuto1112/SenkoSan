--ping関数
function pings.emote_keys_up()
    KeyEmoteUp:play()
end

function pings.emote_keys_right()
    KeyEmoteRight:play()
end

function pings.emote_keys_down()
    KeyEmoteDown:play()
end

function pings.emote_keys_left()
    KeyEmoteLeft:play()
end

KeyManager.register("emote_keys__up", "key.keyboard.up", function ()
    if not ActionWheel.IsAnimationPlaying then
        if KeyEmoteUp:checkAction() then
            pings.emote_keys_up()
        elseif Warden.WardenNearby then
            pings.refuse_emote()
        end
    end
end)
KeyManager.register("emote_keys__right", "key.keyboard.right", function ()
    if not ActionWheel.IsAnimationPlaying then
        if KeyEmoteRight:checkAction() then
            pings.emote_keys_right()
        elseif Warden.WardenNearby then
            pings.refuse_emote()
        end
    end
end)
KeyManager.register("emote_keys__down", "key.keyboard.down", function ()
    if not ActionWheel.IsAnimationPlaying then
        if KeyEmoteDown:checkAction() then
            pings.emote_keys_down()
        elseif Warden.WardenNearby then
            pings.refuse_emote()
        end
    end
end)
KeyManager.register("emote_keys__left", "key.keyboard.left", function ()
    if not ActionWheel.IsAnimationPlaying then
        if KeyEmoteLeft:checkAction() then
            pings.emote_keys_left()
        elseif Warden.WardenNearby then
            pings.refuse_emote()
        end
    end
end)