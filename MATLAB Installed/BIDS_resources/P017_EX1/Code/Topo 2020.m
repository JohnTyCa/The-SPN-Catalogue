close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 17/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRand','RandRef','RefRand','RefRef'}; %nn nr rn rr

%TIME WINDOWS
low = 296;
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



RandRand=selectedData.RandRand.data;
RandRef=selectedData.RandRef.data;
RefRand= selectedData.RefRand.data;
RefRef=selectedData.RefRef.data;


Zeroline = zeros(length(timeVector),1);


DiffRandRef = RandRef-RandRand;
DiffRefRand = RefRand-RandRand;
DiffRefRef = RefRef-RandRand;

GFPDiffRandRef = std(DiffRandRef);
GFPDiffRefRand = std(DiffRefRand);
GFPDiffRefRef = std(DiffRefRef);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNRandRef =mean(DiffRandRef(electrodes));
MSPNRefRand =mean(DiffRefRand(electrodes));
MSPNRefRef =mean(DiffRefRef(electrodes));

SPNcheck = [MSPNRandRef,MSPNRefRand,MSPNRefRef];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRandRef,GFPDiffRefRand,GFPDiffRefRef];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffRandRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRandRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RandRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRefRand, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRefRand,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRand',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRefRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRefRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all