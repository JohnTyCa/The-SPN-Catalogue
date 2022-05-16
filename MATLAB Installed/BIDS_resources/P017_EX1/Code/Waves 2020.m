close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 17/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'RandRand','RandRef','RefRand','RefRef'}; %nn nr rn rr

%ELECTRODES
electrodes = [25 27 62 64]; % PO7 O1 O2 PO8


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 2;
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

%save('thisPlot','data');

RandRand=selectedData.RandRand.data;
RandRef=selectedData.RandRef.data;
RefRand= selectedData.RefRand.data;
RefRef=selectedData.RefRef.data;
DiffRandRef = RandRef-RandRand;
DiffRefRand = RefRand-RandRand;
DiffRefRef = RefRef-RandRand;
Zeroline = zeros(length(timeVector),1);



%FIGURE 1 
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 1 0],[0 0.5 0.5],[0.5 0 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRand,RandRef,RefRand,RefRef],'LineWidth',LineWidth);
axis([-200 1000 -2 4]);
set(gca,'YTick',-2:1:4);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRand','RandRef','RefRand','RefRef'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[0 0.5 0.5],[0.8 0 0.8],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRandRef,DiffRefRand,DiffRefRef,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -1.5 0.5]);
%set(gca,'YTick',-1.5:0.5:0.5,'YTickLabel',[]);
%set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRef','RefRand','RefRef'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','b');
ylabel('SPN amplitude (microvolts)','color','b');
grid('on')
legend('boxoff')

clear all


