QBCore = nil
TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)

QBCore.Commands.Add("polytool", "Mojito's tool for being lazy", {{name="radius", help="radius"}}, false, function(source, args)
    if args[1] ~= nil then
        TriggerClientEvent("mojito_pedzones:open", source, tonumber(args[1]))
    else
        TriggerClientEvent("mojito_pedzones:open", source, false)
    end
end, "admin")

QBCore.Functions.CreateCallback("mojito_polytool:getpermission", function(source, cb)
    cb(QBCore.Functions.GetPermission(source))
end)