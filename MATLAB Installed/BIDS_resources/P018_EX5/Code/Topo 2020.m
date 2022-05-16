% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX5 Ref and Rot/Grand Averages'

conditionNames={'RandRandRand','Consistent','Changing', 'RefRefRef','RotRotRot','RefRotRef','RotRefRot'};
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%%TIME WINDOWS
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

%use this to plot ERPs
RandRandRand = selectedData.RandRandRand.data;
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
RefRefRef = selectedData.RefRefRef.data;
RotRotRot = selectedData.RotRotRot.data;
RefRotRef = selectedData.RefRotRef.data;
RotRefRot = selectedData.RotRefRot.data;


DiffConsistent = Consistent - RandRandRand;
DiffChanging = Changing - RandRandRand;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffRotRotRot = RotRotRot - RandRandRand;
DiffRefRotRef = RefRotRef - RandRandRand;
DiffRotRefRot = RotRefRot - RandRandRand;

GFPDiffConsistent = std(DiffConsistent);
GFPDiffChanging = std(DiffChanging);
GFPDiffRefRefRef = std(DiffRefRefRef);
GFPDiffRotRotRot = std(DiffRotRotRot);
GFPDiffRefRotRef = std(DiffRefRotRef);
GFPDiffRotRefRot = std(DiffRotRefRot);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNRefRefRef =mean(DiffRefRefRef(electrodes));
MSPNRefRotRef =mean(DiffRefRotRef(electrodes));
MSPNRotRotRot =mean(DiffRotRotRot(electrodes));
MSPNRotRefRot =mean(DiffRotRefRot(electrodes));

SPNcheck = [MSPNRefRefRef,MSPNRefRotRef,MSPNRotRotRot,MSPNRotRefRot];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRefRefRef,GFPDiffRefRotRef,GFPDiffRotRotRot,GFPDiffRotRefRot];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffRefRefRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRefRefRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRefRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRotRotRot, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRotRotRot,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RotRotRot',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRefRotRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRefRotRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRotRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRotRefRot, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRotRefRot,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RotRefRot',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all



