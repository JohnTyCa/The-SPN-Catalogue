close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 18/EX1 Ref and Ident/Grand Averages';
load timeVector;
load grandAverages;


%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef','RandRandRef','RandIdent','RefIdent'};

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
        data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');

%use this to plot ERPs
RandRandRand = selectedData.RandRandRand.data;
RefRefRef = selectedData.RefRefRef.data;
RandIdent = selectedData.RandIdent.data;
RefIdent = selectedData.RefIdent.data;
RandRandRef = selectedData.RandRandRef.data;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffRefIdent = RefIdent - RandIdent;
DiffRandRandRef = RandRandRef - RandRandRand;
Zeroline = zeros(length(timeVector),1);



%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0],[0 0 1],[0 1 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RefRefRef, RandIdent,RefIdent,RandRandRef],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-100:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Different Randoms','Different Reflections','Identical Randoms','Identical Reflections','RandRandRef'},FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 1 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRefRefRef DiffRefIdent DiffRandRandRef,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Different Reflections','Identical Reflections','RandRandRef'},FontSize',18,'Location','northeast');
xlabel('Time from stimulus onset (ms)','color','black');
ylabel('SPN amplitude (microvolts)','color','black');
grid('on')
legend('boxoff')
clear all