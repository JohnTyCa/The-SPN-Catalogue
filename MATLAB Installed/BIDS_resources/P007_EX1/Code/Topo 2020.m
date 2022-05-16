close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 7/EX1 Disc Reg/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean.mat;
%CONDITIONS
conditionNames = {'ReflectionFlat','ReflectionSlant', 'RandomFlat','RandomSlant'};

%TIME WINDOWS
low = 300;
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


%save('thisTopo','selectedData')
ReflectionFlat= selectedData.ReflectionFlat.data;
ReflectionSlant= selectedData.ReflectionSlant.data;
RandomFlat= selectedData.RandomFlat.data;
RandomSlant= selectedData.RandomSlant.data;

DiffFlat= ReflectionFlat - RandomFlat;
DiffSlant= ReflectionSlant - RandomSlant;

GFPDiffFlat = std(DiffFlat);
GFPDiffSlant = std(DiffSlant);

%%%%%%%%%% this is for checking
electrodes = [20 21 22 23 25 26 57 58 59 60 62 63];
MSPNFlat =mean(DiffFlat(electrodes));
MSPNSlant =mean(DiffSlant(electrodes));
SPNcheck = [MSPNFlat,MSPNSlant];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffFlat,GFPDiffSlant];%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%



figure('color',[1,1,1])
topoplot(DiffFlat, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFlat,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Flat',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSlant, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffSlant,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Slant',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
