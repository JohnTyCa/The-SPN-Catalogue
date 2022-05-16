% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 34/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames ={'rrs','rro','rno','nrs','nro','nno'};  % 1x4 cell arrays

%TIME WINDOWS
low = 300;
high = 900;
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
rrs= selectedData.rrs.data;
rro = selectedData.rro.data;
rno = selectedData.rno.data;
nrs = selectedData.nrs.data;
nro= selectedData.nro.data;
nno = selectedData.nno.data;

Diffrrs= rrs - nrs;
Diffrro= rro - nro;
Diffrno= rno - nno;

GFPDiffrrs= std(Diffrrs);
GFPDiffrro= std(Diffrro);
GFPDiffrno= std(Diffrno);

%%%%%%%%%% this is for checking
electrodes = [25 24 61 62];
MSPNrrs =mean(Diffrrs(electrodes));
MSPNrro =mean(Diffrro(electrodes));
MSPNrno =mean(Diffrno(electrodes));
SPNcheck = [MSPNrrs,MSPNrro,MSPNrno];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffrrs,GFPDiffrro,GFPDiffrno];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(Diffrrs, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrrs,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rrs',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diffrro, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrro,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rro',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diffrno, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrno,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rno',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all
