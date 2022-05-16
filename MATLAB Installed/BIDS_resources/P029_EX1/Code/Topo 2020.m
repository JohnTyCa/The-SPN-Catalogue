close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 29/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean


%CONDITIONS
conditionNames={'RandomFigure','SymmetryFigure','RandomGround','SymmetryGround'};

%TIME WINDOWS
low = 300
high =600  
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

RandomFigure = selectedData.RandomFigure.data;
SymmetryFigure = selectedData.SymmetryFigure.data;
RandomGround = selectedData.RandomGround.data;
SymmetryGround = selectedData.SymmetryGround.data;


DiffFigure = SymmetryFigure - RandomFigure;
DiffGround = SymmetryGround - RandomGround;

GFPDiffFigure = std(DiffFigure);
GFPDiffGround = std(DiffGround);


%%%%%%%%%% this is for checking
electrodes = [25 26 27 62 63 64];
MSPNFigure =mean(DiffFigure(electrodes));
MSPNGround =mean(DiffGround(electrodes));
SPNcheck = [MSPNFigure,MSPNGround];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffFigure,GFPDiffGround];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffFigure, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFigure,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Figure',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffGround, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffGround,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ground',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all
