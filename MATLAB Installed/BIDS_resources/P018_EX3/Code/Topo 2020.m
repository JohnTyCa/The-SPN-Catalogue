% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX3 Ref Unpredictable Ori/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRandRand', 'Predictable','Unpredictable'};

%%TIME WINDOWS
low = 250;
high = 600;  
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

RandRandRand = selectedData.RandRandRand.data;
Predictable = selectedData.Predictable.data;
Unpredictable = selectedData.Unpredictable.data;



DiffPredictable = Predictable - RandRandRand;
DiffUnpredictable = Unpredictable - RandRandRand;

GFPDiffPredictable = std(DiffPredictable);
GFPDiffUnpredictable = std(DiffUnpredictable);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64];
MSPNPredictable =mean(DiffPredictable(electrodes));
MSPNUnpredictable =mean(DiffUnpredictable(electrodes));
SPNcheck = [MSPNPredictable,MSPNUnpredictable];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffPredictable,GFPDiffUnpredictable];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffPredictable, channelLocs,'numcontour',contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffPredictable,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Repeated Orientations',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffUnpredictable, channelLocs,'numcontour',contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffUnpredictable,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Changing Orientations',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all



