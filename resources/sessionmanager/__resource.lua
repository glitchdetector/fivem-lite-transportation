resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Server bridge
server_script 'server.lua'

server_scripts {
    'scripts/dependencies/sv_misc.lua',
    'scripts/dependencies/logger.lua',
    'scripts/dependencies/sh_vehicles.lua',
}

-- Client Dep
client_scripts {
    'scripts/dependencies/logger.lua',
    'scripts/dependencies/paradise-area.lua',
    'scripts/dependencies/minimapper.lua',
    'scripts/dependencies/dep_locale.lua',
    'scripts/dependencies/dep_hud.lua',
    'scripts/dependencies/lists.lua',
    'scripts/dependencies/simplefuel.lua',
    'scripts/dependencies/warmenu.lua',
    'scripts/dependencies/misc.lua',
    'scripts/dependencies/blip_info.lua',
    'scripts/dependencies/instruction_buttons.lua',
    'scripts/dependencies/sh_vehicles.lua',
    'scripts/dependencies/dep_kvp.lua',
    'scripts/dependencies/dep_minimap.lua',
    'scripts/dependencies/dep_discord.lua',
}

-- Shared Common
shared_scripts {
    'scripts/common/sh_utils.lua',
    'scripts/poi/sh_poi.lua',
    'scripts/dependencies/sh_vehcols.lua',
}

-- Shared Client
client_scripts {
    'scripts/common/cl_data.lua',
    'scripts/cl_spawn.lua',
    'scripts/cl_vehicle.lua',
    'scripts/common/cl_config.lua',
    'scripts/common/cl_esc.lua',
    'scripts/common/cl_hud.lua',
    'scripts/common/cl_blips.lua',
    'scripts/common/cl_menu.lua',
    'scripts/common/cl_iterator.lua',
    'scripts/common/cl_utils.lua',
    'scripts/common/cl_admin.lua',
    'scripts/common/cl_nocol.lua',
    'scripts/common/cl_money.lua',
    'scripts/common/cl_discord.lua',
    'scripts/poi/poi_delivery.lua',
    'scripts/poi/poi_service.lua',
    'scripts/poi/poi_dealership.lua',
    'scripts/poi/poi_airport.lua',
    'scripts/poi/poi_seaport.lua',
    'scripts/poi/poi_fuel.lua',
}

server_scripts {
    'scripts/common/sv_admin.lua',
    'scripts/common/sv_shop.lua',
    'scripts/poi/sv_poi.lua',
}

-- Jobs
shared_script 'scripts/jobs/sh_job.lua'
server_script 'scripts/jobs/sv_job.lua'
client_script 'scripts/jobs/cl_job.lua'

-- Trucking
shared_script 'scripts/jobs/trucking/sh_trucking.lua'
server_script 'scripts/jobs/trucking/sv_trucking.lua'
client_script 'scripts/jobs/trucking/cl_trucking.lua'
