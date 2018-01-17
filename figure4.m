%% Figure 4
% This script creates the scatterplots in figure 4 of Donnelly, 2018
% This analysis uses a subgroup of the participant group
% Prerequisites: preprocess.m
% Patrick Donnelly; University of Washington; January 17th, 2018

% load data and filter for summer16 group
summer_group = sub_map('summer');
summer_indx = ismember(int_data.record_id, summer_group);
summer_data = int_data(summer_indx, :);

% get rid of irrelevant columns
summer_data.int_sess_cen = [];
summer_data.int_hours_cen = [];
summer_data.score = [];


% add iq score for subject 72
% find 197_BK
temp = find(ismember(summer_data.record_id, 72));
select = summer_data(temp, :);
% find first intervention session
temp2 = find(ismember(select.study_name, 0));
location = (temp(temp2));
summer_data{location,30} = 48;
summer_data{location,31} = 44;
summer_data{location,32} = 93;

% extract predictor variables
% intial reading score
brs_init = summer_data.wj_brs(summer_data.int_session == 1);
% wasi score
iq = summer_data.wasi_fs2(summer_data.int_session == 0);
iq_mr = summer_data.wasi_mr_ts(summer_data.int_session == 0);
iq_vocab = summer_data.wasi_vocab_ts(summer_data.int_session == 0);
% three subjects had multiple baselines
iq = iq(isnan(iq) == 0);
iq_mr = iq_mr(isnan(iq_mr) == 0);
iq_vocab = iq_vocab(isnan(iq_vocab) == 0);
% discrepancy score
discrep = iq - brs_init;
% rapid naming
rapid = summer_data.ctopp_rapid(summer_data.int_session == 0);
subs = unique(summer_data.record_id);
empty_scores = [];
for sub = 1:length(subs)
   sub_indx = find(ismember(summer_data.record_id(summer_data.int_session == 0), subs(sub)));
   if numel(sub_indx) == 1 && isnan(rapid(sub_indx(1)))
       empty_scores = vertcat(empty_scores, sub_indx(1));
   elseif numel(sub_indx) > 1 && ~isnan(rapid(sub_indx(2)))
       rapid(sub_indx(2)) = NaN;
   end
end
rapid(empty_scores(1)) = 82;
rapid(empty_scores(2)) = 79;
rapid = rapid(~isnan(rapid));
% Age
age = summer_data.visit_age(summer_data.int_session == 1);
% Elision
elision = summer_data.ctopp_elision_ss(summer_data.int_session == 0);
subs = unique(summer_data.record_id);
empty_scores = [];
for sub = 1:length(subs)
   sub_indx = find(ismember(summer_data.record_id(summer_data.int_session == 0), subs(sub)));
   if numel(sub_indx) == 1 && isnan(elision(sub_indx(1)))
       empty_scores = vertcat(empty_scores, sub_indx(1));
   elseif numel(sub_indx) > 1 && ~isnan(elision(sub_indx(2)))
       elision(sub_indx(2)) = NaN;
   end
end
elision(empty_scores(1)) = 9;
elision(empty_scores(2)) = 6;
elision = elision(~isnan(elision));


% compute RTI variable
% use only the intervention sessions
sessions = [1 2 3 4];
sess_indx = ismember(summer_data.int_session, sessions);
summer_data = summer_data(sess_indx,:);
% append centered hours variable
summer_data.int_sess_cen = center(summer_data, 'int_session', 'record_id');
% Calculate individual slope estimates
s = unique(summer_data.record_id);
for sub = 1:length(s)
    sub_indx = ismember(summer_data.record_id, s(sub));
    indiv_slopes_brs(sub,:) = polyfit(summer_data.int_sess_cen(sub_indx, :)-1, ...
        summer_data.wj_brs(sub_indx, :), 1);
    indiv_slopes_rf(sub,:) = polyfit(summer_data.int_sess_cen(sub_indx, :)-1, ...
        summer_data.wj_rf(sub_indx, :), 1);
    indiv_slopes_twre(sub,:) = polyfit(summer_data.int_sess_cen(sub_indx, :)-1, ...
        summer_data.twre_index(sub_indx, :), 1);
end
rti_brs = indiv_slopes_brs(:,1);
rti_rf = indiv_slopes_rf(:,1);
rti_twre = indiv_slopes_twre(:,1);
% Plot with R and P values in 3X3 grid
figure; hold;
subplot(3,3,1);
scatter(brs_init, rti_brs, 15, 'MarkerFaceColor', ifsig(brs_init, rti_brs)); lsline; 
grid('on'); xlim([50 120]); ylim([-2 12]); xticks([50 60 70 80 90 100 110 120]);
ylabel('Growth Rate (BRS)');

subplot(3,3,2);
scatter(brs_init, rti_rf, 15, 'MarkerFaceColor', ifsig(brs_init, rti_rf)); lsline; 
grid('on'); xlim([50 120]); ylim([-2 8]); xticks([50 60 70 80 90 100 110 120]);
xlabel('Initial Reading Score (BRS)'); ylabel('Growth Rate (RF)');

subplot(3,3,3);
scatter(brs_init, rti_twre, 15, 'MarkerFaceColor', ifsig(brs_init, rti_twre)); lsline; 
grid('on'); xlim([50 120]); ylim([-2 8]); xticks([50 60 70 80 90 100 110 120]);
ylabel('Growth Rate (TOWRE)');

subplot(3,3,4);
scatter(iq, rti_brs, 15, 'MarkerFaceColor', ifsig(iq, rti_brs)); lsline; 
grid('on'); xlim([70 130]); ylim([-2 12]); xticks([70 80 90 100 110 120 130]); 
ylabel('Growth Rate (BRS)');

subplot(3,3,5);
scatter(iq, rti_rf, 15, 'MarkerFaceColor', ifsig(iq, rti_rf)); lsline; 
grid('on'); xlim([70 130]); ylim([-2 8]); xticks([70 80 90 100 110 120 130]);
xlabel('IQ (WASI FS2)'); ylabel('Growth Rate (RF)');

subplot(3,3,6);
scatter(iq, rti_twre, 15, 'MarkerFaceColor', ifsig(iq, rti_twre)); lsline; 
grid('on'); xlim([70 130]); ylim([-2 8]); xticks([70 80 90 100 110 120 130]);
ylabel('Growth Rate (TOWRE)');

subplot(3,3,7);
scatter(discrep, rti_brs, 15, 'MarkerFaceColor', ifsig(discrep, rti_brs)); lsline; 
grid('on'); xlim([-10 50]); ylim([-2 12]); xticks([-10 0 10 20 30 40 50]);
ylabel('Growth Rate (BRS)');

subplot(3,3,8);
scatter(discrep, rti_rf, 15, 'MarkerFaceColor', ifsig(discrep, rti_rf)); lsline; 
grid('on'); xlim([-10 50]); ylim([-2 8]); xticks([-10 0 10 20 30 40 50]); 
xlabel('IQ - BRS discrepancy'); ylabel('Growth Rate (RF)');

subplot(3,3,9);
scatter(discrep, rti_twre, 15, 'MarkerFaceColor', ifsig(discrep, rti_twre)); lsline; 
grid('on'); xlim([-10 50]); ylim([-2 8]); xticks([-10 0 10 20 30 40 50]);
ylabel('Growth Rate (TOWRE)');







