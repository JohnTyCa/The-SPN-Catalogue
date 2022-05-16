close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/EX2 Color matching task/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames={'SymmetryFirst','RandomFirst','SymmetrySecond','RandomSecond','Sym1Sym1','Rand1Rand1','x1Sym2','x1Rand2','SymRand','RandSym','Sym1Sym2','Rand1Rand2','Same','Different'};

%TIME WINDOWS
low = 200;
high = 500;
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

SymmetryFirst = selectedData.SymmetryFirst.data;
RandomFirst = selectedData.RandomFirst.data;
DiffSymmetryFirst = SymmetryFirst-RandomFirst;
GFPDiffSymmetryFirst = std(DiffSymmetryFirst);

%%%%%%%%%% this is for checking
electrodes = [25 62]; % These will be used if no dogma selected
MSPN =mean(DiffSymmetryFirst(electrodes));
SPNcheck = MSPN;
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiffSymmetryFirst%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffSymmetryFirst, channelLocs,'numcontour',contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSymmetryFirst,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryFirst',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all

