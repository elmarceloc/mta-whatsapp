--[[
Usefull functions:
executeBrowserJavascript(theBrowser, 'document.getElementById("demo").innerHTML = "' .. msg ..'"')
]] 


local myWidth = 1366
local myHeight = 768

local screenWidth, screenHeight = guiGetScreenSize()

local phoneWidth = 400
local phoneHeight = 800

local phoneX = screenWidth - phoneWidth - 48
local phoneY = screenHeight - phoneHeight + 400

local browser = guiCreateBrowser(phoneX, phoneY, phoneWidth, phoneHeight, true,
                                 false, false)
local theBrowser = guiGetBrowser(browser)

-- local page = "http://mta/html-login-panel/html/login.html"
local page = "http://mta/whatsapp/chat.html"

resourceRoot = getResourceRootElement(getThisResource())

visible = false
state = false
time = 0

guiSetVisible(browser, false)

function secondsToTimeDesc(seconds)
    if seconds then
        local results = {}
        local sec = (seconds % 60)
        local min = math.floor((seconds % 3600) / 60)
        local hou = math.floor((seconds % 86400) / 3600)
        local day = math.floor(seconds / 86400)

        if day > 0 then
            table.insert(results, day .. (day == 1 and " día" or " días"))
        end
        if hou > 0 then
            table.insert(results, hou .. (hou == 1 and " hora" or " horas"))
        end
        if min > 0 then
            table.insert(results, min .. (min == 1 and " minuto" or " minutos"))
        end
        if sec > 0 then
            table.insert(results,
                         sec .. (sec == 1 and " segundo" or " segundos"))
        end

        return string.reverse(table.concat(results, ", "):reverse():gsub(" ,",
                                                                         " y ",
                                                                         1))
    end
    return ""
end

function isPlayerInTeam(player, team)
    assert(isElement(player) and getElementType(player) == "player",
           "Bad argument 1 @ isPlayerInTeam [player expected, got " ..
               tostring(player) .. "]")
    assert((not team) or type(team) == "string" or
               (isElement(team) and getElementType(team) == "team"),
           "Bad argument 2 @ isPlayerInTeam [nil/string/team expected, got " ..
               tostring(team) .. "]")
    return getPlayerTeam(player) ==
               (type(team) == "string" and getTeamFromName(team) or
                   (type(team) == "userdata" and team or
                       (getPlayerTeam(player) or true)))
end

function removeHex(s) return s:gsub("#%x%x%x%x%x%x", "") or false end

function disatachBlip(player)
    for index, element in ipairs(getAttachedElements(player)) do
        if (getElementType(element) == "blip") then
            destroyElement(element)
        end
    end
end

function toggle()
    -- fixed
    if state and phoneY == screenHeight - phoneHeight + 400 then
        if not guiGetVisible(browser, true) then
            guiSetVisible(browser, true)
            --		setBrowserRenderingPaused(thebrowser, false)
            showCursor(true)

            visible = true
            time = -10
        end
    end

    -- bajando..
    if not state and phoneY < screenHeight + 95 + 22 then
        phoneY = phoneY + time
        time = time + 3 / 2
        if guiGetVisible(browser, true) then
            guiSetVisible(browser, false)
            setBrowserRenderingPaused(theBrowser, false)
            showCursor(false)
        end
    elseif not state then
        time = 0
        visible = false
    end

    -- subiendo..
    if state and phoneY - time / 2 - 30 > screenHeight - phoneHeight + 400 then
        if not visible then
            visible = true
            time = 0
        end
        phoneY = phoneY - time / 2 - 30
        time = time + 1

    elseif state then
        phoneY = screenHeight - phoneHeight + 400
        time = -10

    end

    if not visible then return end
    dxDrawImage(phoneX - 28, phoneY - 95 - 22, phoneWidth + 72 + -20,
                phoneHeight, 'img/3.png', 0, 0, 0, tocolor(255, 255, 255, 255),
                false)
end
addEventHandler('onClientRender', root, toggle)

-- TODO: cambiar por cuando se aprete la tecla,renderise,etc
addEventHandler("onClientResourceStart",
                getResourceRootElement(getThisResource()), function()
    -- toggle(false)
    -- resizeBrowser( theBrowser, 0, 0 )

    -- if isPlayerInTeam(source, getTeamFromName("Repartidor") ) then return end
    bindKey("n", "down", function()

        if not state then
            addEventHandler("onClientClick", getRootElement(), click)
        else
            removeEventHandler("onClientClick", getRootElement(), click)
        end

        state = not state

        toggleControl("chatbox", not state)
        updateDeliveries(theBrowser)

    end)

end)

addEventHandler("onClientBrowserCreated", theBrowser, function()
    --	local name = getPlayerName(localPlayer)
    loadBrowserURL(theBrowser, page)

    setDevelopmentMode(true, true) -- Enable client dev mode
    toggleBrowserDevTools(theBrowser, true) -- Toggle the CEF dev console		--executeBrowserJavascript(theBrowser, 'document.write(' .. name ..')')

end)

addEventHandler("onClientBrowserDocumentReady", root, function(url)

    local name = getPlayerName(localPlayer)
    -- outputConsole(name)
    updateDeliveries(theBrowser)
    executeBrowserJavascript(theBrowser,
                             "document.getElementById('username').innerHTML = '" ..
                                 removeHex(name) .. "'");
end)

function click(button, estado, absoluteX, absoluteY, worldX, worldY, worldZ,
               clickedElement)
    if not (absoluteX + 48 > phoneX and absoluteY > phoneY - 95 - 22) and
        visible and estado then
        state = false

        toggleControl("chatbox", true)
        --	outputChatBox(tostring(state))
    end

end

-- addCommandHandler('dev',function()
--	toggleBrowserDevTools(theBrowser, true) -- Toggle the CEF dev console		--executeBrowserJavascript(theBrowser, 'document.write(' .. name ..')')
-- end)

function onBuyLoto()
    outputDebugString("onBuyLoto")
    triggerServerEvent("buyloto", root)

end
addEvent("buyLoto", true)
addEventHandler("buyLoto", root, onBuyLoto)

function onGiveMoney(money) triggerServerEvent("givemoney", localPlayer, money) end
addEvent("giveMoney", true)
addEventHandler("giveMoney", root, onGiveMoney)

function onAccept() executeBrowserJavascript(theBrowser, "app.buy()"); end
addEvent("accept", true)
addEventHandler("accept", root, onAccept)
