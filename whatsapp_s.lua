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

addEvent( 'onServerSendIsTyping', true );
addEventHandler( 'onServerSendIsTyping', root,
function( player )
	-- test with VM
	triggerClientEvent( player, 'onClientShowIsTyping',source )
end );
