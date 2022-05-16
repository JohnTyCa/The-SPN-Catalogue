close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 15/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'Reflection','Translation','Circular','Radial','Random'}; 

%ELECTRODES
electrodes = [25 62]; 

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'off';

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

%save('thisPlot','selectedData');

%use this to plot ERPs
Reflection = selectedData.Reflection.data;
Translation = selectedData.Translation.data;
Circular = selectedData.Circular.data;
Radial = selectedData.Radial.data;
Random = selectedData.Random.data;

DiffReflection = Reflection - Random;
DiffTranslation = Translation - Random;
DiffCircular = Circular - Random;
DiffRadial = Radial - Random;

Zeroline = zeros(length(timeVector),1);


%FIGURE1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0.5 0],[0 0 1],[1 0.7 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Reflection, Circular, Radial, Translation, Random],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Reflection','Circular', 'Radial', 'Translation', 'Random'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0.5 0],[0 0 1],[1 0.7 0],[0 0 0]}';
figure('color',[1,1,1])
set(0,'DefaultAxesColorOrder',[1 0 0; 0 .5 0; 0 0 1; 1 .7 0]);
P = plot(timeVector, [DiffReflection DiffCircular DiffRadial DiffTranslation,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Reflection','Circular','Radial','Translation'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')


