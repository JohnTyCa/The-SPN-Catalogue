close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 8/EX1 W Ref and Rep/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat;
%CONDITIONS
conditionNames={'Rand20','Rand60','Rand100','Ref20','Ref60','Ref100','Trans20','Trans60','Trans100','Random','Reflection','Translation'};

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


%save('thisTopo','selectedData');
Random= selectedData.Random.data;
Ref20 = selectedData.Ref20.data;
Ref60 = selectedData.Ref60.data;
Ref100 = selectedData.Ref100.data;
Trans20 = selectedData.Trans20.data;
Trans60 = selectedData.Trans60.data;
Trans100 = selectedData.Trans100.data;

DiffRef20= Ref20 - Random;
DiffRef60= Ref60 - Random;
DiffRef100= Ref100 - Random;
DiffTrans20= Trans20 - Random;
DiffTrans60= Trans60 - Random;
DiffTrans100= Trans100 - Random;

GFPDiffRef20 = std(DiffRef20);
GFPDiffRef60 = std(DiffRef60);
GFPDiffRef100 = std(DiffRef100);
GFPDiffTrans20 = std(DiffTrans20);
GFPDiffTrans60 = std(DiffTrans60);
GFPDiffTrans100 = std(DiffTrans100);


%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNRef20 =mean(DiffRef20(electrodes));
MSPNRef60 =mean(DiffRef60(electrodes));
MSPNRef100 =mean(DiffRef100(electrodes));
MSPNTrans20 =mean(DiffTrans20(electrodes));
MSPNTrans60 =mean(DiffTrans60(electrodes));
MSPNTrans100 =mean(DiffTrans100(electrodes));
SPNcheck = [MSPNRef20,MSPNRef60,MSPNRef100,MSPNTrans20,MSPNTrans60,MSPNTrans100];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRef20,GFPDiffRef60,GFPDiffRef100,GFPDiffTrans20,GFPDiffTrans60,GFPDiffTrans100];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffRef20, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef20,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref20',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef60, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef60,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref60',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef100, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef100,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Ref100',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTrans20, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTrans20,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rep20',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTrans60, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTrans60,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rep60',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTrans100, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTrans100,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rep100',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);
clear
