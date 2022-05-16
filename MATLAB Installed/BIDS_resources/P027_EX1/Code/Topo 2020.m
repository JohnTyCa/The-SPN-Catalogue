close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 27/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames = {'Random','Glass', 'Reflection','Translation'};

%TIME WINDOWS
low = 300
high =1000  
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

Random=selectedData.Random.data;
Glass=selectedData.Glass.data;
Reflection= selectedData.Reflection.data;
Translation=selectedData.Translation.data;

DiffGlass = Glass-Random;
DiffReflection = Reflection-Random;
DiffTranslation = Translation-Random;

GFPDiffGlass = std(DiffGlass);
GFPDiffReflection = std(DiffReflection);
GFPDiffTranslation = std(DiffTranslation);

%%%%%%%%%% this is for checking
electrodes = [25 62]; % PO7 O1 O2 PO8
MSPNGlass =mean(DiffGlass(electrodes));
MSPNReflection =mean(DiffReflection(electrodes));
MSPNTranslation=mean(DiffTranslation(electrodes));
SPNcheck = [MSPNGlass,MSPNReflection,MSPNTranslation];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffGlass,GFPDiffReflection,GFPDiffTranslation];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffGlass, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffGlass,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Glass',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffReflection, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffReflection,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Reflection',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTranslation, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffTranslation,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Translation',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all