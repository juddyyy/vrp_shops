RMenu.Add('vRP_Shops', 'main', RageUI.CreateMenu("Shop", "~b~Shop", 1350, 50))

RageUI.CreateWhile(1.0, RMenu:Get('vRP_Shops', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('vRP_Shops', 'main'), true, false, true, function()
        for k, v in pairs(cfg.items) do
            RageUI.Button(v.name, nil, {RightLabel = cfg.currency..v.price}, true, function(Hovered, Active, Selected)
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
        local shopblip = AddBlipForCoord(table.unpack(v))
        SetBlipSprite(shopblip, 52)
        SetBlipDisplay(shopblip, 4)
        SetBlipScale(shopblip, 1.0)
        SetBlipColour(shopblip, 2)
        SetBlipAsShortRange(shopblip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Shop")
        EndTextCommandSetBlipName(shopblip)
    end

    for k,v in pairs(cfg.peds) do
        if cfg.ped == true then
            local shopPed = GetHashKey("mp_m_shopkeep_01")
            RequestModel(shopPed)
            while not HasModelLoaded(shopPed) do
                Wait(0)
            end

            local pedx,pedy,pedz,pedh = table.unpack(v) --ped x, ped y, ped z, ped heading
            local shopEntity = CreatePed(26,shopPed,pedx,pedy,pedz,pedh,false,true)
            SetModelAsNoLongerNeeded(shopPed)     
            SetEntityCanBeDamaged(shopEntity, 0)
            SetPedAsEnemy(shopEntity, 0)   
            SetBlockingOfNonTemporaryEvents(shopEntity, 1)
            SetPedResetFlag(shopEntity, 249, 1)
            SetPedConfigFlag(shopEntity, 185, true)
            SetPedConfigFlag(shopEntity, 108, true)
            SetEntityInvincible(shopEntity, true)
            SetEntityCanBeDamaged(shopEntity, false)
            SetPedCanEvasiveDive(shopEntity, 0)
            SetPedCanRagdollFromPlayerImpact(shopEntity, 0)
            SetPedConfigFlag(shopEntity, 208, true)       
            FreezeEntityPosition(shopEntity, true)
        end
    end

    while true do
        Citizen.Wait(0)

        for k, v in pairs(cfg.shops) do 
            local x,y,z = table.unpack(v)
            local location = vector3(x,y,z)

            if isInArea(location, 100.0) then 
                DrawMarker(20, location+1 - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, true, false, 2, true)
            end
 
            if isInArea(location, 1.4) and isInMenu == false then 
                alert('Press ~INPUT_VEH_HORN~ to Open the Store!')
                if IsControlJustPressed(0, 51) then 
                    currentShop = k
                    RageUI.Visible(RMenu:Get("vRP_Shops", "main"), true)
                    isInMenu = true
                end
            end

            if isInArea(location, 1.4) == false and isInMenu and currentShop == k then
                RageUI.Visible(RMenu:Get("vRP_Shops", "main"), false)
                isInMenu = false
            end
        end
    end
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
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