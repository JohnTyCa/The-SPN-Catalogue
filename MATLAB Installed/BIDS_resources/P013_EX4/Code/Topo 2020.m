close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX4 Direction Col Cong/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean;
%CONDITIONS
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};


%TIME WINDOWS
low = 300;
high = 1000;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =5;
contourRes = 0;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');

Rand = selectedData.Rand.data;
Ref20 = selectedData.Ref20.data;
Ref40 = selectedData.Ref40.data;
Ref60 = selectedData.Ref60.data;
Ref80 = selectedData.Ref80.data;
Ref100 = selectedData.Ref100.data;


Diff20 = Ref20 - Rand;
Diff40 = Ref40 - Rand;
Diff60 = Ref60 - Rand;
Diff80 = Ref80 - Rand;
Diff100 = Ref100 - Rand;


GFPDiff20 = std(Diff20);
GFPDiff40 = std(Diff40);
GFPDiff60 = std(Diff60);
GFPDiff80 = std(Diff80);
GFPDiff100 = std(Diff100);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPN20 =mean(Diff20(electrodes));
MSPN40 =mean(Diff40(electrodes));
MSPN60 =mean(Diff60(electrodes));
MSPN80 =mean(Diff80(electrodes));
MSPN100 =mean(Diff100(electrodes));
SPNcheck = [MSPN20,MSPN40,MSPN60,MSPN80,MSPN100];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiff20,GFPDiff40,GFPDiff60,GFPDiff80,GFPDiff100]%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

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

clear
