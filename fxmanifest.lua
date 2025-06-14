fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Sam'
description 'Drug running script | By Sam Scripts'
version '1.0'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',

}

client_script 'client/main.lua'

server_script {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua'
}
