--FUNCIONANDO

addEvent("buyloto",true)
addEventHandler("buyloto", root, function(id)
    outputDebugString("buyproduct")


    if getPlayerMoney(client) >= 6000 then

        triggerClientEvent(client,"accept",root)

        takePlayerMoney(client, 6000)

    else
        outputChatBox('No te alcanza para comprar el kino',client,255,0,0)
    end
end)



addEvent("givemoney",true)
addEventHandler("givemoney", root, function(money)
    outputDebugString("givemoney")
 
    givePlayerMoney(source,money )
    
end)


