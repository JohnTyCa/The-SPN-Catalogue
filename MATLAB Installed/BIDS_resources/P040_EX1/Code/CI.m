clear
% you will need to set this to a directory on your computer
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV/Grand Averages';
cd(folder1)
subjects = 34;


hemisphere= input('which hemisphere?');
% ELECTRODES
if strcmp(hemisphere, 'left') == 1
        %electrodes = [20 21 22 23 25 26];
    electrodes = [23 24 25 27];
    name = 'ERPErrorLeftBrain';

end

if strcmp(hemisphere, 'right') == 1
       %electrodes = [57 58 59 60 62 63]; 
    electrodes = [60 61 62 64]; 
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



load timeVector;

conditionNames={'TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};

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

ERPerror.TargetLSPN.amplitudes = ERPerror.TargetSymL.amplitudes- ERPerror.TargetRandL.amplitudes;
ERPerror.FlankerVLSPN.amplitudes = ERPerror.SymFlankerVL.amplitudes- ERPerror.RandFlankerVL.amplitudes;
ERPerror.FlankerHLSPN.amplitudes = ERPerror.SymFlankerHL.amplitudes- ERPerror.RandFlankerHL.amplitudes;
ERPerror.TargetRSPN.amplitudes = ERPerror.TargetSymR.amplitudes- ERPerror.TargetRandL.amplitudes;
ERPerror.FlankerVRSPN.amplitudes = ERPerror.SymFlankerVR.amplitudes- ERPerror.RandFlankerVR.amplitudes;
ERPerror.FlankerHRSPN.amplitudes = ERPerror.SymFlankerHR.amplitudes- ERPerror.RandFlankerHR.amplitudes;


conditionNames={'TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR','TargetLSPN','FlankerVLSPN','FlankerHLSPN','TargetRSPN','FlankerVRSPN','FlankerHRSPN'};



for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end
cd(folder2);
save(name,'ERPerror'); 
clear all