local robbed = false

lib.callback.register('lb_automatenRaub:hasDrill',function ()
    
    if exports.ox_inventory:GetItem(source, 'drill', nil, true) >= 1 then

        return true

    else
        return false
    end

end)

RegisterNetEvent('lb_automatenRaub:removeDrill', function ()

    exports.ox_inventory:RemoveItem(source, 'drill', 1)

end)

RegisterNetEvent('lb_automatenRaub:giveMoney', function (amount)

    exports.ox_inventory:AddItem(source, 'black_money', amount)

end)

RegisterNetEvent('lb_automatenRaub:gotRobbed',function ()
    
    robbed = true
    
end)

RegisterNetEvent('lb_automatenRaub:notRobbed',function ()
    
    robbed = false
    
end)

lib.callback.register('lb_automatenRaub:robbed', function()

    return robbed

end)

lib.addCommand('resetAutomaten', {restricted = 'group.admin'}, function ()

    robbed = false
    
end)
