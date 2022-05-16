close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 31/EX2 Shape with position/Grand Averages'
load timeVector;
load grandAverages

%CONDITIONS
conditionNames ={'SymmetrySame','SymmetryNovel','AsymmetrySame','AsymmetryNovel'}; 

%ELECTRODE
electrodes = [24 25 61 62]; % Left and right

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
        data = smooth(data,smoothfactor,'moving'); 
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');

SymmetrySame = selectedData.SymmetrySame.data;
SymmetryNovel = selectedData.SymmetryNovel.data;
AsymmetrySame = selectedData.AsymmetrySame.data;
AsymmetryNovel = selectedData.AsymmetryNovel.data;
DiffSymmetrySame  = SymmetrySame  - AsymmetrySame;
DiffSymmetryNovel  = SymmetryNovel - AsymmetryNovel;
Zeroline = zeros(length(timeVector),1);


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [SymmetrySame,SymmetryNovel,AsymmetrySame,AsymmetryNovel],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'SymmetrySame','SymmetryNovel','AsymmetrySame','AsymmetryNovel'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 0],}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetrySame,DiffSymmetryNovel,Zeroline],'LineWidth',LineWidth);
axis([-200 500 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-00:250:500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'SymmetrySame','SymmetryNovel'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')
clear all

