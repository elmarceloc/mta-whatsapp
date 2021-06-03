-- If you don't know anything in programming don't edit anything down .
local Cplayer = localPlayer;
local screenW, screenH = guiGetScreenSize();
setElementData(Cplayer, 'chatStatus', 'Online')
setElementData(Cplayer, 'donotDisturb', nil)
local chat_Windows = {};

local statusTable = {{'Both (All)'}, {'Online'}, {'Offline'}};

local badWordsTable = {
    {':v'},
};

function getFormatedTime ()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute

    if (hours < 10) then
		hours = "0"..hours
	end
	if (minutes < 10) then
		minutes = "0"..minutes
	end
    return hours ..':' .. minutes

end

function sendNewMessage(playerName, message)
    if (isTimer(sendTimer)) then return end
	player = getPlayerFromName(playerName)

	-- checks if there are censored words
	for _, badWord in ipairs(badWordsTable) do
		if (string.find(message, badWord[1])) then
			
            executeBrowserJavascript(source,"showBanner('.banner.error')")

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
		executeBrowserJavascript(source,"app.sendMessage('".. message .."','".. getPlayerName(Cplayer) .."','".. getFormatedTime() .."')")

		sendTimer = setTimer(function() killTimer(sendTimer) end, 2500, 1)
	end
end
addEvent('sendMessageFromWebApp',true)
addEventHandler('sendMessageFromWebApp',root, sendNewMessage)

function resiveMessage(player, message)
	executeBrowserJavascript(theBrowser,"app.resiveMessage('".. message .."','".. getPlayerName(player).."','".. getFormatedTime() .."')")
end

addEvent('onClientReceiveMessage', true);
addEventHandler('onClientReceiveMessage', root, resiveMessage)



function sendIsTyping(playerName)
    triggerServerEvent('onServerSendIsTyping',localPlayer,getPlayerFromName(playerName))
end
addEvent('isTyping', true);
addEventHandler('isTyping', root, sendIsTyping)

function showIsTyping()
    executeBrowserJavascript(theBrowser,"app.showIsTyping('".. getPlayerName(source) .."')")
end
addEvent('onClientShowIsTyping', true);
addEventHandler('onClientShowIsTyping', root, showIsTyping)


function addPlayer(player, webBrowser)
    local status = getElementData(player, 'chatStatus') or 'Online'
    local name = getPlayerName(player)
    local r, g, b = getPlayerNametagColor(player)

    local jsPayload =  "app.contacts.push({name: '".. name .."',status: '".. status .."',color: ["..r..","..g..","..b.."]"

    local team = getPlayerTeam(player)

    if team then
        local teamr, teamg, teamb = getTeamColor(team)
        local teamName = getTeamName(team)

        jsPayload = jsPayload .. ",team: '"..teamName.."',teamcolor: ["..teamr..","..teamg..","..teamb.."]"
    end

    jsPayload = jsPayload .. '})'

	setTimer(function()
		executeBrowserJavascript(webBrowser, jsPayload);	
	end,1000,1)
end

function removePlayer(player)
    local name = getPlayerName(player)
	outputConsole('web browser is '..tostring(isElement(webBroser)))
	executeBrowserJavascript(theBrowser,"app.removePlayerFromContacts('".. name .."')")
end

addEventHandler('onClientBrowserDocumentReady', resourceRoot, function()
    triggerServerEvent('onServerSetPlayerSerial', Cplayer)
    setTimer(function(webBr)
        for _, player in ipairs(getElementsByType('player')) do
            addPlayer(player,webBr)
        end
    end, 1000, 1,source)
end);


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