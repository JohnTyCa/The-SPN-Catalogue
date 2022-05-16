% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 37/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames={'RandRand','SymSym'};

%TIME WINDOWS
low = 200;
high = 350;
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
RandRand= selectedData.RandRand.data;
SymSym = selectedData.SymSym.data;


DiffSymSym= SymSym - RandRand;
GFPDiffSymSym = std(DiffSymSym);

%%%%%%%%%% this is for checking
electrodes = [25 62]; % These will be used if no dogma selected
MSPN =mean(DiffSymSym(electrodes));
SPNcheck = MSPN;
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiffSymSym;%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffSymSym, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymSym,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymSym',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
