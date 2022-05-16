clear
% you will need to set this to a directory on your computer
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages';
cd(folder1)
cd(folder1);
subjects = 48;
%ELECTRODES

electrodes = [21 22 25 26];

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;

conditionNames={'RandRandRand','RANDREFs','REFrREFlREFr'};

for i = 1:subjects
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVG.mat'];
        load(n)
        data = mean(condAVG(electrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerror.(c).amplitudes(i,:) = data';
    end  
end


% What diffrence waves do you want? 

ERPerror.RANDREFsSPN.amplitudes = ERPerror.RANDREFs.amplitudes- ERPerror.RandRandRand.amplitudes;
ERPerror.REFrREFlREFrSPN.amplitudes = ERPerror.REFrREFlREFr.amplitudes- ERPerror.RandRandRand.amplitudes;


conditionNames={'RandRandRand','RANDREFs','REFrREFlREFr','RANDREFsSPN','REFrREFlREFrSPN'};
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerrorLeft','ERPerror');
clear all


clear
% you will need to set this to a directory on your computer
folder1 =  '/Volumes/SPN Catalog/Expanded Catalogue/Project 18/EX2 Left and Right With Eye Tracking'
folder2 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages'
cd(folder1)
cd(folder1);
subjects = 48;
%ELECTRODES

electrodes = [21 22 25 26];

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;

conditionNames={'RandRandRand','REFRANDs','REFlREFrREFl'};

for i = 1:subjects
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVG.mat'];
        load(n)
        data = mean(condAVG(electrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerror.(c).amplitudes(i,:) = data';
    end  
end


% What diffrence waves do you want? 

ERPerror.REFRANDsSPN.amplitudes = ERPerror.REFRANDs.amplitudes- ERPerror.RandRandRand.amplitudes;
ERPerror.REFlREFrREFlSPN.amplitudes = ERPerror.REFlREFrREFl.amplitudes- ERPerror.RandRandRand.amplitudes;


conditionNames={'RandRandRand','REFRANDs','REFlREFrREFl','REFRANDsSPN','REFlREFrREFlSPN'};
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerrorRight','ERPerror');
clear all