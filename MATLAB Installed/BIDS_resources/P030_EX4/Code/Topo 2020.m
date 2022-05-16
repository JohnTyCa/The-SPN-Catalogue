% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX4 Gerbino Centre/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames = {'RandomConvex','RandomConcave','RefConvex','RefConcave'};

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
RandomConvex = selectedData.RandomConvex .data;
RandomConcave = selectedData.RandomConcave .data;
RefConvex = selectedData.RefConvex.data;
RefConcave = selectedData.RefConcave.data;

DiffConvex  = RefConvex  - RandomConvex;
DiffConcave = RefConcave - RandomConcave;

GFPDiffConvex = std(DiffConvex);
GFPDiffConcave = std(DiffConcave);


%%%%%%%%%% this is for checking
electrodes = [25 26 27 62 63 64];
MSPNConvex =mean(DiffConvex(electrodes));
MSPNConcave =mean(DiffConcave(electrodes));
SPNcheck = [MSPNConvex,MSPNConcave];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffConvex,GFPDiffConcave];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffConvex, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConvex,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Convex',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffConcave, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConcave,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Concave',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);



clear all
