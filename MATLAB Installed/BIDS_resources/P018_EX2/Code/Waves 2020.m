close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages'
load timeVector;
load grandAverages;


%CONDITIONS
conditionNames={'REFRANDs','RANDREFs','REFlREFrREFl','REFrREFlREFr','RandRandRand','Consistent','Changing'};


%ELECTRODES
%electrodes = [21 22 25 26]; % left electrodes 
electrodes = [58 59 62 63]; % right electrodes 


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


RandRandRand = selectedData.RandRandRand.data;
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
REFRANDs = selectedData.REFRANDs.data;
RANDREFs = selectedData.RANDREFs.data;
REFlREFrREFl =  selectedData.REFlREFrREFl.data;
REFrREFlREFr =  selectedData.REFrREFlREFr.data;


DiffConsistent = Consistent - RandRandRand;
DiffChanging = Changing - RandRandRand;
DiffREFRANDs = REFRANDs - RandRandRand;
DiffRANDREFs = RANDREFs - RandRandRand;
DiffREFlREFrREFl = REFlREFrREFl - RandRandRand;
DiffREFrREFlREFr = REFrREFlREFr - RandRandRand;
Zeroline = zeros(length(timeVector),1);


set(0,'DefaultAxesFontSize', 20);


% Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, Consistent, Changing],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Randoms','Repeated Locations','Changing Locations'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0],[0.5,0 0],[0 0.5 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RANDREFs,REFRANDs,REFrREFlREFr,REFlREFrREFl],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Randoms','RANDREFs','REFRANDs','REFrREFlREFr','REFlREFrREFl'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Left hem
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRANDREFs,DiffREFrREFlREFr,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RANDREFs','REFrREFlREFr'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

%Right hem
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffREFRANDs,DiffREFlREFrREFl,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RANDREFs','REFrREFlREFr'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')
