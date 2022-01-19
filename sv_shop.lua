local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_shop")

RegisterNetEvent("vrpshop:buy")
AddEventHandler("vrpshop:buy", function(item, price)
    local source = source
    local user_id = vRP.getUserId({source})

    for i, v in pairs(cfg.items) do
        if item == v.itemid then
            if price == v.price then
                if vRP.tryFullPayment({user_id, price}) then
                    vRP.giveInventoryItem({user_id, item, 1, true})
                else
                    vRPclient.notify(source,{"~r~You do not have enough money to buy this!"})
                end
            else
                print("perm id: "..user_id.." tried to trigger vrpshop:buy event")
                vRP.banConsole({user_id, "perm", "Triggering Events."})
            end
        end
    end
end)