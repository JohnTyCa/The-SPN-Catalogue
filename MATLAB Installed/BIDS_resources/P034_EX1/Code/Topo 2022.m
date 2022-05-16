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
rrs= selectedData.rrs.data;
rro = selectedData.rro.data;
rno = selectedData.rno.data;
nrs = selectedData.nrs.data;
nro= selectedData.nro.data;
nno = selectedData.nno.data;

Diffrrs= rrs - nno;
Diffrro= rro - nno;
Diffrno= rno - nno;
Diffnrs= nrs - nno;
Diffnro= nro - nno;



GFPDiffrrs= std(Diffrrs);
GFPDiffrro= std(Diffrro);
GFPDiffrno= std(Diffrno);
GFPDiffnrs= std(Diffnrs);
GFPDiffnro= std(Diffnro);

figure('color',[1,1,1])
topoplot(Diffrrs, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrrs,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rrs2022',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diffrro, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrro,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rro2022',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(Diffrno, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffrno,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['rno2022',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(Diffnrs, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffnrs,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['nrs2022',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(Diffnro, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffnro,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['nro2022',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all
