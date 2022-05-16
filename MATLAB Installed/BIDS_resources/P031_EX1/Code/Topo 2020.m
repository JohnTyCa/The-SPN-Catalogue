close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 31/EX1 Shape/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames ={'SymmetrySame','SymmetryNovel','AsymmetrySame','AsymmetryNovel'}; 

%TIME WINDOWS
low = 250;
high = 350;
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
SymmetrySame = selectedData.SymmetrySame.data;
SymmetryNovel = selectedData.SymmetryNovel.data;
AsymmetrySame = selectedData.AsymmetrySame.data;
AsymmetryNovel = selectedData.AsymmetryNovel.data;

DiffSame  = SymmetrySame  - AsymmetrySame;
DiffNovel  = SymmetryNovel - AsymmetryNovel;

GFPDiffSame = std(DiffSame);
GFPDiffNovel = std(DiffNovel);


%%%%%%%%%% this is for checking
electrodes = [24 25 61 62]; % Left and right
MSPNSame =mean(DiffSame(electrodes));
MSPNNovel =mean(DiffNovel(electrodes));
SPNcheck = [MSPNSame,MSPNNovel];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffSame,GFPDiffNovel]%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffSame, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSame,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetrySame',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffNovel, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffNovel,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryNovel',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all
