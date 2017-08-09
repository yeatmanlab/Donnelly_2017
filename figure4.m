%% Figure 4
% This script creates the scatterplots in figure 4 of Donnelly, 2017
% This analysis uses a subgroup of the participant group
% Prerequisites: preprocess.m
% Patrick Donnelly; University of Washington; August 8th, 2017

% load data and filter for summer16 group
summer16_group = sub_map('summer16');
summer16_indx = ismember(int_data.record_id, summer16_group);
summer16_data = int_data(summer16_indx, :);

% get rid of irrelevant columns
summer16_data.int_sess_cen = [];
summer16_data.int_hours_cen = [];
summer16_data.score = [];

% extract predictor variables
% intial reading score
brs_init = summer16_data.wj_brs(summer16_data.int_session == 1);
% wasi score
iq = summer16_data.wasi_fs2(summer16_data.int_session == 0);
% three subjects had multiple baselines
iq = iq(isnan(iq) == 0);
% discrepancy score
discrep = iq - brs_init;

% compute RTI variable
% use only the intervention sessions
sessions = [1 2 3 4];
sess_indx = ismember(summer16_data.int_session, sessions);
summer16_data = summer16_data(sess_indx,:);
% append centered hours variable
summer16_data.int_sess_cen = center(summer16_data, 'int_session', 'record_id');
% Calculate individual slope estimates
s = unique(summer16_data.record_id);
for sub = 1:length(s)
    sub_indx = ismember(summer16_data.record_id, s(sub));
    indiv_slopes_brs(sub,:) = polyfit(summer16_data.int_sess_cen(sub_indx, :)-1, ...
        summer16_data.wj_brs(sub_indx, :), 1);
    indiv_slopes_rf(sub,:) = polyfit(summer16_data.int_sess_cen(sub_indx, :)-1, ...
        summer16_data.wj_rf(sub_indx, :), 1);
    indiv_slopes_twre(sub,:) = polyfit(summer16_data.int_sess_cen(sub_indx, :)-1, ...
        summer16_data.twre_index(sub_indx, :), 1);
end
rti_brs = indiv_slopes_brs(:,1);
rti_rf = indiv_slopes_rf(:,1);
rti_twre = indiv_slopes_twre(:,1);
% Plot with R and P values in 3X3 grid
figure; hold;
subplot(3,3,1);
scatter(brs_init, rti_brs, 'MarkerFaceColor', ifsig(brs_init, rti_brs)); lsline; 
grid('on'); axis('tight'); 
xlabel('Initial Reading Score (BRS)'); ylabel('Growth Rate (BRS)');

subplot(3,3,2);
scatter(brs_init, rti_rf, 'MarkerFaceColor', ifsig(brs_init, rti_rf)); lsline; 
grid('on'); axis('tight'); 
xlabel('Initial Reading Score (BRS)'); ylabel('Growth Rate (RF)');

subplot(3,3,3);
scatter(brs_init, rti_twre, 'MarkerFaceColor', ifsig(brs_init, rti_twre)); lsline; 
grid('on'); axis('tight');
xlabel('Initial Reading Score (BRS)'); ylabel('Growth Rate (TOWRE)');

subplot(3,3,4);
scatter(iq, rti_brs, 'MarkerFaceColor', ifsig(iq, rti_brs)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ (WASI FS2)'); ylabel('Growth Rate (BRS)');

subplot(3,3,5);
scatter(iq, rti_rf, 'MarkerFaceColor', ifsig(iq, rti_rf)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ (WASI FS2)'); ylabel('Growth Rate (RF)');

subplot(3,3,6);
scatter(iq, rti_twre, 'MarkerFaceColor', ifsig(iq, rti_twre)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ (WASI FS2)'); ylabel('Growth Rate (TOWRE)');

subplot(3,3,7);
scatter(discrep, rti_brs, 'MarkerFaceColor', ifsig(discrep, rti_brs)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ - BRS discrepancy'); ylabel('Growth Rate (BRS)');

subplot(3,3,8);
scatter(discrep, rti_rf, 'MarkerFaceColor', ifsig(discrep, rti_rf)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ - BRS discrepancy'); ylabel('Growth Rate (RF)');

subplot(3,3,9);
scatter(discrep, rti_twre, 'MarkerFaceColor', ifsig(discrep, rti_twre)); lsline; 
grid('on'); axis('tight'); 
xlabel('IQ - BRS discrepancy'); ylabel('Growth Rate (TOWRE)');







