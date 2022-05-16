% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 33/EX2 Luminance/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames={'RandFlatGabors','SymFlatGabors','RandSlantGabors','SymSlantGabors','RandFlatSolidPoly','SymFlatSolidPoly','RandSlantSolidPoly','SymSlantSolidPoly'};

%TIME WINDOWS
low = 300;
high = 1000;
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
RandFlatGabors= selectedData.RandFlatGabors.data;
SymFlatGabors = selectedData.SymFlatGabors.data;
RandSlantGabors = selectedData.RandSlantGabors.data;
SymSlantGabors = selectedData.SymSlantGabors.data;
RandFlatSolidPoly= selectedData.RandFlatSolidPoly.data;
SymFlatSolidPoly = selectedData.SymFlatSolidPoly.data;
RandSlantSolidPoly = selectedData.RandSlantSolidPoly.data;
SymSlantSolidPoly = selectedData.SymSlantSolidPoly.data;


DiffFlatGabors  = SymFlatGabors  - RandFlatGabors;
DiffSlantGabors   = SymSlantGabors - RandSlantGabors;
DiffFlatSolidPoly  = SymFlatSolidPoly  - RandFlatSolidPoly;
DiffSlantSolidPoly   = SymSlantSolidPoly - RandSlantSolidPoly;

GFPDiffFlatGabors = std(DiffFlatGabors);
GFPDiffSlantGabors = std(DiffSlantGabors);
GFPDiffFlatSolidPoly = std(DiffFlatSolidPoly);
GFPDiffSlantSolidPoly = std(DiffSlantSolidPoly);


%%%%%%%%%% this is for checking
electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64];
MSPNFlatGabors =mean(DiffFlatGabors(electrodes));
MSPNSlantGabors =mean(DiffSlantGabors(electrodes));
MSPNFlatSolidPoly =mean(DiffFlatSolidPoly(electrodes));
MSPNSlantSolidPoly =mean(DiffSlantSolidPoly(electrodes));
SPNcheck = [MSPNFlatGabors,MSPNSlantGabors,MSPNFlatSolidPoly,MSPNSlantSolidPoly];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffFlatGabors,GFPDiffSlantGabors,GFPDiffFlatSolidPoly,GFPDiffSlantSolidPoly];%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffFlatGabors, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlatGabors,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['FlatGabors',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSlantGabors, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSlantGabors,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SlantGabors',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffFlatSolidPoly, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlatSolidPoly,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['FlatSolidPoly',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSlantSolidPoly, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSlantSolidPoly,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SlantSolidPoly',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all
