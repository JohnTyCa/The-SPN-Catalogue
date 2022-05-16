close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 32/EX1 ContrastStereoCombined/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'BinocularSym', 'BinocularAsym','ContrastSym','ContrastAsym','CombinedSym','CombinedAsym'};


%ELECTRODES
electrodes = [25 27 62 64];


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
BinocularSym = selectedData.BinocularSym.data;
BinocularAsym = selectedData.BinocularAsym.data;
ContrastSym = selectedData.ContrastSym.data;
ContrastAsym = selectedData.ContrastAsym.data;
CombinedSym = selectedData.CombinedSym.data;
CombinedAsym = selectedData.CombinedAsym.data;
DiffBinocularSym  = BinocularSym  - BinocularAsym;
DiffContrastSym   = ContrastSym - ContrastAsym;
DiffCombinedSym   = CombinedSym - CombinedAsym;
Zeroline = zeros(length(timeVector),1);


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 0 0.5],[0 1 0],[0 0.5 0],[1 0 0],[0.5 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [BinocularSym,BinocularAsym,ContrastSym,ContrastAsym,CombinedSym,CombinedAsym],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'BinocularSym', 'BinocularAsym','ContrastSym','ContrastAsym','CombinedSym','CombinedAsym'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 1 0],[1 0 0],[0 0 0],}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffBinocularSym,DiffContrastSym,DiffCombinedSym,Zeroline],'LineWidth',LineWidth);
axis([-200 1500 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:250:1500,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Binocular Symmetry','Contrast Symmetry', 'Combined Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')
clear all

