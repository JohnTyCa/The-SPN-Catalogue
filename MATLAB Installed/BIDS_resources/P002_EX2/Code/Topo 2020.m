close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 2/EX2 Regularity/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean.mat;


%CONDITIONS
conditionNames={'Reflection','Rotation','Random','Translation',};

%TIME WINDOWS
low = 300;
high = 1000;
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

Reflection= selectedData.Reflection.data;
Rotation = selectedData.Rotation.data;
Random = selectedData.Random.data;
Translation = selectedData.Translation.data;


DiffReflection= Reflection - Random;
DiffRotation= Rotation - Random;
DiffTranslation= Translation - Random;
GFPDiffReflection = std(DiffReflection);
GFPDiffRotation = std(DiffRotation);
GFPDiffTranslation = std(DiffTranslation);

%This is for checking
electrodes = [25 62]; 
MSPNRef =mean(DiffReflection(electrodes));
MSPNTrans =mean(DiffTranslation(electrodes));
MSPNRot =mean(DiffRotation(electrodes));
SPNcheck = [MSPNRef,MSPNTrans,MSPNRot];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffReflection,GFPDiffTranslation,GFPDiffRotation];
save('GFPDiffCheck','GFPDiffCheck');



figure('color',[1,1,1])
topoplot(DiffReflection, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffReflection,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Reflection',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRotation, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRotation,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rotation',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTranslation, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTranslation,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Translation',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
