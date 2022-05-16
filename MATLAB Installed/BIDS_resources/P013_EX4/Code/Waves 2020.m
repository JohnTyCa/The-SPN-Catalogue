close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 13/EX4 Direction Col Cong/Grand Averages';
load timeVector;
%load grandAverages;
%load grandAveragesMed;
load grandAveragesSkew;
%CONDITIONS
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};

%ELECTRODES
electrodes = [25 27 62 64]; 


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

%save('thisPlot','data');

%use this to plot ERPs
Rand = selectedData.Rand.data;
Ref20 = selectedData.Ref20.data;
Ref40 = selectedData.Ref40.data;
Ref60 = selectedData.Ref60.data;
Ref80 = selectedData.Ref80.data;
Ref100 = selectedData.Ref100.data;
Diff20 = Ref20 - Rand;
Diff40 = Ref40 - Rand;
Diff60 = Ref60 - Rand;
Diff80 = Ref80 - Rand;
Diff100 = Ref100 - Rand;
Zeroline = zeros(length(timeVector),1);


%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0.2 0 0],[0.4 0 0], [0.6 0 0],[0.8 0 0],[1 0 0],}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref20, Ref40, Ref60, Ref80, Ref100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random', '20', '40','60', '80','100'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0.2 0 0],[0.4 0 0], [0.6 0 0],[0.8 0 0],[1 0 0],[0 0 0]}';
figure('color',[1,1,1]);
P = plot(timeVector, [Diff20, Diff40, Diff60, Diff80, Diff100,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'20', '40','60', '80','100'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')


