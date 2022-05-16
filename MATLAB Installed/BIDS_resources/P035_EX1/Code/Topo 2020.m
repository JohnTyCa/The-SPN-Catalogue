% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 35/EX1 Disc Color/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'Full','Occluded','Overlapped','Random'};

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
Full= selectedData.Full.data;
Occluded = selectedData.Occluded.data;
Overlapped = selectedData.Overlapped.data;
Random = selectedData.Random.data;

DiffFull= Full - Random;
DiffOccluded= Occluded - Random;
DiffOverlapped= Overlapped - Random;

GFPDiffFull= std(DiffFull);
GFPDiffOccluded= std(DiffOccluded);
GFPDiffOverlapped= std(DiffOverlapped);

%%%%%%%%%% this is for checking
electrodes = [25 62]; 
MSPNFull =mean(DiffFull(electrodes));
MSPNOccluded =mean(DiffOccluded(electrodes));
MSPNOverlapped =mean(DiffOverlapped(electrodes));
SPNcheck = [MSPNFull,MSPNOccluded,MSPNOverlapped];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffFull,GFPDiffOccluded,GFPDiffOverlapped]%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffFull, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffFull,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Full',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffOccluded, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffOccluded,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Occluded',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffOverlapped, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffOverlapped,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Overlapped',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);



clear
