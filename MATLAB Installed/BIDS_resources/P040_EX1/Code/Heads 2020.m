% topoplots
close all
clear all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX1 Crowding HV/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat

%CONDITIONS
conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH','TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};

%TIME WINDOWS
low = 200;
high = 600;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale = 3;  
contourRes = 3;

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

DiffTargetSym= TargetSym - TargetRand;
DiffSymFlankerH= SymFlankerH - RandFlankerH;
DiffSymFlankerV= SymFlankerV - RandFlankerV;

TargetSymL= selectedData.TargetSymL.data;
TargetRandL = selectedData.TargetRandL.data;
SymFlankerHL= selectedData.SymFlankerHL.data;
SymFlankerVL = selectedData.SymFlankerVL.data;
RandFlankerHL= selectedData.RandFlankerHL.data;
RandFlankerVL = selectedData.RandFlankerVL.data;

DiffTargetSymL= TargetSymL - TargetRandL;
DiffSymFlankerHL= SymFlankerHL - RandFlankerHL;
DiffSymFlankerVL= SymFlankerVL - RandFlankerVL;

TargetSymR= selectedData.TargetSymR.data;
TargetRandR = selectedData.TargetRandR.data;
SymFlankerHR= selectedData.SymFlankerHR.data;
SymFlankerVR = selectedData.SymFlankerVR.data;
RandFlankerHR= selectedData.RandFlankerHR.data;
RandFlankerVR = selectedData.RandFlankerVR.data;

DiffTargetSymR= TargetSymR - TargetRandR;
DiffSymFlankerHR= SymFlankerHR - RandFlankerHR;
DiffSymFlankerVR= SymFlankerVR - RandFlankerVR;


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
%topoplot(DiffTargetSymL, channelLocs,'numcontour', contourRes);
headplot(DiffTargetSymL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('TargetL','FontSize',FontSize);
%toponame = ['TargetRefL',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['TargetRefLHead',(num2str(low)),'-',num2str(high),'.png'];

saveas(gcf,toponame);

figure('color',[1,1,1])
%topoplot(DiffSymFlankerVL, channelLocs,'numcontour', contourRes);
headplot(DiffSymFlankerVL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('VerticalFlankersL','FontSize',FontSize);
%toponame = ['Ref-VerticalFlankersL',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['Ref-VerticalFlankersL',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
%topoplot(DiffSymFlankerHL, channelLocs,'numcontour', contourRes);
headplot(DiffSymFlankerVL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('HorizontalFlankersL','FontSize',FontSize);
%toponame = ['Ref-HorizontalFlankersL',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['Ref-HorizontalFlankersLhead',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
%topoplot(DiffTargetSymR, channelLocs,'numcontour', contourRes);
headplot(DiffSymFlankerVL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('TargetR','FontSize',FontSize);
%toponame = ['TargetRefR',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['TargetRefRhead',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
%topoplot(DiffSymFlankerVR, channelLocs,'numcontour', contourRes);
headplot(DiffSymFlankerVL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('VerticalFlankersR','FontSize',FontSize);
%toponame = ['Ref-VerticalFlankersR',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['Ref-VerticalFlankersRhead',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
%topoplot(DiffSymFlankerHR, channelLocs,'numcontour', contourRes);
headplot(DiffSymFlankerVL, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
title('HorizontalFlankersR','FontSize',FontSize);
%toponame = ['Ref-HorizontalFlankersR',(num2str(low)),'-',num2str(high),'.png'];
toponame = ['Ref-HorizontalFlankersRhead',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);



clear
