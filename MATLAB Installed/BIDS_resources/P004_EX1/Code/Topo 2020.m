close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat;
%CONDITIONS
conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

%TIME WINDOWS
low = 250;
high = 1000;
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

%use this to plot ERPs
RandomGoodValence= selectedData.RandomGoodValence.data;
RandomBadValence = selectedData.RandomBadValence.data;
ReflectionGoodValence= selectedData.ReflectionGoodValence.data;
ReflectionBadValence = selectedData.ReflectionBadValence.data;
RandomGoodRegularity= selectedData.RandomGoodRegularity.data;
RandomBadRegularity = selectedData.RandomBadRegularity.data;
ReflectionGoodRegularity= selectedData.ReflectionGoodRegularity.data;
ReflectionBadRegularity = selectedData.ReflectionBadRegularity.data;

DiffGoodValence = ReflectionGoodValence - RandomGoodValence;
DiffBadValence = ReflectionBadValence - RandomBadValence;
DiffGoodRegularity = ReflectionGoodRegularity - RandomGoodRegularity;
DiffBadRegularity = ReflectionBadRegularity - RandomBadRegularity;

GFPDiffGoodValence = std(DiffGoodValence);
GFPDiffBadValence = std(DiffBadValence);
GFPDiffGoodRegularity = std(DiffGoodRegularity);
GFPDiffBadRegularity = std(DiffBadRegularity);


%This is for checking
electrodes = [22 23 24 25 59 60 61 62]; % Left and right (Scott et al. 2009)
MSPNGoodValence =mean(DiffGoodValence(electrodes));
MSPNBadValence =mean(DiffBadValence(electrodes));
MSPNGoodRegularity =mean(DiffGoodRegularity(electrodes));
MSPNBadRegularity =mean(DiffBadRegularity(electrodes));
SPNcheck = [MSPNGoodValence,MSPNBadValence,MSPNGoodRegularity,MSPNBadRegularity];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffGoodValence,GFPDiffBadValence,GFPDiffGoodRegularity,GFPDiffBadRegularity];
save('GFPDiffCheck','GFPDiffCheck');


figure('color',[1,1,1])
topoplot(DiffGoodValence, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffGoodValence,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['GoodValence',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffBadValence, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffBadValence,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['BadValence',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffGoodRegularity, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffGoodRegularity,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['GoodRegularity',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffBadRegularity, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffBadRegularity,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['BadRegularity',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
