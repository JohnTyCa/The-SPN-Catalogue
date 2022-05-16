clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 5/Grand Averages'

load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'Random','Reflection100','Reflection80','Reflection60','Reflection40','Reflection20'};


%ELECTRODES
electrodes = [25 62]; % Which electrodes do you want? 


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

%save('thisPlot','data');

%use this to plot ERPs
Random = selectedData.Random.data;
Reflection20 = selectedData.Reflection20.data;
Reflection40 = selectedData.Reflection40.data;
Reflection60 = selectedData.Reflection60.data;
Reflection80 = selectedData.Reflection80.data;
Reflection100 = selectedData.Reflection100.data;
Diff20 = Reflection20 - Random;
Diff40 = Reflection40 - Random;
Diff60 = Reflection60 - Random;
Diff80 = Reflection80 - Random;
Diff100 =Reflection100 - Random;
Zeroline = zeros(length(timeVector),1);


%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 0.2 0],[0 0.4 0], [0 0.6 0],[0 0.8 0],[0 1 0]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection20, Reflection40, Reflection60, Reflection80,Reflection100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random', '20', '40','60', '80','100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0.2 0],[0 0.4 0], [0 0.6 0],[0 0.8 0],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Diff20, Diff40, Diff60, Diff80, Diff100,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'20', '40','60', '80','100'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')


