# 🎭 Auto Mask Remover | 🟢 Green Zone System

[![License](https://img.shields.io/github/license/9ORISA/Qs-AutoMaskRomover?color=blue)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/9ORISA/Qs-AutoMaskRomover)](https://github.com/9ORISA/Qs-AutoMaskRomover/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/9ORISA/Qs-AutoMaskRomover)](https://github.com/9ORISA/Qs-AutoMaskRomover/issues)

An advanced and customizable **Green Zone System** that automatically removes player masks inside designated safe zones. Designed for performance and flexibility with multi-language support.

![QSfiveM](https://github.com/user-attachments/assets/497cc1b4-bc46-4c7c-ba95-4b3e64306b25)


## ✨ Features

- 🚫 **Auto-Remove Masks** in designated zones
- 🌐 **Multi-language Support** (12+ languages included)
- 📍 **Visual Map Blips** for each safe zone
- 🛠️ **Fully Customizable** zones and notifications
- 🔄 **Works with any mask system**
- 🐞 **Developer debug mode** with zone visualization
- 🏗️ **Framework Support**: QBCore, ESX, or standalone

## ⚙️ Requirements

- FiveM server
- [Optional] QBCore or ESX framework (works standalone too)

## 🚀 Installation

1. Download the latest release
2. Extract to your `resources` folder
3. Add `ensure Qs-AutoMaskRomover` to your server.cfg
4. Configure `config.lua` to your needs

## 🛠 Configuration

Edit `config.lua` to customize:

```lua
Config = {
    Debug = false, -- Enable debug mode
    Notify = true, -- Enable notifications
    
    DefaultMask = {
        Drawable = 1,  -- Default mask when none saved
        Texture = 0    -- Default texture
    },
    
    MaskZones = {
        {
            name = "City Hall",
            coords = vector3(252.0, -359.0, 44.0),
            radius = 50.0,
            notifyEnterExit = true,
            Blip = {
                enabled = true,
                BlipId = 487,
                scale = 0.8,
                color = 2,
                BlipZone = {
                    enabled = true,
                    color = 2,
                    alpha = 100
                }
            },
            debugZone = true,
            debugColor = {r = 0, g = 255, b = 0, a = 100}
        }
        -- Add more zones as needed
    }
}
