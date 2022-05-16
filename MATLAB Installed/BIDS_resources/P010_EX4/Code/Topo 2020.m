close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 10/EX4 Two halves/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs;
load cmocean.mat;
%CONDITIONS
conditionNames={'Random','Reflection'};

%TIME WINDOWS
low = 800;
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

Reflection = selectedData.Reflection.data;
Random = selectedData.Random.data;

DiffReflection = Reflection - Random;
GFPDiff = std(DiffReflection);

%%%%%%%%%% this is for checking
electrodes = [24 25 62 61]; %P7 P8 PO7 PO8
MSPN =mean(DiffReflection(electrodes));
SPNcheck = MSPN; % take from CIwaves
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiff%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffReflection, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize);
caxis([-zscale, zscale]);

t =['GFP=',num2str(round(GFPDiff,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Reflection',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all
