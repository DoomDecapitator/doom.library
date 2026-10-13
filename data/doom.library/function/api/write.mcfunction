# doom.library:api/write — write data to player's storage
# Call: function doom.library:api/write with storage doom.library:ctx _
# Prereq: _.idx set by ensure, _.data set with values to write

$data modify storage doom.library:io input append value {index:$(idx)}
data modify storage doom.library:io input[-1].data set from storage doom.library:ctx _.data
