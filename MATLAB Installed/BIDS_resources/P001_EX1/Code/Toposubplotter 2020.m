% topoplots
close all
clear all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 1/EX1 Reflection/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat;

%CONDITIONS
conditionNames={'Regular','Random'};

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale = 3;  
contourRes = 3;

timeWindows= {[-200,-100],[-100 0],[0 100],[100 200],[200 300],[300 400],[400 500],[500 600],[600 700],[700 800],[800 900],[900 1000]}
l=length(timeWindows)
for t =1:l
    
%TIME WINDOWS
w = timeWindows{t}
low = w(1);
high = w(2);
ii = find(timeVector >=low & timeVector <=high);


% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');
Random= selectedData.Random.data;
Regular = selectedData.Regular.data;
Diff= Regular - Random;

%figure('color',[1,1,1])
subplot(2,l/2,t);
topoplot(Diff, channelLocs,'numcontour', contourRes);

%colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
%title('Reflection','FontSize',FontSize);

end
toponame = ['ReflectionSubplots.png'];
saveas(gcf,toponame);
clear


