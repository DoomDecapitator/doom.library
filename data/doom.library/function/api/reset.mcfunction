# doom.library:api/reset — reset all data for a player
# Call: function doom.library:api/reset with storage doom.library:ctx _
# Prereq: _.idx set by ensure

$data modify storage doom.library:io players.data.$(idx) set value {}
