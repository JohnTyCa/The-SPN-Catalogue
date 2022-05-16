% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 19/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef','RotRotRot','RandRandRef','RandRandRot','RefRefRot','RotRotRef'};

%%TIME WINDOWS
low = 250;
high = 600;  
% 
low = 1650;
high = 2000;  
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
RefRefRef = selectedData.RefRefRef.data;
RotRotRot = selectedData.RotRotRot.data;
RandRandRef = selectedData.RandRandRef.data;
RandRandRot = selectedData.RandRandRot.data;
RefRefRot = selectedData.RefRefRot.data;
RotRotRef = selectedData.RotRotRef.data;

DiffRefRefRef = RefRefRef - RandRandRand;
DiffRotRotRot = RotRotRot - RandRandRand;
DiffRandRandRef = RandRandRef -RandRandRand;
DiffRandRandRot = RandRandRot - RandRandRand;
DiffRefRefRot = RefRefRot-RandRandRand;
DiffRotRotRef = RotRotRef-RandRandRand;

GFPDiffRefRefRef = std(DiffRefRefRef);
GFPDiffRotRotRot = std(DiffRotRotRot);
GFPDiffRandRandRef = std(DiffRandRandRef);
GFPDiffRandRandRot = std(DiffRandRandRot);
GFPDiffRefRefRot = std(DiffRefRefRot);
GFPDiffRotRotRef = std(DiffRotRotRef);

%%%%%%%%%% this is for checking
if high == 600
    electrodes = [25 27 62 64];
    MSPNRefRefRef =mean(DiffRefRefRef(electrodes));
    MSPNRotRotRot =mean(DiffRotRotRot(electrodes));
    MSPNRefRefRot =mean(DiffRefRefRot(electrodes));
    MSPNRotRotRef =mean(DiffRotRotRef(electrodes));
    SPNcheck2a = [MSPNRefRefRef,MSPNRotRotRot,MSPNRefRefRot,MSPNRotRotRef];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffCheck2a = [GFPDiffRefRefRef,GFPDiffRotRotRot,GFPDiffRefRefRot,GFPDiffRotRotRef];
    save('GFPDiffCheck2a','GFPDiffCheck2a');
end
%%%%%%%%

%%%%%%%%%% this is for checking
if high == 2000
    electrodes = [25 27 62 64];
    MSPNRandRandRef =mean(DiffRandRandRef(electrodes));
    MSPNRandRandRot =mean(DiffRandRandRot(electrodes));
    SPNcheck2b = [MSPNRandRandRef,MSPNRandRandRot];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheck2b = [GFPDiffRandRandRef,GFPDiffRandRandRot];
    save('GFPDiffCheck2b','GFPDiffCheck2b');
end
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
topoplot(DiffRefRefRot, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRefRefRot,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RefRefRot',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRotRotRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRotRotRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RotRotRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRandRandRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRandRandRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RandRandRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffRandRandRot, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRandRandRot,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RandRandRot',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all

load SPNcheck2a
load SPNcheck2b

SPNcheck = [SPNcheck2a,SPNcheck2b];
save('SPNcheck2','SPNcheck');

load GFPDiffcheck2a
load GFPDiffcheck2b

GFPDiffCheck = [GFPDiffCheck2a,GFPDiffCheck2b];
save('GFPDiffCheck','GFPDiffCheck');
clear all


