close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 18/EX5 Ref and Rot/Grand Averages'
load timeVector;
load grandAverages;


%CONDITIONS
conditionNames={'RandRandRand','Consistent','Changing', 'RefRefRef','RotRotRot','RefRotRef','RotRefRot'};

%ELECTRODES
electrodes = [25 27 62 64]; % Which electrodes do you want? 


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
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
RefRefRef = selectedData.RefRefRef.data;
RotRotRot = selectedData.RotRotRot.data;
RefRotRef = selectedData.RefRotRef.data;
RotRefRot = selectedData.RotRefRot.data;


DiffConsistent = Consistent - RandRandRand;
DiffChanging = Changing - RandRandRand;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffRotRotRot = RotRotRot - RandRandRand;
DiffRefRotRef = RefRotRef - RandRandRand;
DiffRotRefRot = RotRefRot - RandRandRand;

Zeroline = zeros(length(timeVector),1);






%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0],[0.2 0 0],[0 0.2 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RefRefRef, RotRotRot,RefRotRef,RotRefRot],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-100:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','RefRefRef', 'RotRotRot','RefRotRef','RotRefRot'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0.2 0 0],[0 0.2 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRefRefRef,DiffRotRotRot,DiffRefRotRef,DiffRotRefRot,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RefRefRef','RotRotRot','RefRotRef','RotRefRot'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')


