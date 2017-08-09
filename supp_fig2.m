%% Supplementary Figure 2
% creates a histogram of the linear effects across all measures for control
% data
% prerequisites: preprocess.m
% Patrick Donnelly; University of Washington; August 8th, 2017


% define measures, math measures were not collected for all control subs
names = {'WJ LWID', 'WJ WA', 'WJ BRS', 'WJ OR', 'WJ SRF', 'WJ RF', 'TOWRE SWE', ...
    'TOWRE PDE', 'TWRE INDEX'};
% gather lme stats in struct
stats = struct;
stats(1).lme = fitlme(cntrl_data, 'wj_lwid_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(2).lme = fitlme(cntrl_data, 'wj_wa_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(3).lme = fitlme(cntrl_data, 'wj_brs ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(4).lme = fitlme(cntrl_data, 'wj_or_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(5).lme = fitlme(cntrl_data, 'wj_srf_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(6).lme = fitlme(cntrl_data, 'wj_rf ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(7).lme = fitlme(cntrl_data, 'twre_swe_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(8).lme = fitlme(cntrl_data, 'twre_pde_ss ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
stats(9).lme = fitlme(cntrl_data, 'twre_index ~ 1 + cntrl_hours_cen + (1|record_id) + (cntrl_hours_cen - 1|record_id)');
% place estimates, standard errors, and p values in table
for test = 1:length(names)
    linear_data(test, :) = table(names(test), stats(test).lme.Coefficients.Estimate(2), stats(test).lme.Coefficients.SE(2));
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