close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 33/EX2 Luminance/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'RandFlatGabors','SymFlatGabors','RandSlantGabors','SymSlantGabors','RandFlatSolidPoly','SymFlatSolidPoly','RandSlantSolidPoly','SymSlantSolidPoly'};

%ELECTRODES
electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64];

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

RandFlatGabors= selectedData.RandFlatGabors.data;
SymFlatGabors = selectedData.SymFlatGabors.data;
RandSlantGabors = selectedData.RandSlantGabors.data;
SymSlantGabors = selectedData.SymSlantGabors.data;
RandFlatSolidPoly= selectedData.RandFlatSolidPoly.data;
SymFlatSolidPoly = selectedData.SymFlatSolidPoly.data;
RandSlantSolidPoly = selectedData.RandSlantSolidPoly.data;
SymSlantSolidPoly = selectedData.SymSlantSolidPoly.data;
DiffSymFlatGabors  = SymFlatGabors  - RandFlatGabors;
DiffSymSlantGabors   = SymSlantGabors - RandSlantGabors;
DiffSymFlatSolidPoly  = SymFlatSolidPoly  - RandFlatSolidPoly;
DiffSymSlantSolidPoly   = SymSlantSolidPoly - RandSlantSolidPoly;
Zeroline = zeros(length(timeVector),1);



%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0.5],[0 0 1],[0.5 0 0],[1 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandFlatGabors,SymFlatGabors,RandSlantGabors,SymSlantGabors],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlatGabors','SymFlatGabors','RandSlantGabors','SymSlantGabors'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymFlatGabors,DiffSymSlantGabors,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Flat Gabors','Slant Gabors'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')



% Solid poly
%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0.5],[0 0 1],[0.5 0 0],[1 0 0]}';

figure('color',[1,1,1])
P = plot(timeVector, [RandFlatSolidPoly,SymFlatSolidPoly,RandSlantSolidPoly,SymSlantSolidPoly],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlatSolidPoly','SymFlatSolidPoly','RandSlantSolidPoly','SymSlantSolidPoly'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymFlatSolidPoly,DiffSymSlantSolidPoly,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'FlatSolidPoly','SlantSolidPoly'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')
clear all