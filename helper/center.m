%% function to center (demean) a data column based on a grouping variable
%        Designed for use with longitudinal data where demeaning occurs at
%        the level of the group
% Patrick M. Donnelly; University of Washington; July 21, 2017
% Input: data --> data set in the form of a table with headings
%        column --> string, name of column to be centered
%        group --> string, name of column on which to group
% Output: data --> array of centered data
function [centered] = center(data, column, group)
names = data.Properties.VariableNames;
col_loc = find(strcmp(column, names));
col = table2array(data(:, col_loc));
grp_loc = find(strcmp(group, names));
grp = table2array(data(:, grp_loc));
grp_unique = table2array(unique(data(:,grp_loc)));
centered = zeros(numel(data(:, grp_loc)),1);

for g = 1:numel(grp_unique)
   g_indx = find(grp_unique(g) == grp);
   for c = 1:length(g_indx)
      centered(g_indx(c)) = col(g_indx(c)) - nanmean(col(g_indx));
   end
end

end

