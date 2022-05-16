% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX5 Gerbino PNG1and3/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames = {'RandomConvex1','RandomConcave1','RefConvex1','RefConcave1','RandomConvex3','RandomConcave3','RefConvex3','RefConcave3'};

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

RandomConvex1 = selectedData.RandomConvex1.data;
RandomConcave1 = selectedData.RandomConcave1.data;
RefConvex1 = selectedData.RefConvex1.data;
RefConcave1 = selectedData.RefConcave1.data;
DiffConvex1  = RefConvex1  - RandomConvex1;
DiffConcave1 = RefConcave1 - RandomConcave1;

RandomConvex3 = selectedData.RandomConvex3.data;
RandomConcave3 = selectedData.RandomConcave3.data;
RefConvex3 = selectedData.RefConvex3.data;
RefConcave3 = selectedData.RefConcave3.data;
DiffConvex3  = RefConvex3  - RandomConvex3;
DiffConcave3 = RefConcave3 - RandomConcave3;

GFPDiffConvex1 = std(DiffConvex1);
GFPDiffConcave1 = std(DiffConcave1);
GFPDiffConvex3 = std(DiffConvex3);
GFPDiffConcave3 = std(DiffConcave3);


%%%%%%%%%% this is for checking
electrodes = [25 26 27 62 63 64];
MSPNConvex1 =mean(DiffConvex1(electrodes));
MSPNConcave1 =mean(DiffConcave1(electrodes));
MSPNConvex3 =mean(DiffConvex3(electrodes));
MSPNConcave3 =mean(DiffConcave3(electrodes));
SPNcheck = [MSPNConvex1,MSPNConcave1,MSPNConvex3,MSPNConcave3];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffConvex1,GFPDiffConcave1,GFPDiffConvex3,GFPDiffConcave3];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffConvex1, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConvex1,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Convex1',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffConcave1, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConcave1,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Concave1',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffConvex3, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConvex3,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Convex3',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffConcave3, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffConcave3,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Concave3',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all
