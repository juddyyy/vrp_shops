RMenu.Add('vRP_Shops', 'main', RageUI.CreateMenu("Shop", "~b~Shop", 1350, 50))

RageUI.CreateWhile(1.0, RMenu:Get('vRP_Shops', 'main'), nil, function()

    RageUI.IsVisible(RMenu:Get('vRP_Shops', 'main'), true, false, true, function()
        for k, v in pairs(cfg.items) do

            RageUI.Button(v.name, nil, { RightLabel = cfg.currency..v.price }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("vrpshop:buy", v.itemid, v.price)
                end
            end)

        end
    end, function() 
    end)
end)

local isInMenu = false
local currentShop = nil

Citizen.CreateThread(function() 

    for k,v in pairs(cfg.shops) do
        local x,y,z = table.unpack(v)
        local blip = AddBlipForCoord(x,y,z)
        SetBlipSprite(blip, 52)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Shop")
        EndTextCommandSetBlipName(blip)
    end

    while true do
        for k, v in pairs(cfg.shops) do 
            local x,y,z = table.unpack(v)
            local v1 = vector3(x,y,z)

            if isInArea(v1, 100.0) then 
                DrawMarker(20, v1+1 - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, true, false, 2, true)
            end
 
            if isInMenu == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to Open the Store!')
                if IsControlJustPressed(0, 51) then 
                    currentShop = k
                    RageUI.Visible(RMenu:Get("vRP_Shops", "main"), true)
                    isInMenu = true
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentShop then
                RageUI.Visible(RMenu:Get("vRP_Shops", "main"), false)
                isInMenu = false
            end
        end
        Citizen.Wait(0)
    end
end)

function isInArea(v, dis) 
    
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end