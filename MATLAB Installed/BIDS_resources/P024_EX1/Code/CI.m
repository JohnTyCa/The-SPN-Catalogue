clear all
% you will need to set this to a directory on your computer
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24/Grand Averages';
cd(folder1)
subjects = 48;
load timeVector

conditionNames={'LCRandRand','LCRandSymm','LCSymmRand','RCRandRand','RCRandSymm','RCSymmRand'}; 
hemisphere= input('which hemisphere?');


if strcmp(hemisphere, 'left') == 1
    electrodes = [23 25 26 27]; % These will be used if no dogma selected
    name = 'ERPErrorLeftBrain';
end

if strcmp(hemisphere, 'right') == 1
    electrodes = [60 62 63 64]; % These will be used if no dogma selected
    name = 'ERPErrorRightBrain';
end


d = input('which dogma?');
if d ==1
    disp 'dogma 1'
    if strcmp(hemisphere, 'left') == 1
        electrodes = [25 27]; 
    end
    
    if strcmp(hemisphere, 'right') == 1
        electrodes = [62 64]; 
    end
end

if d ==2
    disp 'dogma 2'

    if strcmp(hemisphere, 'left') == 1
        electrodes = [25]; 
    end
    if strcmp(hemisphere, 'right') == 1
        electrodes = [62]; 
    end
end

if d == 3
    disp 'dogma 3'
    if strcmp(hemisphere, 'left') == 1
        electrodes = [20 21 22 23 24 25 26 27];
    end
    if strcmp(hemisphere, 'right') == 1
        electrodes = [57 58 59 60 61 62 63 64];
    end
end


if d < 1||d> 3
    disp('Original electrodes used');
end


%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



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

ERPerror.LCRandSymmSPN.amplitudes = ERPerror.LCRandSymm.amplitudes- ERPerror.LCRandRand.amplitudes; 
ERPerror.LCSymmRandSPN.amplitudes = ERPerror.LCSymmRand.amplitudes- ERPerror.LCRandRand.amplitudes;

ERPerror.RCRandSymmSPN.amplitudes = ERPerror.RCRandSymm.amplitudes- ERPerror.RCRandRand.amplitudes; 
ERPerror.RCSymmRandSPN.amplitudes = ERPerror.RCSymmRand.amplitudes- ERPerror.RCRandRand.amplitudes;  

conditionNames={'LCRandRand','LCRandSymm','LCSymmRand','RCRandRand','RCRandSymm','RCSymmRand','LCRandSymmSPN','LCSymmRandSPN','RCRandSymmSPN','RCSymmRandSPN'}; 

for x = 1:length(conditionNames)
    c = conditionNames{x};
    ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
    ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
    ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end


% What diffrence waves do you want? 
cd(folder2);
save(name,'ERPerror'); 
clear all