fx_version 'cerulean'
game 'gta5'
author 'Savage'
description 'Blueprints Reward System'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'config.lua',
	"@ox_lib/init.lua",
}

client_scripts {
	'client/main.lua',
}

server_scripts {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua'
}

escrow_ignore {
    'config.lua'
}
