close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 23/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'AntiSymmBW','SymmBW','RandBW','AntiSymmCol','SymmCol','RandCol'};


%TIME WINDOWS
low = 300
high =1000;  
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
AntiSymmBW=selectedData.AntiSymmBW.data;
SymmBW=selectedData.SymmBW.data;
RandBW= selectedData.RandBW.data;
AntiSymmCol=selectedData.AntiSymmCol.data;
SymmCol=selectedData.SymmCol.data;
RandCol= selectedData.RandCol.data;

DiffAntiSymmBW = AntiSymmBW-RandBW;
DiffSymmBW = SymmBW-RandBW;
DiffAntiSymmCol = AntiSymmCol-RandCol;
DiffSymmCol = SymmCol-RandCol;


GFPDiffAntiSymmBW = std(DiffAntiSymmBW);
GFPDiffSymmBW = std(DiffSymmBW);
GFPDiffAntiSymmCol = std(DiffAntiSymmCol);
GFPDiffSymmCol = std(DiffSymmCol);

%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNAntiSymmBW =mean(DiffAntiSymmBW(electrodes));
MSPNSymmBW =mean(DiffSymmBW(electrodes));
MSPNAntiSymmCol =mean(DiffAntiSymmCol(electrodes));
MSPNSymmCol =mean(DiffSymmCol(electrodes));
SPNcheck = [MSPNAntiSymmBW,MSPNSymmBW,MSPNAntiSymmCol,MSPNSymmCol];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffAntiSymmBW,GFPDiffSymmBW,GFPDiffAntiSymmCol,GFPDiffSymmCol];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffAntiSymmBW, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAntiSymmBW,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Anti Symmetry BW',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymmBW, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmBW,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry BW',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffAntiSymmCol, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAntiSymmCol,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Anti Symmetry Col',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymmCol, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmCol,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry Col',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all