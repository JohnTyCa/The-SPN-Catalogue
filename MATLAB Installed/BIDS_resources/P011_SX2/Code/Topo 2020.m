close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex2/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames={'SymSym','RandRand','SymSymCorrect','RandRandCorrect','SymSymIncorrect','RandRandIncorrect','SymSymSame','RandRandSame','SymSymDiff','RandRandDiff'};


%TIME WINDOWS
low = 200;
high = 350;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =5
contourRes = 0;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end

%save('thisTopo','selectedData');
DiffSymSym = selectedData.SymSym.data - selectedData.RandRand.data;
DiffSymSymCorrect = selectedData.SymSymCorrect.data - selectedData.RandRandCorrect.data;
DiffSymSymIncorrect = selectedData.SymSymIncorrect.data - selectedData.RandRandIncorrect.data;
DiffSymSymSame = selectedData.SymSymSame.data - selectedData.RandRandSame.data;
DiffSymSymDiff = selectedData.SymSymDiff.data - selectedData.RandRandDiff.data;

GFPDiffSymSym = std(DiffSymSym);
GFPDiffSymSymCorrect = std(DiffSymSymCorrect);
GFPDiffSymSymIncorrect = std(DiffSymSymIncorrect);
GFPDiffSymSymSame =  std(DiffSymSymSame);
GFPDiffSymSymDiff =  std(DiffSymSymDiff);

%%%%%%%%%% this is for checking
electrodes = [25 62]; % These will be used if no dogma selected
MSPN =mean(DiffSymSym(electrodes));

SPNcheck = MSPN;
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiffSymSym
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffSymSym, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
 colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymSym,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry - Random',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymSymCorrect, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
%colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymSymCorrect,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryCorrect - RandomCorrect',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymSymIncorrect, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymSymIncorrect,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryIncorrect - RandomIncorrect',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymSymSame, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymSymSame,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetrySame - RandomSame',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSymSymDiff, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymSymDiff,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryDifferent - RandomDifferent',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all