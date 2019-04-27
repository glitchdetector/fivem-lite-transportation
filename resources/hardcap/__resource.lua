resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

resource_type 'map' { name = 'Los Santos', gameTypes = { fivem = true } }
map 'map.lua'

-- Baseevents
client_script 'baseevents/deathevents.lua'
client_script 'baseevents/vehiclechecker.lua'
server_script 'baseevents/server.lua'

-- Hardcap
client_script 'hardcap/client.lua'
server_script 'hardcap/server.lua'

-- Map Manager
client_scripts {
    "mapmanager/mapmanager_client.lua",
    "mapmanager/mapmanager_shared.lua"
}

server_scripts {
    "mapmanager/mapmanager_server.lua",
    "mapmanager/mapmanager_shared.lua"
}

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"

-- Rconlog
client_script 'rconlog/rconlog_client.lua'
server_script 'rconlog/rconlog_server.lua'

-- Sessionmanager
server_script 'sessionmanager/server/host_lock.lua'

-- Spawnmanager
client_script 'spawnmanager/spawnmanager.lua'

export 'getRandomSpawnPoint'
export 'spawnPlayer'
export 'addSpawnPoint'
export 'removeSpawnPoint'
export 'loadSpawns'
export 'setAutoSpawn'
export 'setAutoSpawnCallback'
export 'forceRespawn'

server_scripts {
    'framework/player.lua',
    'framework/server.lua',
    'framework/money.lua',
    'framework/skills.lua',
    'framework/shop.lua',
}

server_export 'GiveMoney'
server_export 'TakeMoney'
server_export 'SetMoney'
server_export 'GetMoney'
server_export 'TryPayment'
server_export 'VerifyPlayerData'
server_export 'SetPlayerData'
server_export 'LoadPlayerData'
server_export 'SavePlayerData'
server_export 'ClearPlayerData'
server_export 'GetPlayerData'
server_export 'BanPlayer'
server_export 'KickPlayer'
server_export 'IsAdmin'
server_export 'GetExp'
server_export 'GiveExp'
server_export 'TakeExp'
server_export 'SetExp'

client_scripts {
    'framework/cl_spawn.lua'
}

files {
    'loadscreen/index.html',
    'loadscreen/bg.png',
}
loadscreen 'loadscreen/index.html'

-- Chat
ui_page 'chat/html/index.html'

client_script 'chat/cl_chat.lua'
server_script 'chat/sv_chat.lua'

files {
    'chat/html/index.html',
    'chat/html/index.css',
    'chat/html/config.default.js',
    'chat/html/config.js',
    'chat/html/App.js',
    'chat/html/Message.js',
    'chat/html/Suggestions.js',
    'chat/html/vendor/vue.2.3.3.min.js',
    'chat/html/vendor/flexboxgrid.6.3.1.min.css',
    'chat/html/vendor/animate.3.5.2.min.css',
    'chat/html/vendor/latofonts.css',
    'chat/html/vendor/fonts/LatoRegular.woff2',
    'chat/html/vendor/fonts/LatoRegular2.woff2',
    'chat/html/vendor/fonts/LatoLight2.woff2',
    'chat/html/vendor/fonts/LatoLight.woff2',
    'chat/html/vendor/fonts/LatoBold.woff2',
    'chat/html/vendor/fonts/LatoBold2.woff2',
}

file 'chat/style.css'
file 'chat/shadow.js'

chat_theme 'gtao' {
    styleSheet = 'chat/style.css',
    script = 'chat/shadow.js',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}
