close all % This is color discrimination expeirment 2
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 30/EX3 Gerbino Black Disc Reg/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames = {'RandomConvex','RandomConcave','RefConvex','RefConcave'};

%ELECTRODES
electrodes = [25 26 27 62 63 64];

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


RandomConvex = selectedData.RandomConvex .data;
RandomConcave = selectedData.RandomConcave .data;
RefConvex = selectedData.RefConvex.data;
RefConcave = selectedData.RefConcave.data;
DiffRefConvex  = RefConvex  - RandomConvex;
DiffRefConcave = RefConcave - RandomConcave;
Zeroline = zeros(length(timeVector),1);




%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConvex,RandomConcave,RefConvex,RefConcave],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomConvex','RandomConcave','RefConvex','RefConcave'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRefConvex,DiffRefConcave,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Convex','Concave'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')


