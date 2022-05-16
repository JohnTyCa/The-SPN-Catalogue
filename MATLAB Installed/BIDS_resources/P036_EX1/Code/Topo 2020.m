% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 36/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean;
%CONDITIONS
conditionNames = {'RefFirst','RefSecond','RefThird','RandFirst','RandSecond','RandThird'};

%TIME WINDOWS
low = 300;
high = 1000;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale = 5;  
contourRes = 0;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');
RefFirst= selectedData.RefFirst.data;
RefSecond = selectedData.RefSecond.data;
RefThird = selectedData.RefThird.data;
RandFirst = selectedData.RandFirst.data;
RandFirst = selectedData.RandFirst.data;
RandSecond = selectedData.RandSecond.data;
RandThird = selectedData.RandThird.data;


DiffFirst= RefFirst - RandFirst;
DiffSecond= RefSecond - RandSecond;
DiffThird= RefThird- RandThird;

GFPDiffFirst = std(DiffFirst);
GFPDiffSecond = std(DiffSecond);
GFPDiffThird = std(DiffThird);



%%%%%%%%%% this is for checking
electrodes = [25 62]; 
MSPNFirst =mean(DiffFirst(electrodes));
MSPNSecond =mean(DiffSecond(electrodes));
MSPNThird =mean(DiffThird(electrodes));
SPNcheck = [MSPNFirst,MSPNSecond,MSPNThird];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffFirst,GFPDiffSecond,GFPDiffThird];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%



figure('color',[1,1,1])
topoplot(DiffFirst, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFirst,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['First',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSecond, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSecond,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Second',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffThird, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffThird,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Third',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear
