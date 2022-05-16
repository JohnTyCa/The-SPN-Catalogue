clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 8/EX1 W Ref and Rep/Grand Averages'
load timeVector;
load grandAverages;



%CONDITIONS
conditionNames={'Rand20','Rand60','Rand100','Ref20','Ref60','Ref100','Trans20','Trans60','Trans100','Random','Reflection','Translation'};

%ELECTRODES
electrodes = [25 62]; 

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
Random= selectedData.Random.data;
Rand20 = selectedData.Rand20.data;
Rand60 = selectedData.Rand60.data;
Rand100 = selectedData.Rand100.data;
Ref20 = selectedData.Ref20.data;
Ref60 = selectedData.Ref60.data;
Ref100 = selectedData.Ref100.data;
Trans20 = selectedData.Trans20.data;
Trans60 = selectedData.Trans60.data;
Trans100 = selectedData.Trans100.data;
DiffRef20= Ref20 - Random;
DiffRef60= Ref60 - Random;
DiffRef100= Ref100 - Random;
DiffTrans20= Trans20 - Random;
DiffTrans60= Trans60 - Random;
DiffTrans100= Trans100 - Random;
Zeroline = zeros(length(timeVector),1);







%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0.5 0.5],[0 0 1],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Ref20, Ref60, Ref100],'LineWidth',LineWidth);
axis([-200 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref20','Ref60','Ref100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0.5 0.5],[0.5 0 0],[0 0.5 0],[0.1 0.1 0.1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Trans20, Trans60, Trans100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Rep20','Rep60','Rep100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure 3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 1 0],[0 0 0],[0 0 0]}'; 
figure('color',[1,1,1])
P = plot(timeVector, [DiffRef20,DiffRef60,DiffRef100,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Ref20','Ref60','Ref100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')



%Figure 4
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0.7 0 0],[0 0.7 0],[0.1 0.1 0.1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffTrans20,DiffTrans60,DiffTrans100,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rep20','Rep60','Rep100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')



% Test Figure

StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0.5 0.5],[0 0 1],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand20, Rand60, Rand100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand20','Rand60','Rand100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
