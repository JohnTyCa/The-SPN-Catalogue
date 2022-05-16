close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 21/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean;
%CONDITIONS
conditionNames={'RandRandRand','GlassGlassGlass','RefRefRef','RefGlassRef','GlassRefGlass','Consistent','Changing'};

%TIME WINDOWS
low = 250;
high = 600;  
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

RandRandRand = selectedData.RandRandRand.data;
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
GlassGlassGlass = selectedData.GlassGlassGlass.data;
RefRefRef = selectedData.RefRefRef.data;
RefGlassRef = selectedData.RefGlassRef.data;
GlassRefGlass = selectedData.GlassRefGlass.data;


DiffConsistent = Consistent-RandRandRand;
DiffChanging = Changing-RandRandRand;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffGlassGlassGlass = GlassGlassGlass - RandRandRand;
DiffRefGlassRef = RefGlassRef - RandRandRand;
DiffGlassRefGlass = GlassRefGlass - RandRandRand;

GFPDiffConsistent = std(DiffConsistent);
GFPDiffChanging = std(DiffChanging);
GFPDiffRefRefRef = std(DiffRefRefRef);
GFPDiffGlassGlassGlass = std(DiffGlassGlassGlass);
GFPDiffRefGlassRef = std(DiffRefGlassRef);
GFPDiffGlassRefGlass = std(DiffGlassRefGlass);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNGlassGlassGlass =mean(DiffGlassGlassGlass(electrodes));
MSPNRefRefRef =mean(DiffRefRefRef(electrodes));
MSPNRefGlassRef =mean(DiffRefGlassRef(electrodes));
MSPNGlassRefGlass =mean(DiffGlassRefGlass(electrodes));

SPNcheck = [MSPNGlassGlassGlass,MSPNRefRefRef,MSPNRefGlassRef,MSPNGlassRefGlass];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffGlassGlassGlass,GFPDiffRefRefRef,GFPDiffRefGlassRef,GFPDiffGlassRefGlass];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffRefRefRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRefRefRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRefRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffGlassGlassGlass, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffGlassGlassGlass,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['GlassGlassGlass',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffGlassRefGlass, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffGlassRefGlass,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['GlassRefGlass',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffRefGlassRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRefGlassRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefGlassRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all