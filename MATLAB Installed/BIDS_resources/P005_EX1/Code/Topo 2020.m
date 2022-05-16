close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 5/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat
%CONDITIONS
conditionNames={'Random','Reflection100','Reflection80','Reflection60','Reflection40','Reflection20'};


%TIME WINDOWS
low = 300;
high = 1000;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =5
contourRes = 0;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');

Random = selectedData.Random.data;
Reflection20 = selectedData.Reflection20.data;
Reflection40 = selectedData.Reflection40.data;
Reflection60 = selectedData.Reflection60.data;
Reflection80 = selectedData.Reflection80.data;
Reflection100 = selectedData.Reflection100.data;


Diff20 = Reflection20 - Random;
Diff40 = Reflection40 - Random;
Diff60 = Reflection60 - Random;
Diff80 = Reflection80 - Random;
Diff100 =Reflection100 - Random;
GFPDiff20 = std(Diff20);
GFPDiff40 = std(Diff40);
GFPDiff60 = std(Diff60);
GFPDiff80 = std(Diff80);
GFPDiff100 = std(Diff100);

%This is for checking
electrodes = [25 62]; % Which electrodes do you want? 
MSPN20 =mean(Diff20(electrodes));
MSPN40 =mean(Diff40(electrodes));
MSPN60 =mean(Diff60(electrodes));
MSPN80 =mean(Diff80(electrodes));
MSPN100 =mean(Diff100(electrodes));
SPNcheck = [MSPN100,MSPN80,MSPN60,MSPN40,MSPN20];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiff100,GFPDiff80,GFPDiff60,GFPDiff40,GFPDiff20];
save('GFPDiffCheck','GFPDiffCheck');



figure('color',[1,1,1])
topoplot(Diff20, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiff20,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref20',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diff40, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiff40,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref40',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diff60, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiff60,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref60',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diff80, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiff80,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref80',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diff100, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiff100,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref100',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear;