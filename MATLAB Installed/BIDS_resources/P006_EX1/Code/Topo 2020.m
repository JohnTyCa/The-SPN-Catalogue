close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 6/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean.mat;
%CONDITIONS
conditionNames={'ReflectionVertical','TranslationVertical','ReflectionHorizontal','TranslationHorizontal'};


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


%save('thisTopo','selectedData')
ReflectionVertical= selectedData.ReflectionVertical.data;
TranslationVertical = selectedData.TranslationVertical.data;
ReflectionHorizontal= selectedData.ReflectionHorizontal.data;
TranslationHorizontal = selectedData.TranslationHorizontal.data;

DiffVertical= ReflectionVertical - TranslationVertical;
DiffHorizontal= ReflectionHorizontal - TranslationHorizontal;
GFPDiffVertical = std(DiffVertical);
GFPDiffHorizontal = std(DiffHorizontal);

%This is for checking
electrodes = [25 26 27 62 63 64]; % These will be used if no dogma selected
MSPNVertical =mean(DiffVertical(electrodes));
MSPNHorizontal =mean(DiffHorizontal(electrodes));
SPNcheck = [MSPNVertical,MSPNHorizontal];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffVertical,GFPDiffHorizontal];
save('GFPDiffCheck','GFPDiffCheck');


figure('color',[1,1,1])
topoplot(DiffVertical, channelLocs,'numcontour', contourRes,'colormap',cmocean);%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffVertical,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Vertical',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffHorizontal, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffHorizontal,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Horizontal',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
