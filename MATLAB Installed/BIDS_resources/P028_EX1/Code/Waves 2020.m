close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 28/EX1 control/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames = {'Symmetry','Asymmetry'};  

%ELECTRODES
electrodes = [24 25 62 61]; %P7 P8 PO7 PO8


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
        data = smooth(data,smoothfactor,'moving'); 
    end
    selectedData.(c).data = data;
end


Symmetry = selectedData.Symmetry.data;
Asymmetry = selectedData.Asymmetry.data;
DiffSymmetry = Symmetry - Asymmetry;
Zeroline = zeros(length(timeVector),1);



%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Asymmetry,Symmetry],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','northeast');
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
set(0,'DefaultAxesColorOrder',[1 0 0; 0 .5 0; 0 0 1; 1 .7 0]);
P = plot(timeVector, [DiffSymmetry,Zeroline],'LineWidth',LineWidth);
axis([500 1500 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',500:250:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry T2'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')


