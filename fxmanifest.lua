fx_version "cerulean"

description "Status Tracking for Desync RP"
author "Funk"
version '1.0.0'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
  '@ox_core/lib/init.lua'
}


client_script "client/**/*"
server_script "server.lua"
