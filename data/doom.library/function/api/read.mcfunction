# doom.library:api/read — read player data by index
# Call: function doom.library:api/read with storage doom.library:ctx _
# Prereq: _.idx set by ensure
# Output: output[-1].data (caller should read immediately before next tick)

$data modify storage doom.library:io output set value [{index:$(idx)}]
$data modify storage doom.library:io output[-1].data set from storage doom.library:io players.data.$(idx)
