% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 32/EX2 FigureGround/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean

%CONDITIONS
conditionNames={'FigureSym', 'GroundSym','FigureAsym','GroundAsym'};

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
FigureSym= selectedData.FigureSym.data;
GroundSym = selectedData.GroundSym.data;
FigureAsym = selectedData.FigureAsym.data;
GroundAsym = selectedData.GroundAsym.data;

DiffFigure  = FigureSym  - FigureAsym;
DiffGround   = GroundSym - GroundAsym;

GFPDiffFigure = std(DiffFigure);
GFPDiffGround = std(DiffGround);
%%%%%%%%%% this is for checking
electrodes = [25 27 62 64];
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
