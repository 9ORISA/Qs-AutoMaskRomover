fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Qorisa'
description 'Auto Remove Mask In Green Zones with peds'
version '1.1.0'

shared_script {
	'config.lua',
	'language.lua'
}

client_scripts {
    'client.lua',
}

dependencies {
	'/gameBuild:2060' 
}

