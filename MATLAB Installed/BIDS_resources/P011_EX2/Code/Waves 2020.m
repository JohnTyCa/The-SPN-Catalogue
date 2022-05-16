close all
clear all

% you will need to set this to a directory on your computer
cd('/Volumes/SPN Catalog/Expanded Catalogue/Project 11/EX2 Color matching task/Grand Averages');
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'SymmetryFirst','RandomFirst','SymmetrySecond','RandomSecond','Sym1Sym1','Rand1Rand1','x1Sym2','x1Rand2','SymRand','RandSym','Sym1Sym2','Rand1Rand2','Same','Different'};


%ELECTRODES
electrodes = [25 62]; % PO7 PO8


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
SymmetryFirst = selectedData.SymmetryFirst.data;
RandomFirst = selectedData.RandomFirst.data;
DiffSymmetryFirst = SymmetryFirst-RandomFirst;
Zeroline = zeros(length(timeVector),1);


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [RandomFirst, SymmetryFirst],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryFirst,Zeroline],'LineWidth',LineWidth);
axis([-200 500 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-0:250:500,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry First'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')




