%% Figure5
% This creates the median split figure in Donnelly, 2018
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

% Create a table with the wj_brs scores arranged by session
s = unique(summer_data.record_id);
session_1 = summer_data.wj_brs(summer_data.int_session == 1);
session_2 = summer_data.wj_brs(summer_data.int_session == 2);
session_3 = summer_data.wj_brs(summer_data.int_session == 3);
session_4 = summer_data.wj_brs(summer_data.int_session == 4);
tmp = table(s, session_1, session_2, session_3, session_4);

m = median(session_1);
s_low = s(session_1 < m);
m_low1 = session_1(session_1 < m);
m_low2 = session_2(session_1 < m);
m_low3 = session_3(session_1 < m);
m_low4 = session_4(session_1 < m);
tmp_low = table(s_low, m_low1, m_low2, m_low3, m_low4);

s_high = s(session_1 >= m);
m_high1 = session_1(session_1 >= m);
m_high2 = session_2(session_1 >= m);
m_high3 = session_3(session_1 >= m);
m_high4 = session_4(session_1 >= m);
tmp_high = table(s_high, m_high1, m_high2, m_high3, m_high4);

x = [1 2 3 4];
y_low = [nanmean(m_low1) nanmean(m_low2) nanmean(m_low3) nanmean(m_low4)];
se_low = [sem(m_low1) sem(m_low2) sem(m_low3) sem(m_low4)];
y_high = [nanmean(m_high1) nanmean(m_high2) nanmean(m_high3) nanmean(m_high4)];
se_high = [sem(m_high1) sem(m_high2) sem(m_high3) sem(m_high4)];
figure; hold;
plot(x, y_low, '-o', 'Color', 'r', 'MarkerFaceColor', 'r', ...
     'MarkerSize', 6, 'MarkerEdgeColor', 'r');
plot(x, y_high, '-o', 'Color', 'b', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 6, 'MarkerEdgeColor', 'b');
errorbar(x, y_low, se_low, '.k', 'Color', 'r', 'LineWidth', 2);
errorbar(x, y_high, se_high, '.k', 'Color', 'b', 'LineWidth', 2);

%Format Plot
ax = gca;
ax.XLim = [0.9 4.1];
ax.YLim = [50 110];
ax.XAxis.TickValues = [1 2 3 4];
xlabel('Session'); ylabel('Standard Score');
title('Median Split WJ BRS');
axis('square');