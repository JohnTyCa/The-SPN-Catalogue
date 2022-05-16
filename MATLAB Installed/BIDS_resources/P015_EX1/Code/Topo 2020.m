close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 15/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'Reflection','Translation','Circular','Radial','Random'}; 

% %TIME WINDOWS
low = 220;
high = 400;

low = 400;
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

Reflection = selectedData.Reflection.data;
Translation = selectedData.Translation.data;
Circular = selectedData.Circular.data;
Radial = selectedData.Radial.data;
Random = selectedData.Random.data;

DiffReflection = Reflection - Random;
DiffTranslation = Translation - Random;
DiffCircular = Circular - Random;
DiffRadial = Radial - Random;

GFPDiffReflection = std(DiffReflection);
GFPDiffTranslation = std(DiffTranslation);
GFPDiffCircular = std(DiffCircular);
GFPDiffRadial = std(DiffRadial);

%%%%%%%%%% this is for checking
if high == 400
    electrodes = [25 62];
    MSPNReflection =mean(DiffReflection(electrodes));
    MSPNTranslation =mean(DiffTranslation(electrodes));
    MSPNCircular =mean(DiffCircular(electrodes));
    MSPNRadial =mean(DiffRadial(electrodes));
    SPNcheck2a = [MSPNReflection,MSPNTranslation,MSPNCircular,MSPNRadial];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffChecka = [GFPDiffReflection,GFPDiffTranslation,GFPDiffCircular,GFPDiffRadial];
    save('GFPDiffChecka','GFPDiffChecka');
end
%%%%%%%%

%%%%%%%%%% this is for checking
if high == 1000
    electrodes = [25 62];
    MSPNReflection =mean(DiffReflection(electrodes));
    MSPNTranslation =mean(DiffTranslation(electrodes));
    MSPNCircular =mean(DiffCircular(electrodes));
    MSPNRadial =mean(DiffRadial(electrodes));
    SPNcheck2b = [MSPNReflection,MSPNTranslation,MSPNCircular,MSPNRadial];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheckb = [GFPDiffReflection,GFPDiffTranslation,GFPDiffCircular,GFPDiffRadial];
    save('GFPDiffCheckb','GFPDiffCheckb');
end
%%%%%%%%



figure('color',[1,1,1])
topoplot(DiffReflection, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffReflection,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Reflection',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffTranslation, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTranslation,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Translation',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffCircular, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffCircular,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Circular',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRadial, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRadial,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Radial',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all

load SPNcheck2a
load SPNcheck2b

SPNcheck = (SPNcheck2a+SPNcheck2b)/2;
save('SPNcheck2','SPNcheck');

load GFPDiffchecka
load GFPDiffcheckb

GFPDiffCheck = (GFPDiffChecka+GFPDiffCheckb)/2;
save('GFPDiffCheck','GFPDiffCheck');
clear all

