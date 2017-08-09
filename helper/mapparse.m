% Reads in an xlsx file and returns a container map structure
% Patrick Donnelly; University of Washington
function [sub_map] = mapparse(file);

tmp = readtable(file);
keys = []; values = [];
keys = unique(tmp.sub_type);
values = cell([numel(keys),1]);
for each = 1:length(tmp.record_id)
    for key = 1:length(keys)
        if strcmp(tmp.sub_type(each), keys(key))
            values{key} = horzcat(values{key}, tmp.record_id(each));
        end
    end
end
sub_map = containers.Map(keys,values);
end