close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 14/EX1 Disc Reg/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'PatternSym','PatternAsym','FlowerSym','FlowerAsym','LandscapeSym','LandscapeAsym'};

%ELECTRODES
electrodes = [25 27 62 64]; 


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
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


PatternSym = selectedData.PatternSym.data;
PatternAsym = selectedData.PatternAsym.data;
FlowerSym = selectedData.FlowerSym.data;
FlowerAsym = selectedData.FlowerAsym.data;
LandscapeSym = selectedData.LandscapeSym.data;
LandscapeAsym = selectedData.LandscapeAsym.data;
DiffPattern = PatternSym - PatternAsym;
DiffFlower = FlowerSym - FlowerAsym;
DiffLandscape = LandscapeSym - LandscapeAsym;
Zeroline = FlowerAsym-FlowerAsym;


%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'--','-','--','-','--','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[1 0 0],[0 1 0], [0 1 0],[0 0 1],[0 0 1],}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [LandscapeAsym,LandscapeSym,FlowerAsym,FlowerSym,PatternAsym,PatternSym],'LineWidth',LineWidth);
axis([-200 1000 -10 15]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Land Asym','Land Sym', 'Flower Asym','Flower Sym', 'Pattern Asym', 'Pattern Sym'},'FontSize',12,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffLandscape, DiffFlower, DiffPattern, Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Landscape','Flower','Pattern'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

close all

%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0.5 0.5 0]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [FlowerAsym,FlowerSym],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetrical Flower','Symmetrical Flower',},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0.5 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffFlower, Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
%legend({'Flower'},'FontSize',FontSize,'Location','southeast');
xline(300)
yline(-1.223)
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

