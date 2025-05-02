Framework = ""
QBCore, ESX = nil, nil

Config = {
    Debug = false,
    Notify = true,
    DefaultMask = {drawable = 1, texture = 0},
    MaskZones = {
        {
            name = "Bank",
            coords = vector3(-2966.16, 237.62, 37.07),
            radius = 20.0,
            Blip = {
                enabled = true, 
                BlipId = 487, -- or 0
                color = 0, 
                scale = 0.8,
                BlipZone = {
                    enabled = true, 
                    color = 2,
                    alpha = 128 
                }
            },
            notifyEnterExit = true,
            debugZone = false,
            debugColor = {r = 0, g = 255, b = 0, a = 70}
        },
        {
            name = "Police Station",
            coords = vector3(428.23, -981.12, 30.71),
            radius = 25.0,
            Blip = {
                enabled = true, 
                BlipId = 487, -- or 0
                color = 0, 
                scale = 0.8,
                BlipZone = {
                    enabled = true, 
                    color = 2,
                    alpha = 128 
                }
            },
            notifyEnterExit = true,
            debugZone = false,
            debugColor = {r = 0, g = 255, b = 0, a = 70}
        }
    }
}

Lang = {} 


-- Blips & colors >
--https://docs.fivem.net/docs/game-references/blips/