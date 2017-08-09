%% Figure 3a
% creates histogram of quadratic effects of all measures using LME model
% Prerequisites: preprocess.m
% Patrick Donnelly; University of Washington; August 8th, 2017
for test = 1:length(names)
    quad_data(test, :) = table(stats(test).name, stats(test).lme_quad.Coefficients.Estimate(3), stats(test).lme_quad.Coefficients.SE(3));
    quad_data.Properties.VariableNames = {'test_name', 'growth', 'se'};
end
% plot
figure; hold;
h = bar(quad_data.growth, 'FaceColor', 'w', 'EdgeColor', 'k');
errorbar(quad_data.growth, quad_data.se, 'kx');
% add p value astrisks
for test = 1:length(names)
    if stats(test).lme_quad.Coefficients.pValue(3) <= 0.001
        text(test, quad_data.growth(test) + quad_data.se(test) + .002, ...
            '**', 'HorizontalAlignment', 'center', 'Color', 'b');
    elseif stats(test).lme_quad.Coefficients.pValue(3) <= 0.05
        text(test,quad_data.growth(test) + quad_data.se(test) + .002, ...
            '*', 'HorizontalAlignment', 'center', 'Color', 'b');
    end
end
% Format
ylabel('Growth Estimate'); xlabel('Test Name');
ax = gca; axis('tight');
ax.XTick = 1:length(names);
ax.XTickLabel = names;
ax.XTickLabelRotation = 45;
title('Quadratic Growth Estimate by Test');


%% Figure 3b
% creates histogram of cubic effects of all measures using LME model
for test = 1:length(names)
    cube_data(test, :) = table(stats(test).name, stats(test).lme_cube.Coefficients.Estimate(4), stats(test).lme_cube.Coefficients.SE(4));
    cube_data.Properties.VariableNames = {'test_name', 'growth', 'se'};
end
% plot
figure; hold;
h = bar(cube_data.growth, 'FaceColor', 'w', 'EdgeColor', 'k');
errorbar(cube_data.growth, cube_data.se, 'kx');
% add p value astrisks
for test = 1:length(names)
    if stats(test).lme_cube.Coefficients.pValue(4) <= 0.001
        text(test, cube_data.growth(test) + cube_data.se(test) + .002, ...
            '**', 'HorizontalAlignment', 'center', 'Color', 'b');
    elseif stats(test).lme_cube.Coefficients.pValue(4) <= 0.05
        text(test,cube_data.growth(test) + cube_data.se(test) + .002, ...
            '*', 'HorizontalAlignment', 'center', 'Color', 'b');
    end
end
% Format
ylabel('Growth Estimate'); xlabel('Test Name');
ax = gca; axis('tight');
ax.XTick = 1:length(names);
ax.XTickLabel = names;
ax.XTickLabelRotation = 45;
title('Cubic Growth Estimate by Test');

