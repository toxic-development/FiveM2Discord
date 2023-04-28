fx_version 'cerulean'
game 'gta5'

name 'FiveM2Discord'
version '0.0.4'

author 'Toxic Dev'
description 'Discord Bot that allows you to have server notifications sent to discord!'
repository 'https://github.com/NARC-FiveM/Resources/discord-logs'

shared_script 'settings.lua'

client_scripts {
	'client/weapons.lua',
	'client/c_main.lua',
}

server_scripts {
	'server/s_config.lua',
	'server/s_main.lua',
}
