clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 6/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'ReflectionVertical','TranslationVertical','ReflectionHorizontal','TranslationHorizontal'};

%ELECTRODES
electrodes = [25 26 27 62 63 64]; % Left and right

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

%save('thisPlot','selectedData');

%use this to plot ERPs
ReflectionVertical= selectedData.ReflectionVertical.data;
TranslationVertical = selectedData.TranslationVertical.data;
ReflectionHorizontal= selectedData.ReflectionHorizontal.data;
TranslationHorizontal = selectedData.TranslationHorizontal.data;
DiffVertical= ReflectionVertical - TranslationVertical;
DiffHorizontal= ReflectionHorizontal - TranslationHorizontal;
Zeroline = zeros(length(timeVector),1);


%Figure 1
set(0,'DefaultAxesFontSize', 20);
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 1 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [ReflectionVertical,TranslationVertical,ReflectionHorizontal,TranslationHorizontal],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ReflectionVertical','TranslationVertical','ReflectionHorizontal','TranslationHorizontal'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffVertical,DiffHorizontal,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Vertical','Horizontal'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

clear