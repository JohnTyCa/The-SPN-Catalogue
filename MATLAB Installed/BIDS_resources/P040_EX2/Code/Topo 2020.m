% topoplots
close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX2 Crowding Matched/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames={'TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};

%TIME WINDOWS
low = 200;
high = 600;
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


TargetSymLeft= selectedData.TargetSymLeft.data;
TargetRandLeft = selectedData.TargetRandLeft.data;
SymFlankerSLeft= selectedData.SymFlankerSLeft.data;
SymFlankerRLeft = selectedData.SymFlankerRLeft.data;
RandFlankerSLeft= selectedData.RandFlankerSLeft.data;
RandFlankerRLeft = selectedData.RandFlankerRLeft.data;

DiffTargetSymLeft= TargetSymLeft - TargetRandLeft;
DiffSymFlankerSLeft= SymFlankerSLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand
DiffSymFlankerRLeft= SymFlankerRLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand
DiffRandFlankerSLeft=RandFlankerSLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand

TargetSymRight= selectedData.TargetSymRight.data;
TargetRandRight = selectedData.TargetRandRight.data;
SymFlankerSRight= selectedData.SymFlankerSRight.data;
SymFlankerRRight = selectedData.SymFlankerRRight.data;
RandFlankerSRight= selectedData.RandFlankerSRight.data;
RandFlankerRRight = selectedData.RandFlankerRRight.data;

DiffTargetSymRight= TargetSymRight - TargetRandRight;
DiffSymFlankerSRight= SymFlankerSRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand
DiffSymFlankerRRight= SymFlankerRRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand
DiffRandFlankerSRight=RandFlankerSRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand

GFPDiffTargetSymLeft = std(DiffTargetSymLeft);
GFPDiffSymFlankerSLeft = std(DiffSymFlankerSLeft);
GFPDiffSymFlankerRLeft = std(DiffSymFlankerRLeft);
GFPDiffRandFlankerSLeft = std(DiffRandFlankerSLeft);

GFPDiffTargetSymRight = std(DiffTargetSymRight);
GFPDiffSymFlankerSRight = std(DiffSymFlankerSRight);
GFPDiffSymFlankerRRight = std(DiffSymFlankerRRight);
GFPDiffRandFlankerSRight = std(DiffRandFlankerSRight);

%%%%%%%%%% this is for checking
electrodesL = [23 24 25 27];
electrodesR = [60 61 62 64]; 
MSPNTargetSymRight =mean(DiffTargetSymRight(electrodesL));
MSPNSymFlankerSRight =mean(DiffSymFlankerSRight(electrodesL));
MSPNSymFlankerRRight=mean(DiffSymFlankerRRight(electrodesL));
MSPNRandFlankerSRight=mean(DiffRandFlankerSRight(electrodesL));
MSPNTargetSymLeft =mean(DiffTargetSymLeft(electrodesR));
MSPNSymFlankerSLeft =mean(DiffSymFlankerSLeft(electrodesR));
MSPNSymFlankerRLeft=mean(DiffSymFlankerRLeft(electrodesR));
MSPNRandFlankerSLeft=mean(DiffRandFlankerSLeft(electrodesR));
SPNcheck = [MSPNTargetSymRight,MSPNSymFlankerSRight,MSPNSymFlankerRRight,MSPNRandFlankerSRight,MSPNTargetSymLeft,MSPNSymFlankerSLeft,MSPNSymFlankerRLeft,MSPNRandFlankerSLeft];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffTargetSymRight,GFPDiffSymFlankerSRight,GFPDiffSymFlankerRRight,GFPDiffRandFlankerSRight,GFPDiffTargetSymLeft,GFPDiffSymFlankerSLeft,GFPDiffSymFlankerRLeft,GFPDiffRandFlankerSLeft];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

% %For P1 check
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerRLeft, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankersRLeft','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerSLeft, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankersSLeft','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerRRight, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankersRRight','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerSRight, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankersSRight','FontSize',FontSize);
% 
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerRLeft, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankersRLeft','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerSLeft, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankersSLeft','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerRRight, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankersRRight','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerSRight, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankersSRight','FontSize',FontSize);


% SPNs




figure('color',[1,1,1])
topoplot(DiffTargetSymRight, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTargetSymRight,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN234 (DiffTargetSymRight)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymFlankerSRight, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymFlankerSRight,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN235 (DiffSymFlankerSRight)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSymFlankerRRight, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymFlankerRRight,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN236 (DiffSymFlankerRRight)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRandFlankerSRight, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRandFlankerSRight,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN237 (DiffRandFlankerSRight)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTargetSymLeft, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTargetSymLeft,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN238 (DiffTargetSymLeft)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymFlankerSLeft, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymFlankerSLeft,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN239 (DiffSymFlankerSLeft)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSymFlankerRLeft, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymFlankerRLeft,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN240 (DiffSymFlankerRLeft)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRandFlankerSLeft, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRandFlankerSLeft,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SPN241 (DiffRandFlankerSLeft)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);
clear
