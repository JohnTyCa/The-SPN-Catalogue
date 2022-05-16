% topoplots
close all
clear all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH','TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};

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


%save('thisTopo','selectedData');

TargetSym= selectedData.TargetSym.data;
TargetRand = selectedData.TargetRand.data;
SymFlankerH= selectedData.SymFlankerH.data;
SymFlankerV = selectedData.SymFlankerV.data;
RandFlankerH= selectedData.RandFlankerH.data;
RandFlankerV = selectedData.RandFlankerV.data;

DiffTarget= TargetSym - TargetRand;
DiffFlankerH= SymFlankerH - RandFlankerH;
DiffFlankerV= SymFlankerV - RandFlankerV;

TargetSymL= selectedData.TargetSymL.data;
TargetRandL = selectedData.TargetRandL.data;
SymFlankerHL= selectedData.SymFlankerHL.data;
SymFlankerVL = selectedData.SymFlankerVL.data;
RandFlankerHL= selectedData.RandFlankerHL.data;
RandFlankerVL = selectedData.RandFlankerVL.data;

DiffTargetL= TargetSymL - TargetRandL;
DiffFlankerHL= SymFlankerHL - RandFlankerHL;
DiffFlankerVL= SymFlankerVL - RandFlankerVL;

GFPDiffTargetL = std(DiffTargetL);
GFPDiffFlankerHL = std(DiffFlankerHL);
GFPDiffFlankerVL = std(DiffFlankerVL);

TargetSymR= selectedData.TargetSymR.data;
TargetRandR = selectedData.TargetRandR.data;
SymFlankerHR= selectedData.SymFlankerHR.data;
SymFlankerVR = selectedData.SymFlankerVR.data;
RandFlankerHR= selectedData.RandFlankerHR.data;
RandFlankerVR = selectedData.RandFlankerVR.data;

DiffTargetR= TargetSymR - TargetRandR;
DiffFlankerHR= SymFlankerHR - RandFlankerHR;
DiffFlankerVR= SymFlankerVR - RandFlankerVR;

GFPDiffTargetR = std(DiffTargetR);
GFPDiffFlankerHR = std(DiffFlankerHR);
GFPDiffFlankerVR = std(DiffFlankerVR);

%%%%%%%%%% this is for checking
electrodesL = [23 24 25 27];
electrodesR = [60 61 62 64]; 
MSPNTargetR =mean(DiffTargetR(electrodesL));
MSPNFlankerHR =mean(DiffFlankerHR(electrodesL));
MSPNFlankerVR=mean(DiffFlankerVR(electrodesL));

MSPNTargetL =mean(DiffTargetL(electrodesR));
MSPNFlankerHL =mean(DiffFlankerHL(electrodesR));
MSPNFlankerVL=mean(DiffFlankerVL(electrodesR));

SPNcheck = [MSPNTargetR,MSPNFlankerVR,MSPNFlankerHR,MSPNTargetL,MSPNFlankerVL,MSPNFlankerHL];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffTargetR,GFPDiffFlankerVR,GFPDiffFlankerHR,GFPDiffTargetL,GFPDiffFlankerVL,GFPDiffFlankerHL];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

% %For P1 check
% figure('color',[1,1,1])
% topoplot(TargetSymL, channelLocs,'numcontour', contourRes); 
% caxis([-zscale, zscale])
% title('TargetSymL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(TargetSymR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('TargetSymR','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(TargetRandL, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('TargetRandL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(TargetSymR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('TargetRandR','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerVL, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankerVL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerVR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankerVR','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerVL, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankerVL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerVR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankerVR','FontSize',FontSize);
% 
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerHL, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankerHL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(SymFlankerHR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('SymFlankerHR','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerHL, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankerHL','FontSize',FontSize);
% 
% figure('color',[1,1,1])
% topoplot(RandFlankerHR, channelLocs,'numcontour', contourRes);
% caxis([-zscale, zscale])
% title('RandFlankerHR','FontSize',FontSize);



%%%%%%% SPNs
close all
figure('color',[1,1,1])
topoplot(DiffTargetL, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffLCRandSymm, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTargetL,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffTargetL',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffFlankerVL, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlankerVL,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffFlankerVL',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffFlankerHL, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlankerHL,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffFlankerHL',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTargetR, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTargetR,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffTargetR',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffFlankerVR, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlankerVR,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffFlankerVR',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffFlankerHR, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlankerHR,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['DiffFlankerHR',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);



clear
