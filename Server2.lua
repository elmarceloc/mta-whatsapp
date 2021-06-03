local chatSystemDB = dbConnect( 'sqlite', 'Chat System - Database.db' )
dbExec( chatSystemDB, 'CREATE TABLE IF NOT EXISTS `Chat_System` (sourceSerial, blockedSerial)' )

addEvent( 'onServerCheckShow', true );
addEventHandler( 'onServerCheckShow', root,
function( player, name )
	if ( player and player ~= source ) then
		triggerClientEvent( player, 'onClientShowWrite', source, source, name )
	end
end );

addEvent( 'onServerCheckHide', true );
addEventHandler( 'onServerCheckHide', root,
function( player )
	if ( player and player ~= source ) then
		triggerClientEvent( player, 'onClientHideWrite', source, source )
	end
end );

addEvent( 'onServerCheckIfBlocked', true );
addEventHandler( 'onServerCheckIfBlocked', root,
function( serial )
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
		local results = dbPoll( check, -1 )
	if ( type( results ) == 'table' and #results ~= 0 ) then outputChatBox( '#FF0000• ERROR :#FFFFFF Sorry, You cannot send a message to this player .. it\'s blocked !', source, 255, 255, 255, true ) return end
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', serial, getPlayerSerial( source ) )
		local results = dbPoll( check, -1 )
	if ( type( results ) == 'table' and #results ~= 0 ) then outputChatBox( '#FF0000• ERROR :#FFFFFF Sorry, You cannot send a message to this player .. he was blocked you !', source, 255, 255, 255, true ) return end
		triggerClientEvent( source, 'buildChattingWith', source )
end );

addEvent( 'onServerSendPoke', true );
addEventHandler( 'onServerSendPoke', root,
function( player, serial )
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
		local results = dbPoll( check, -1 )
			if ( type( results ) == 'table' and #results ~= 0 ) then outputChatBox( '#FF0000• ERROR :#FFFFFF Sorry, You cannot send a poke to this player .. it\'s blocked or he was blocked you !', source, 255, 255, 255, true ) return end
		if ( getElementData( player, 'chatStatus' ) == 'Offline' ) then
			outputChatBox( '#FF0000• ERROR :#FFFFFF Sorry, You cannot send a poke to this player .. it\'s offline !', source, 255, 255, 255, true ) return end
		triggerClientEvent( player, 'onClientPokePlayer', source, getPlayerName( source ) )
end );

addEvent( 'onServerCheckBlockStatus', true );
addEventHandler( 'onServerCheckBlockStatus', root,
function( serial )
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
		local results = dbPoll( check, -1 )
			if ( type( results ) == 'table' and #results == 0 or not results ) then triggerClientEvent( source, 'onClientChangeButton', source, 'Block Player' ) return end
		triggerClientEvent( source, 'onClientChangeButton', source, 'Unblock Player' )
end );

addEvent( 'onServerBlockPlayer', true );
addEventHandler( 'onServerBlockPlayer', root,
function( serial, player )
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
		local results = dbPoll( check, -1 )
			if ( type( results ) == 'table' and #results ~= 0 ) then return end
		dbExec( chatSystemDB, 'INSERT INTO `Chat_System` VALUES(?,?)', getPlayerSerial( source ), serial )
	triggerClientEvent( source, 'onClientChangeButton', source, 'Unblock Player' )
	triggerClientEvent( player, 'onClientDestroyChats', source, source )
	triggerClientEvent( source, 'onClientDestroyChats', source, player )
end );

addEvent( 'onServerUnblockPlayer', true );
addEventHandler( 'onServerUnblockPlayer', root,
function( serial )
	local check = dbQuery( chatSystemDB, 'SELECT * FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
		local results = dbPoll( check, -1 )
			if ( type( results ) == 'table' and #results == 0 or not results ) then triggerClientEvent( source, 'onClientChangeButton', source, 'Block Player' ) return end
		dbExec( chatSystemDB, 'DELETE FROM `Chat_System` WHERE sourceSerial = ? AND blockedSerial = ?', getPlayerSerial( source ), serial )
	triggerClientEvent( source, 'onClientChangeButton', source, 'Block Player' )
end );

addEventHandler( 'onPlayerJoin', getRootElement(  ),
function(  )
	triggerClientEvent( root, 'onClientAddPlayer', source, source )
end );

addEventHandler( 'onPlayerQuit', getRootElement(  ),
function(  )
	triggerClientEvent( root, 'onClientRemovePlayer', source, source )
end );

addEventHandler( 'onPlayerChangeNick', getRootElement(  ),
function( old, new )
	triggerClientEvent( root, 'onClientRemovePlayer_ChangedName', source, source, old )
end );

addEvent( 'onServerSetPlayerSerial', true );
addEventHandler( 'onServerSetPlayerSerial', root,
function(  )
	setElementData( source, 'chatSystem;playerSerial', getPlayerSerial( source ) )
end );

addEvent( 'onServerChangeStatus', true );
addEventHandler( 'onServerChangeStatus', root,
function( Status )
	triggerClientEvent( root, 'onClientUpdateStatus', source, source, Status )
end );

addEvent( 'onServerSendMessage', true );
addEventHandler( 'onServerSendMessage', root,
function( plr, message )
	triggerClientEvent( plr, 'onClientReceiveMessage', source, source, message )
end );

addEvent( 'onServerPutPlayers', true );
addEventHandler( 'onServerPutPlayers', root,
function(  )
	for _, player in ipairs( getElementsByType( 'player' ) ) do
			local plrName = getPlayerName( player )
		local plrStatus = getElementData( player, 'privateChatSystem;playerStatus' ) or 'Online'
	triggerClientEvent( root, 'onClientPutPlayers', player, plrName, plrStatus )
	end
end );
