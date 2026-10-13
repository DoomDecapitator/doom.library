# doom.library:api/update — merge data into player's storage
# Call: function doom.library:api/update with storage doom.library:ctx _
# Prereq: _.idx set by ensure, _.data set with fields to merge

$data modify storage doom.library:io input append value {index:$(idx)}
data modify storage doom.library:io input[-1].data set from storage doom.library:ctx _.data
data modify storage doom.library:io input[-1].mode set value "merge"
