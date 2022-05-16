clear
% you will need to set this to a directory on your computer
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 20';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 20/Grand Averages'
cd(folder1);
nSubjects = 25;
skip = [11 21 23];
subjects = nSubjects-length(skip)

%ELECTRODES
electrodes = [25 27 62 64];
d = input('which dogma?')

if d ==1;
    disp 'dogma 1'
    electrodes = [25 27 62 64]; 
end

if d ==2;
    disp 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3;
    disp 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4;
    disp 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5;
    disp 'dogmatic right'
    electrodes = [62 64];
end

if d < 1|d> 5;
    disp('Original electrodes used');
end

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;


conditionNames={'RandsBlack','RandsWhite','RandsBWB','RandsWBW','RefsBlack','RefsWhite','RefsBWB','RefsWBW'};

p = 0
for i = 1:nSubjects
   
    if ismember(i,skip)
       continue
    end
    p = p+1;
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVG.mat'];
        load(n)
        data = mean(condAVG(electrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerror.(c).amplitudes(p,:) = data';
    end  
end

% What diffrence waves do you want? 

ERPerror.BlackSPN.amplitudes = ERPerror.RefsBlack.amplitudes- ERPerror.RandsBlack.amplitudes;
ERPerror.WhiteSPN.amplitudes = ERPerror.RefsWhite.amplitudes- ERPerror.RandsWhite.amplitudes;
ERPerror.BWBSPN.amplitudes = ERPerror.RefsBWB.amplitudes- ERPerror.RandsBWB.amplitudes;
ERPerror.WBWSPN.amplitudes = ERPerror.RefsWBW.amplitudes- ERPerror.RandsWBW.amplitudes;


conditionNames={'RandsBlack','RandsWhite','RandsBWB','RandsWBW','RefsBlack','RefsWhite','RefsBWB','RefsWBW','BlackSPN','WhiteSPN','BWBSPN','WBWSPN'};

for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerror','ERPerror');
clear all