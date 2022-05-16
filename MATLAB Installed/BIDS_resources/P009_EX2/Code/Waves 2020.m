clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 9/EX2 One Sided/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'REFNOTHING','RANDNOTHING','NOTHINGREF','NOTHINGRAND'};


%ELECTRODES
%electrodes = [20 21 22 23 25 26]; % Left
electrodes = [57 58 59 60 62 63]; % Right

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
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

REFNOTHING= selectedData.REFNOTHING.data;
RANDNOTHING = selectedData.RANDNOTHING.data;
NOTHINGREF= selectedData.NOTHINGREF.data;
NOTHINGRAND = selectedData.NOTHINGRAND.data;
DiffLeftHem= NOTHINGREF - NOTHINGRAND;
DiffRightHem= REFNOTHING - RANDNOTHING;
Zeroline = zeros(length(timeVector),1);



% This is for left brain responses
StyleArray = {'LineStyle'};
StyleOrder = {'-','-',}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [NOTHINGRAND,NOTHINGREF],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'NOTHINGRAND','NOTHINGREF'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffLeftHem,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Left SPN'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')





% This is for right brain responses
StyleArray = {'LineStyle'};
StyleOrder = {'-','-',}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RANDNOTHING,REFNOTHING],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RANDNOTHING','REFNOTHING'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRightHem,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Right SPN'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')