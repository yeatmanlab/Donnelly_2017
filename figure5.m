%% Figure5
% This creates the median split figure in Donnelly, 2017
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

% Create a table with the wj_brs scores arranged by session
s = unique(summer16_data.record_id);
session_1 = summer16_data.wj_brs(summer16_data.int_session == 1);
session_2 = summer16_data.wj_brs(summer16_data.int_session == 2);
session_3 = summer16_data.wj_brs(summer16_data.int_session == 3);
session_4 = summer16_data.wj_brs(summer16_data.int_session == 4);
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
plot(x, y_low, 'o', 'Color', 'r', 'MarkerFaceColor', 'r', ...
     'MarkerSize', 6, 'MarkerEdgeColor', 'r');
plot(x, y_high, 'o', 'Color', 'b', 'MarkerFaceColor', 'b', ...
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