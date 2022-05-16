close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 22/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'AS20','S20','Rand20','AS40','S40','Rand40','AS80','S80','Rand80'};

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

AS20=selectedData.AS20.data;
S20=selectedData.S20.data;
Rand20= selectedData.Rand20.data;

AS40=selectedData.AS40.data;
S40=selectedData.S40.data;
Rand40= selectedData.Rand40.data;


AS80=selectedData.AS80.data;
S80=selectedData.S80.data;
Rand80= selectedData.Rand80.data;

DiffAS20 = AS20-Rand20;
DiffS20 = S20-Rand20;

DiffAS40 = AS40-Rand40;
DiffS40 = S40-Rand40;

DiffAS80 = AS80-Rand80;
DiffS80 = S80-Rand80;

GFPDiffAS20 = std(DiffAS20);
GFPDiffS20 = std(DiffS20);
GFPDiffAS40= std(DiffAS40);
GFPDiffS40= std(DiffS40);
GFPDiffAS80= std(DiffAS80);
GFPDiffS80= std(DiffS80);


%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNAS20 =mean(DiffAS20(electrodes));
MSPNS20 =mean(DiffS20(electrodes));
MSPNAS40 =mean(DiffAS40(electrodes));
MSPNS40 =mean(DiffS40(electrodes));
MSPNAS80 =mean(DiffAS80(electrodes));
MSPNS80 =mean(DiffS80(electrodes));

SPNcheck = [MSPNAS20,MSPNS20,MSPNAS40,MSPNS40,MSPNAS80,MSPNS80];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffAS20,GFPDiffS20,GFPDiffAS40,GFPDiffS40,GFPDiffAS80,GFPDiffS80];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffAS20, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAS20,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Anti Symmetry 20',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffAS40, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAS40,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Anti Symmetry 40',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffAS80, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAS80,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Anti Symmetry 80',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffS20, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffS20,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry 20',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffS40, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffS40,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry 40',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffS80, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffS80,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symmetry 80',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);
clear all