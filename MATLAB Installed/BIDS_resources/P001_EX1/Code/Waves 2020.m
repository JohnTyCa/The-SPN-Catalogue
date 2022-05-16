clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 1/EX1 Reflection/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'Regular','Random'}

%ELECTRODES
electrodes = [25 62]; 

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 4;
set(0,'DefaultAxesFontSize', FontSize);

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = mean(data(electrodes,1:end),1)';
    if strcmp(smoothOn, 'on') == 1;
        data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');

Random= selectedData.Random.data;
Regular = selectedData.Regular.data;
Diff= Regular - Random;
Zeroline = zeros(length(timeVector),1);

close all

% FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Regular],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10,'ycolor','white');
set(gca,'XTick',-200:200:1000,'XMinorTick','on','xcolor','white');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
%legend({'Random','Reflection'},'FontSize',FontSize,'Location','southwest');
%xlabel('Time from stimulus onset (ms)');
%ylabel('Amplitude (microvolts)');
%grid('on')
%legend('boxoff')

% FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Diff,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
%legend({'Reflection'},'FontSize',FontSize,'Location','southeast');
% xline(300)
% yline(-2.503)
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

