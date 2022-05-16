close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 16/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'RandRandRand','RandsBlack','RandsWhite','RandsBWB','RandsWBW','RefsBlack','RefsWhite','RefsBWB','RefsWBW','RandsConsistent','RandsChanging','RefsConsistent','RefsChanging'};

%ELECTRODES
electrodes = [25 27 62 64]; 

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
        data = smooth(data,smoothfactor,'moving'); 
    end
    selectedData.(c).data = data;
end

%save('thisPlot','data');

RandRandRand= selectedData.RandRandRand.data;
RefsConsistent = selectedData.RefsConsistent.data;
RefsChanging = selectedData.RefsChanging.data;
RandsConsistent = selectedData.RandsConsistent.data;
RandsChanging = selectedData.RandsChanging.data;
RandsBlack = selectedData.RandsBlack.data;
RandsWhite = selectedData.RandsWhite.data;
RefsBlack = selectedData.RefsBlack.data;
RefsWhite = selectedData.RefsWhite.data;
RandsBWB = selectedData.RandsBWB.data;
RandsWBW = selectedData.RandsWBW.data;
RefsBWB = selectedData.RefsBWB.data;
RefsWBW = selectedData.RefsWBW.data;




DiffConsistent = RefsConsistent-RandsConsistent;
DiffChanging = RefsChanging-RandsChanging;

DiffBlack = RefsBlack-RandsBlack;
DiffWhite = RefsWhite-RandsWhite;
DiffWBW = RefsWBW - RandsWBW;
DiffBWB = RefsBWB - RandsBWB;

% DiffBlack = RefsBlack-RandRandRand;
% DiffWhite = RefsWhite-RandRandRand;
% DiffWBW = RefsWBW - RandRandRand;
% DiffBWB = RefsBWB - RandRandRand;

Zeroline = zeros(length(timeVector),1);



%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0 0 0.8],[1 0 0],[0 1 0]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [RandsConsistent,RandsChanging,RefsConsistent,RefsChanging],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Repeated Random','Changing Random','Repeated Reflection','Changing Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--','--','--','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0.6 0.6 0.6],[1 0 0],[0 0 1],[0 0 0],[0.6 0.6 0.6],[1 0 0],[0 0 1]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [RandsBlack,RandsWhite,RefsBlack,RefsWhite,RandsWBW,RandsBWB,RefsWBW,RefsBWB],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RefsBlack','RandsWhites','RefsBlack','RefsWhite','RandsWBW','RandsBWB','RefsWBW','RefsBWB'},'FontSize',12,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0.6 0.6 0.6],[1 0 0],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffBlack,DiffWhite,DiffWBW,DiffBWB,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Blacks','Whites','WBW','BWB'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

