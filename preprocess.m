%% PreProcess script for Donnelly, 2018 summer intervention study
% This script reads in the data, organized by group
% *Groups:* intervention group, dx control group, typical control group
% *Data:* there are two xls workbooks stored in the data folder in this
% repository - lmb_data with the raw data exported from our database,and
% lmb_config with the group identifiers for implementation as a container
% map object
% *helper functions:* mapparse (a function that intializes the container
% map object for grouping data by subject groups); center (a function for
% demeaning variables, for use in the linear mixed effects model; ifsig (a
% function that codes plotted data based on significance)
% Patrick Donnelly; University of Washington; January 17th, 2018
%% Read in files
% Make sure your present working directory is the Donnelly_18 repo
lmb_data = readtable('data/lmb_data.xlsx');
sub_map = mapparse('data/lmb_config.xlsx'); %mapparse initialized container map object
%% condense data table to necessary information
int_group = sub_map('int_include'); % intervention group
cntrl_group = sub_map('cntrl_dx'); % dx control group
indx = ismember(lmb_data.record_id, int_group);
cntrl_indx = ismember(lmb_data.record_id,cntrl_group);
all_indx = ismember(lmb_data.record_id,sub_map('all'));
int_data = lmb_data(indx,:);
cntrl_data = lmb_data(cntrl_indx,:);
all_data = lmb_data(all_indx,:);
%% Select sessions of interest
cntrl_sess_names = [0 11 12 13 14]; % based on study name variable coding in redcap
int_sess_names = [0 1 2 3 4];
all_sess_names = [1 2 3 4 11 12 13 14];
case_cntrl_sess_names = [1 2 3 4 11 12 13 14];
%% consolidate data for case-control analysis
% condense data table to necessary information
case_cntrl_group = horzcat(int_group,cntrl_group); % Concatenate conrol and intervention subs
case_cntrl_indx = ismember(lmb_data.record_id,case_cntrl_group);
case_cntrl_data = lmb_data(case_cntrl_indx,:);
% revise case cntrl data
case_cntrl_sess_name_indx = ismember(case_cntrl_data.study_name, case_cntrl_sess_names);
case_cntrl_data = case_cntrl_data(case_cntrl_sess_name_indx, :);
% append categorical variable to combined data
[m, n] = size(case_cntrl_data);
case_cntrl_data.group = zeros(m, 1);
for row = 1:m
   if ismember(case_cntrl_data.study_name(row), [1 2 3 4])
       case_cntrl_data.group(row) = 1;
   elseif ismember(case_cntrl_data.study_name(row), [11 12 13 14])
       case_cntrl_data.group(row) = 0;
   end
end

% revise int data
% 72 for int data should have different baseline session:
% find 197_BK
temp = find(ismember(int_data.record_id, 72));
select = int_data(temp, :);
% find first intervention session
temp2 = find(ismember(select.study_name, 1));
location = (temp(temp2) - 1);
int_data{location,3} = 0; int_data{location,9} = 0; int_data{location,10} = 0;
temp3 = find(ismember(select.study_name, 0)); location2 = temp(temp3); 
int_data(location2,:) = [];
% narrow down to sessions of interest
int_sess_name_indx = ismember(int_data.study_name,int_sess_names);
int_data = int_data(int_sess_name_indx, :);
%% Perform LME model fit
% center the time variables and append to table
int_data.int_sess_cen = center(int_data, 'int_session', 'record_id');
int_data.int_hours_cen = center(int_data, 'int_hours', 'record_id');
cntrl_data.int_sess_cen = center(cntrl_data, 'int_session', 'record_id');
cntrl_data.cntrl_hours_cen = center(cntrl_data, 'int_hours', 'record_id');
cntrl_data.cntrl_days_cen = center(cntrl_data, 'int_time', 'record_id');
% center the time variables and append to table
case_cntrl_data.int_sess_cen = center(case_cntrl_data, 'int_session', 'record_id');
case_cntrl_data.int_hours_cen = center(case_cntrl_data, 'int_hours', 'record_id');
case_cntrl_data.int_days_cen = center(case_cntrl_data, 'int_time', 'record_id');
% name tests of interest and their associated names for future plotting 
tests = {'wj_lwid_ss','wj_wa_ss','wj_brs','wj_or_ss','wj_srf_ss',...
    'wj_rf','twre_swe_ss','twre_pde_ss','twre_index','wj_mff_ss',...
    'wj_calc_ss','wj_mcs'}; 
names = {'WJ LWID', 'WJ WA', 'WJ BRS', 'WJ OR', 'WJ SRF', 'WJ RF', 'TOWRE SWE', ...
    'TOWRE PDE', 'TWRE INDEX', 'WJ MFF', 'WJ CALC', 'WJ MCS'};
location = find(ismember(lmb_data.Properties.VariableNames, tests));
% initialize data structure
stats = struct; cntrl_stats = struct; inter_stats = struct;
% loop over tests and create data structure with linear, quadratic, and
% cubic models; using a centered time variable (intervention hours)
for test = 1:length(tests)
    loc = location(test);
    int_data.score = int_data{:,loc};
    cntrl_data.score = cntrl_data{:,loc};
    case_cntrl_data.score = case_cntrl_data{:,loc};
    stats(test).name = names(test);
    cntrl_stats(test).name = names(test);
    inter_stats(test).name = names(test);
    % linear model fit
    stats(test).lme = fitlme(int_data, 'score ~ 1 + int_hours_cen + (1|record_id) + (int_hours_cen - 1|record_id)');
    %cntrl_stats(test).lme = fitlme(cntrl_data, 'score ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
    % quadratic model fit
    stats(test).lme_quad = fitlme(int_data, 'score ~ 1 + int_hours_cen^2 + (1|record_id) + (int_hours_cen - 1|record_id)');
    % cubic model fit
    stats(test).lme_cube = fitlme(int_data, 'score ~ 1 + int_hours_cen^2 + int_hours_cen^3 + (1|record_id) + (int_hours_cen - 1|record_id)');
    % interaction model fit for case_cntrl data
    inter_stats(test).lme_int = fitlme(case_cntrl_data, 'score ~ 1 + int_days_cen + int_days_cen*group + (1|record_id) + (int_days_cen - 1|record_id)');
end


