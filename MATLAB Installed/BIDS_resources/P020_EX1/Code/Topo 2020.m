close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 20/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandsBlack','RandsWhite','RandsBWB','RandsWBW','RefsBlack','RefsWhite','RefsBWB','RefsWBW','RandsConsistent','RandsChanging','RefsConsistent','RefsChanging'};

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

RefsConsistent = selectedData.RefsConsistent.data;
RefsChanging = selectedData.RefsChanging.data;
RandsConsistent = selectedData.RandsConsistent.data;
RandsChanging = selectedData.RandsChanging.data;

RefsWhite = selectedData.RefsWhite.data;
RefsWhite = selectedData.RefsWhite.data;
RandsWhite = selectedData.RandsWhite.data;
RandsWhite = selectedData.RandsWhite.data;

RefsBlack = selectedData.RefsBlack.data;
RefsBlack= selectedData.RefsBlack.data;
RandsBlack = selectedData.RandsBlack.data;
RandsBlack = selectedData.RandsBlack.data;

RefsBWB = selectedData.RefsBWB.data;
RefsBWB= selectedData.RefsBWB.data;
RandsBWB = selectedData.RandsBWB.data;
RandsBWB = selectedData.RandsBWB.data;

RefsWBW = selectedData.RefsWBW.data;
RefsWBW= selectedData.RefsWBW.data;
RandsWBW = selectedData.RandsWBW.data;
RandsWBW = selectedData.RandsWBW.data;


DiffBlack = RefsBlack-RandsBlack;
DiffWhite  = RefsWhite-RandsWhite ;
DiffWBW = RefsWBW-RandsWBW;
DiffBWB = RefsBWB-RandsBWB;

GFPDiffBlack = std(DiffBlack);
GFPDiffWhite = std(DiffWhite);
GFPDiffWBW = std(DiffWBW);
GFPDiffBWB = std(DiffBWB);


%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNBlack =mean(DiffBlack(electrodes));
MSPNWhite =mean(DiffWhite(electrodes));
MSPNBWB =mean(DiffBWB(electrodes));
MSPNWBW =mean(DiffWBW(electrodes));
SPNcheck = [MSPNBlack,MSPNWhite,MSPNBWB,MSPNWBW];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffBlack,GFPDiffWhite,GFPDiffBWB,GFPDiffWBW];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffBlack, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffBlack,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Black',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffWhite, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffWhite,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['White',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffBWB, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffBWB,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['BWB',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffWBW, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffWBW,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['WBW',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all