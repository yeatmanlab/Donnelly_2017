%% Figure 1
% function to create figure 1 from Donnelly, et al (2017)
% prerequisites: run the preprocess.m function
% Patrick Donnelly; University of Washington; August 8th, 2017
%% Figure 1a
% Specify sessions of interest
sessions = [0 1 2 3 4];
% Make the time variable categorical
int_data.int_session_cat = categorical(int_data.int_session);
% Gather stats
composites = {'WJ BRS', 'WJ RF', 'TWRE INDEX'};
lme_brs = fitlme(int_data, 'wj_brs ~ 1 + int_session_cat + (1|record_id) + (int_session_cat - 1|record_id)');
lme_rf = fitlme(int_data, 'wj_rf ~ 1 + int_session_cat + (1|record_id) + (int_session_cat - 1|record_id)');
lme_twre = fitlme(int_data, 'twre_index ~ 1 + int_session_cat + (1|record_id) + (int_session_cat - 1|record_id)');
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

%% Figure 1b
% plots a longitudinal plot of the basic reading skills measure
% with a trend line extracted from the linear mixed effects model
figure; hold;
plot(int_data.int_hours, int_data.wj_brs, '-k');   
axis('tight');
% format the plot nicely
ax = gca; ax.XLim = [0 160]; ax.YLim = [55 125];
ylabel('WJ BRS'); xlabel('Hours of Intervention');
ax.XAxis.TickValues = [0 40 80 120 160];
ax.YAxis.TickValues = [40 60 80 100 120 140];
grid('on')
% Add linear line of best fit
% fit model using hours as the time variable
lme_brs = fitlme(int_data, 'wj_brs ~ 1 + int_hours_cen + (1|record_id) + (int_hours_cen - 1|record_id)');
plot(ax.XAxis.TickValues,polyval(flipud(lme_brs.Coefficients.Estimate),ax.XAxis.TickValues),'--b','linewidth',3);

%% Figure 1c
% creates a histogram of the linear effects across all measures
% place estimates, standard errors, and p values in table
for test = 1:length(names)
    linear_data(test, :) = table(stats(test).name, stats(test).lme.Coefficients.Estimate(2), stats(test).lme.Coefficients.SE(2));
    linear_data.Properties.VariableNames = {'test_name', 'growth', 'se'};
end
% plot
figure; hold;
h = bar(linear_data.growth, 'FaceColor', 'w', 'EdgeColor', 'k');
errorbar(linear_data.growth, linear_data.se, 'kx');
% add p value astrisks
for test = 1:length(names)
    if stats(test).lme.Coefficients.pValue(2) <= 0.001
        text(test, linear_data.growth(test) + linear_data.se(test) + .002, ...
            '**', 'HorizontalAlignment', 'center', 'Color', 'b');
    elseif stats(test).lme.Coefficients.pValue(2) <= 0.05
        text(test,linear_data.growth(test) + linear_data.se(test) + .002, ...
            '*', 'HorizontalAlignment', 'center', 'Color', 'b');
    end
end
% Format
ylabel('Growth Estimate'); xlabel('Test Name');
ax = gca; axis('tight');
ax.XTick = 1:length(names);
ax.XTickLabel = names;
ax.XTickLabelRotation = 45;
title('Linear Growth Estimate by Test');