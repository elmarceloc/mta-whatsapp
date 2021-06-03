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

browser = guiCreateBrowser(phoneX, phoneY, phoneWidth, phoneHeight, true,
                                 false, false)
theBrowser = guiGetBrowser(browser)

-- local page = "http://mta/html-login-panel/html/login.html"
local page = "http://mta/whatsapp/whatsapp.html"

resourceRoot = getResourceRootElement(getThisResource())

visible = false
state = false
time = 0

guiSetVisible(browser, false)

function removeHex(s) return s:gsub("#%x%x%x%x%x%x", "") or false end

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

    end)

end)

addEventHandler("onClientBrowserCreated", theBrowser, function()
    --	local name = getPlayerName(localPlayer)
    loadBrowserURL(theBrowser, page)

    setDevelopmentMode(true, true) -- Enable client dev mode
    toggleBrowserDevTools(theBrowser, true) -- Toggle the CEF dev console		--executeBrowserJavascript(theBrowser, 'document.write(' .. name ..')')

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
