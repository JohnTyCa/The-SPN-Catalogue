clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 2/EX2 Regularity/Grand Averages'
load timeVector;
%load grandAverages;
load grandAveragesMed;
%CONDITIONS
conditionNames={'Reflection','Rotation','Random','Translation'};

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
Reflection= selectedData.Reflection.data;
Rotation = selectedData.Rotation.data;
Random = selectedData.Random.data;
Translation = selectedData.Translation.data;


DiffReflection= Reflection - Random;
DiffRotation= Rotation - Random;
DiffTranslation= Translation - Random;
Zeroline = zeros(length(timeVector),1);


%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0 1 0],[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random,Reflection,Rotation,Translation],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection','Rotation','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[1 0 0],[0 0 1],[0,0 0]}'; 
figure('color',[1,1,1])
P = plot(timeVector, [DiffReflection,DiffRotation,DiffTranslation,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Reflection','Rotation','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

clear all;