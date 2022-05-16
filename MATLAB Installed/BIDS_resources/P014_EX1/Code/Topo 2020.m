close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 14/EX1 Disc Reg/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS

conditionNames={'PatternSym','PatternAsym','FlowerSym','FlowerAsym','LandscapeSym','LandscapeAsym'};

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

PatternSym = selectedData.PatternSym.data;
PatternAsym = selectedData.PatternAsym.data;
FlowerSym = selectedData.FlowerSym.data;
FlowerAsym = selectedData.FlowerAsym.data;
LandscapeSym = selectedData.LandscapeSym.data;
LandscapeAsym = selectedData.LandscapeAsym.data;

DiffPattern = PatternSym - PatternAsym;
DiffFlower = FlowerSym - FlowerAsym;
DiffLandscape = LandscapeSym - LandscapeAsym;

GFPDiffPattern = std(DiffPattern);
GFPDiffFlower = std(DiffFlower);
GFPDiffLandscape = std(DiffLandscape);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNPattern =mean(DiffPattern(electrodes));
MSPNFlower =mean(DiffFlower(electrodes));
MSPNLandscape =mean(DiffLandscape(electrodes));
SPNcheck = [MSPNPattern,MSPNFlower,MSPNLandscape];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffPattern,GFPDiffFlower,GFPDiffLandscape];%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

% figure('color',[1,1,1])
% topoplot(PatternSym, channelLocs,'numcontour', contourRes);
% colorbar('FontSize',FontSize)
% caxis([-zscale, zscale])
% figure('color',[1,1,1])
% topoplot(FlowerSym, channelLocs,'numcontour', contourRes);
% colorbar('FontSize',FontSize)
% caxis([-zscale, zscale])
% figure('color',[1,1,1])
% topoplot(LandscapeSym, channelLocs,'numcontour', contourRes);
% colorbar('FontSize',FontSize)
% caxis([-zscale, zscale])

figure('color',[1,1,1])
topoplot(DiffPattern, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffPattern,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Shape',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffFlower, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlower,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Flower',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffLandscape, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffLandscape,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Landscape',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear

