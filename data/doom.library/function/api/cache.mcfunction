# doom.library:api/cache — save/update cached player data with timestamp
# Call: function doom.library:api/cache with storage doom.library:ctx _
# Prereq: _.idx set, _.cache_key set, _.cache_data set

# Store data with timestamp
$data modify storage doom.library:io players.data.$(idx).CACHE.$(cache_key) set value {}
$data modify storage doom.library:io players.data.$(idx).CACHE.$(cache_key).data set from storage doom.library:ctx _.cache_data
$execute store result storage doom.library:io players.data.$(idx).CACHE.$(cache_key).timestamp int 1 run time query gametime
