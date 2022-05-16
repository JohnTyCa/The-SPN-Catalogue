close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 8/EX4 AS1F/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean.mat;
%CONDITIONS
conditionNames = {'Random','AntiSymmetry','Symmetry'};

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
Random= selectedData.Random.data;
AntiSymmetry = selectedData.AntiSymmetry.data;
Symmetry = selectedData.Symmetry.data;

DiffAntiSymmetry = AntiSymmetry-Random;
DiffSymmetry = Symmetry-Random;

GFPDiffAntiSymmetry = std(DiffAntiSymmetry);
GFPDiffSymmetry = std(DiffSymmetry);


%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNAntiSymmetry =mean(DiffAntiSymmetry(electrodes));
MSPNSymmetry =mean(DiffSymmetry(electrodes));
SPNcheck = [MSPNAntiSymmetry,MSPNSymmetry];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffAntiSymmetry,GFPDiffSymmetry];%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffAntiSymmetry, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffAntiSymmetry,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['AntiSymmetry',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymmetry, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymmetry,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear