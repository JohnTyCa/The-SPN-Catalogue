close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 32/EX1 ContrastStereoCombined/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean

%CONDITIONS
conditionNames={'BinocularSym', 'BinocularAsym','ContrastSym','ContrastAsym','CombinedSym','CombinedAsym'};

%TIME WINDOWS
low = 400;
high = 1500;
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
BinocularSym = selectedData.BinocularSym.data;
BinocularAsym = selectedData.BinocularAsym.data;
ContrastSym = selectedData.ContrastSym.data;
ContrastAsym = selectedData.ContrastAsym.data;
CombinedSym = selectedData.CombinedSym.data;
CombinedAsym = selectedData.CombinedAsym.data;


DiffBinocular  = BinocularSym  - BinocularAsym;
DiffContrast   = ContrastSym - ContrastAsym;
DiffCombined  = CombinedSym - CombinedAsym;

GFPDiffBinocular = std(DiffBinocular);
GFPDiffContrast = std(DiffContrast);
GFPDiffCombined = std(DiffCombined)

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64];
MSPNBinocular =mean(DiffBinocular(electrodes));
MSPNContrast =mean(DiffContrast(electrodes));
MSPNCombined =mean(DiffCombined(electrodes));
SPNcheck = [MSPNBinocular,MSPNContrast,MSPNCombined];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffBinocular,GFPDiffContrast,GFPDiffCombined];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffBinocular, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffBinocular,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Binocular',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffContrast, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffContrast,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Contrast',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffCombined, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffCombined,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Combined',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all
