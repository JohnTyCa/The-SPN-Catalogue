close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 8/EX3 Naxes/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat;
%CONDITIONS
conditionNames = {'Rand' 'Ref1', 'Ref2', 'Ref3', 'Ref4', 'Ref5'};



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
Rand= selectedData.Rand.data;
Ref1 = selectedData.Ref1.data;
Ref2 = selectedData.Ref2.data;
Ref3 = selectedData.Ref3.data;
Ref4 = selectedData.Ref4.data;
Ref5 = selectedData.Ref5.data;




DiffRef1= Ref1 - Rand;
DiffRef2= Ref2 - Rand;
DiffRef3= Ref3 - Rand;
DiffRef4= Ref4 - Rand;
DiffRef5= Ref5 - Rand;

GFPDiffRef1 = std(DiffRef1);
GFPDiffRef2 = std(DiffRef2);
GFPDiffRef3 = std(DiffRef3);
GFPDiffRef4 = std(DiffRef4);
GFPDiffRef5 = std(DiffRef5);

%%%%%%%%%% this is for checking
electrodes = [25 62];
MSPNRef1 =mean(DiffRef1(electrodes));
MSPNRef2 =mean(DiffRef2(electrodes));
MSPNRef3 =mean(DiffRef3(electrodes));
MSPNRef4 =mean(DiffRef4(electrodes));
MSPNRef5 =mean(DiffRef5(electrodes));
SPNcheck = [MSPNRef1,MSPNRef2,MSPNRef3,MSPNRef4,MSPNRef5];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRef1,GFPDiffRef2,GFPDiffRef3,GFPDiffRef4,GFPDiffRef5];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffRef1, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef1,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['1F',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef2, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef2,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['2F',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef3, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef3,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['3F',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef4, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef4,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['4F',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRef5, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRef5,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['5F',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear