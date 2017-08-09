%% Supplementary Figure 1
% function to create supplementary figure 1 from Donnelly, et al (2017)
% prerequisites: run the preprocess.m function
% Patrick Donnelly; University of Washington; August 8th, 2017

% Specify sessions of interest
sessions = [0 1 2 3 4];
% Make the time variable categorical
cntrl_data.int_session = categorical(cntrl_data.int_session);
% Gather stats
composites = {'WJ BRS', 'WJ RF', 'TWRE INDEX'};
lme_brs = fitlme(cntrl_data, 'wj_brs ~ 1 + int_session + (1|record_id) + (int_session - 1|record_id)');
lme_rf = fitlme(cntrl_data, 'wj_rf ~ 1 + int_session + (1|record_id) + (int_session - 1|record_id)');
lme_twre = fitlme(cntrl_data, 'twre_index ~ 1 + int_session + (1|record_id) + (int_session - 1|record_id)');
% Create figure
figure; hold;
dmap = lines; dmap = vertcat(dmap(2,:), dmap(1,:), dmap(5,:));
% Organize data
% initialize estimate arrays
brs_est = lme_brs.Coefficients.Estimate;
rf_est = lme_rf.Coefficients.Estimate;
twre_est = lme_twre.Coefficients.Estimate;
% gather standard errors and p values
brs_se = lme_brs.Coefficients.SE;
brs_p = lme_brs.Coefficients.pValue;
rf_se = lme_rf.Coefficients.SE;
rf_p = lme_rf.Coefficients.pValue;
twre_se = lme_twre.Coefficients.SE;
twre_p = lme_twre.Coefficients.pValue;
% extend intercept to components of estimates
for sess = 2:length(sessions)
    brs_est(sess, 1) = (brs_est(1,1) + brs_est(sess, 1));
    rf_est(sess, 1) = (rf_est(1,1) + rf_est(sess, 1));
    twre_est(sess, 1) = (twre_est(1,1) + twre_est(sess, 1));
end
% plot
plot(sessions', brs_est, '-o', 'Color', dmap(1,:), 'MarkerFaceColor', dmap(1,:), 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', dmap(1,:));
plot(sessions', rf_est, '-o', 'Color', dmap(2,:), 'MarkerFaceColor', dmap(2,:), 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', dmap(2,:));
plot(sessions', twre_est, '-o', 'Color', dmap(3,:), 'MarkerFaceColor', dmap(3,:), 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', dmap(3,:));
% add error bars
errorbar(sessions', brs_est, brs_se, '.k', 'Color', dmap(1,:), 'LineWidth', 2);
errorbar(sessions', rf_est, rf_se, '.k', 'Color', dmap(2,:), 'LineWidth', 2);
errorbar(sessions', twre_est, twre_se, '.k', 'Color', dmap(3,:), 'LineWidth', 2);
%Format Plot
ax = gca;
ax.XLim = [-0.1 4.1];
ax.YLim = [70 100];
ax.XAxis.TickValues = [0 1 2 3 4];
xlabel('Session'); ylabel('Standard Score');
title('Growth in Reading Skill');
grid('on');
legend(composites, 'Location', 'eastoutside');