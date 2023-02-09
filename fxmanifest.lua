fx_version 'cerulean'
game 'gta5'

description 'lmao'
version '1.0.0'

client_scripts {
	'client/main.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua',
}

lua54 'yes'