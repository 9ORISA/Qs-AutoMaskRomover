local savedMasks, inMaskZone = {}, false

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = "qb"
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Framework = "esx"
else
    Framework = "standalone"
end

function Notify(messageKey, type, duration, isDebug)
    if not Config.Notify and not isDebug then return end
    if isDebug and not Config.Debug then return end

    local msgType = isDebug and 'debug' or type
    local message = CurrentLang[messageKey] or messageKey

    if Framework == "qb" and QBCore then
        QBCore.Functions.Notify(message, msgType, duration or 5000)
    elseif Framework == "esx" and ESX then
        ESX.ShowNotification(message, duration or 5000)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, true)
    end

    if isDebug and Config.Debug then print('[MASK DEBUG] '..message) end
end

function ToggleMask(command)
    if Cooldown then return end

    local Player = Framework == "qb" and QBCore.Functions.GetPlayerData() or {}
    local citizenid = Player.citizenid or (Framework == "esx" and ESX.GetPlayerData().identifier) or "unknown"
    local Ped = PlayerPedId()
    local currentMask = {
        Drawable = GetPedDrawableVariation(Ped, 1),
        Texture = GetPedTextureVariation(Ped, 1)
    }

    if command == "on" then
        if currentMask.Drawable ~= 0 then
            Notify("already_masked", "error")
            return false
        end

        PlayToggleEmote(function()
            local mask = savedMasks[citizenid] or Config.DefaultMask
            SetPedComponentVariation(Ped, 1, mask.drawable or mask.Drawable, mask.texture or mask.Texture, 0)
            Notify(mask == Config.DefaultMask and "mask_on_default" or "mask_restored", "success")
        end)
        return true

    elseif command == "off" then
        if currentMask.Drawable == 0 then
            Notify("no_mask", "error")
            return false
        end

        savedMasks[citizenid] = {
            Drawable = currentMask.Drawable,
            Texture = currentMask.Texture
        }

        PlayToggleEmote(function()
            SetPedComponentVariation(Ped, 1, 0, 0, 0)
            Notify("mask_off_saved", "success")
        end)
        return true
    else
        Notify("invalid_command", "error")
        return false
    end
end

function DrawDebugZones()
    if not Config.Debug then return end
    for _, zone in pairs(Config.MaskZones) do
        if zone.debugZone then
            DrawMarker(28, zone.coords.x, zone.coords.y, zone.coords.z, 0, 0, 0, 0, 0, 0,
                zone.radius, zone.radius, zone.radius,
                zone.debugColor.r, zone.debugColor.g, zone.debugColor.b, zone.debugColor.a,
                false, true, 2, false, nil, nil, false)
        end
    end
end

function CheckMaskZones()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    local shouldBeInZone, currentZone = false, nil

    for _, zone in pairs(Config.MaskZones) do
        if #(playerCoords - zone.coords) <= zone.radius then
            shouldBeInZone, currentZone = true, zone
            break
        end
    end

    if shouldBeInZone and not inMaskZone then
        inMaskZone = true
        local maskDrawable = GetPedDrawableVariation(ped, 1)
        if maskDrawable ~= 0 then
            local Player = Framework == "qb" and QBCore.Functions.GetPlayerData() or {}
            local citizenid = Player.citizenid or (Framework == "esx" and ESX.GetPlayerData().identifier) or "unknown"
            
            savedMasks[citizenid] = {
                Drawable = maskDrawable,
                Texture = GetPedTextureVariation(ped, 1)
            }
            PlayToggleEmote(function()
                SetPedComponentVariation(ped, 1, 0, 0, 0)
                if currentZone.notifyEnterExit then
                    Notify("enter_zone", "primary")
                end
            end)
        end
    elseif not shouldBeInZone and inMaskZone then
        inMaskZone = false
        local Player = Framework == "qb" and QBCore.Functions.GetPlayerData() or {}
        local citizenid = Player.citizenid or (Framework == "esx" and ESX.GetPlayerData().identifier) or "unknown"
        
        if savedMasks[citizenid] then
            PlayToggleEmote(function()
                SetPedComponentVariation(ped, 1, savedMasks[citizenid].Drawable, savedMasks[citizenid].Texture, 0)
                Notify("exit_zone", "success")
            end)
        end
    end
end

function SetupZones()
    for _, zone in pairs(Config.MaskZones) do
        if zone.Blip.enabled then
            if zone.Blip.BlipZone.enabled then
                local blip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
                SetBlipHighDetail(blip, true)
                SetBlipColour(blip, zone.Blip.BlipZone.color or 1)
                SetBlipAlpha(blip, zone.Blip.BlipZone.alpha or 128)
            end

            local infoBlip = AddBlipForCoord(zone.coords)
            SetBlipSprite(infoBlip, zone.Blip.BlipId or 487)
            SetBlipDisplay(infoBlip, 4)
            SetBlipScale(infoBlip, zone.Blip.scale or 0.8)
            SetBlipColour(infoBlip, zone.Blip.color or 0)
            SetBlipAsShortRange(infoBlip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.name .. " (No Mask)")
            EndTextCommandSetBlipName(infoBlip)
        end

        if zone.Debug and zone.debugZone then
            Notify("Debug zone created: " .. zone.name, nil, nil, true)
        end
    end
end

function PlayToggleEmote(cb)
    local Ped = PlayerPedId()
    while not HasAnimDictLoaded("mp_masks@standard_car@ds@") do
        RequestAnimDict("mp_masks@standard_car@ds@")
        Wait(100)
    end
    TaskPlayAnim(Ped, "mp_masks@standard_car@ds@", "put_on_mask", 3.0, 3.0, 500, 1, 0, false, false, false)
    if cb then cb() end
end

AddEventHandler('playerDropped', function()
    local citizenid = nil
    if Framework == "qb" and QBCore then
        local Player = QBCore.Functions.GetPlayerData()
        citizenid = Player and Player.citizenid
    elseif Framework == "esx" and ESX then
        citizenid = ESX.GetPlayerData().identifier
    end
    
    if citizenid then
        savedMasks[citizenid] = nil
    end
end)

CreateThread(function()
    SetupZones()
    while true do
        CheckMaskZones()
        Wait(2000)
    end
end)

CreateThread(function()
    while true do
        if Config.Debug then
            DrawDebugZones()
        end
        Wait(0)
    end
end)