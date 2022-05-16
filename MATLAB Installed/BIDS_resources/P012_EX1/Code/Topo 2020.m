close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 12/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
% CONDITIONS
conditionNames={'AntiSymmetryDiscReg','SymmetryDiscReg','RandomDiscReg','AntiSymmetryDiscColor','SymmetryDiscColor','RandomDiscColor'};


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
SymmetryDiscReg = selectedData.SymmetryDiscReg.data;
AntiSymmetryDiscReg = selectedData.AntiSymmetryDiscReg.data;
RandomDiscReg = selectedData.RandomDiscReg.data;
SymmetryDiscColor = selectedData.SymmetryDiscColor.data;
AntiSymmetryDiscColor = selectedData.AntiSymmetryDiscColor.data;
RandomDiscColor = selectedData.RandomDiscColor.data;


DiffSymmetryDiscReg = SymmetryDiscReg-RandomDiscReg;
DiffAntiSymmetryDiscReg = AntiSymmetryDiscReg-RandomDiscReg;
DiffSymmetryDiscColor = SymmetryDiscColor-RandomDiscColor;
DiffAntiSymmetryDiscColor = AntiSymmetryDiscColor-RandomDiscColor;

GFPDiffSymmetryDiscReg = std(DiffSymmetryDiscReg);
GFPDiffAntiSymmetryDiscReg = std(DiffAntiSymmetryDiscReg);
GFPDiffSymmetryDiscColor = std(DiffSymmetryDiscColor);
GFPDiffAntiSymmetryDiscColor = std(DiffAntiSymmetryDiscColor);

%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNAntiSymmetryDiscReg =mean(DiffAntiSymmetryDiscReg(electrodes));
MSPNSymmetryDiscReg =mean(DiffSymmetryDiscReg(electrodes));
MSPNAntiSymmetryDiscColor =mean(DiffAntiSymmetryDiscColor(electrodes));
MSPNSymmetryDiscColor =mean(DiffSymmetryDiscColor(electrodes));
SPNcheck = [MSPNAntiSymmetryDiscReg,MSPNSymmetryDiscReg,MSPNAntiSymmetryDiscColor,MSPNSymmetryDiscColor];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffAntiSymmetryDiscReg,GFPDiffSymmetryDiscReg,GFPDiffAntiSymmetryDiscColor,GFPDiffSymmetryDiscColor];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffSymmetryDiscReg, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmetryDiscReg,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryDiscReg',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffAntiSymmetryDiscReg, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAntiSymmetryDiscReg,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['AntiSymmetryDiscReg',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSymmetryDiscColor, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmetryDiscColor,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryDiscCol',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffAntiSymmetryDiscColor, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAntiSymmetryDiscColor,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['AntiSymmetryDiscCol',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all