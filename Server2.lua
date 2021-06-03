local chatSystemDB = dbConnect( 'sqlite', 'Chat System - Database.db' )
dbExec( chatSystemDB, 'CREATE TABLE IF NOT EXISTS `Chat_System` (sourceSerial, blockedSerial)' )

addEvent( 'onServerCheckShow', true );
addEventHandler( 'onServerCheckShow', root,
function( player, name )
	if ( player and player ~= source ) then
		triggerClientEvent( player, 'onClientShowWrite', source, source, name )
	end
end );

addEventHandler( 'onPlayerJoin', getRootElement(  ),
function(  )
	triggerClientEvent( root, 'onClientAddPlayer', source, source )
end );

addEventHandler( 'onPlayerQuit', getRootElement(  ),
function(  )
	triggerClientEvent( root, 'onClientRemovePlayer', source, source )
end );

addEvent( 'onServerSetPlayerSerial', true );
addEventHandler( 'onServerSetPlayerSerial', root,
function(  )
	setElementData( source, 'chatSystem;playerSerial', getPlayerSerial( source ) )
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
