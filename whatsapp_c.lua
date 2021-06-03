-- If you don't know anything in programming don't edit anything down .
local Cplayer = localPlayer;
local screenW, screenH = guiGetScreenSize();
setElementData(Cplayer, 'chatStatus', 'Online')
setElementData(Cplayer, 'donotDisturb', nil)
local chat_Windows = {};

local statusTable = {{'Both (All)'}, {'Online'}, {'Offline'}};

local badWordsTable = {
    {'xddd'},
};

function clickTimer(element, timer)
    guiSetEnabled(element, false)
    setTimer(guiSetEnabled, timer * 1000, 1, element, true)
end

function sendNewMessage(playerName, message)
    if (isTimer(sendTimer)) then return end
	player = getPlayerFromName(playerName)

	-- checks if there are censored words
	for _, badWord in ipairs(badWordsTable) do
		if (string.find(message, badWord[1])) then
			--TODO: send waring to player (localPlayer)
			
			sendTimer = setTimer(function()
				killTimer(sendTimer)
			end, 2500, 1)
			return
		end
	end

	if (string.len(message) > 0) then
		-- sends the message
		triggerServerEvent('onServerSendMessage', Cplayer, player, message)
		-- put message sended in the web app
		executeBrowserJavascript(source,"app.sendMessage('".. message .."','".. getPlayerName(Cplayer) .."')")

		sendTimer = setTimer(function() killTimer(sendTimer) end, 2500, 1)
	end
end
addEvent('sendMessageFromWebApp',true)
addEventHandler('sendMessageFromWebApp',root, sendNewMessage)

function removePlayer(player)
    local name = getPlayerName(player)
	outputConsole('web browser is '..tostring(isElement(webBroser)))
	executeBrowserJavascript(theBrowser,"app.removePlayerFromContacts('".. name .."')")
end

local txtValue = 0

function showWriteMessage(player, name)
    if (isTimer(writeTimer)) then return end
	-- TODO: send Player is writing message
   -- guiSetText(chat_Windows[player].Label, '* [' .. name .. '] is typing')
   
    writeTimer = setTimer(function()
        if (txtValue >= 3) then
            --guiSetText(chat_Windows[player].Label,
            --           '* [' .. name .. '] is typing')
            txtValue = 0
        end
       -- guiSetText(chat_Windows[player].Label,
       --            guiGetText(chat_Windows[player].Label) .. '.')
        txtValue = txtValue + 1
    end, 500, 0)
end
addEvent('onClientShowWrite', true);
addEventHandler('onClientShowWrite', root, showWriteMessage)

addEvent('onChatChange')
addEventHandler('onChatChange', root, function()
	triggerServerEvent('onServerCheckShow', Cplayer, player, getPlayerName(Cplayer))
end);

addEvent('onClientReceiveMessage', true);
addEventHandler('onClientReceiveMessage', root, function(player, message)			
	-- send the message to the web app			  
	executeBrowserJavascript(theBrowser,"app.resiveMessage('".. message .."','".. getPlayerName(player).."')")
end);

function addPlayer(player, webBrowser)
    local data = getElementData(player, 'chatStatus') or 'Online'
    local name = getPlayerName(player)
    local r, g, b = getPlayerNametagColor(player)

	setTimer(function()
		executeBrowserJavascript(webBrowser, "app.contacts.push({name: '".. name .."',status: '".. data .."',color: ["..r..","..g..","..b.."]})");	
	end,1000,1)
end

function player_Join(player)

	outputConsole('webBroser is'..tostring(isElement(webBroser)))

    if (player ~= Cplayer) then
        addPlayer(player, webBrowser)
    end
end
addEvent('onClientAddPlayer', true);
addEventHandler('onClientAddPlayer', root, player_Join)

function player_Quit(player)
    removePlayer(player)
end
addEvent('onClientRemovePlayer', true);
addEventHandler('onClientRemovePlayer', root, player_Quit)

addEventHandler('onClientBrowserDocumentReady', resourceRoot, function()
    triggerServerEvent('onServerSetPlayerSerial', Cplayer)
    setTimer(function(webBr)
        for _, player in ipairs(getElementsByType('player')) do
            addPlayer(player,webBr)
        end
    end, 1000, 1,source)
end);
