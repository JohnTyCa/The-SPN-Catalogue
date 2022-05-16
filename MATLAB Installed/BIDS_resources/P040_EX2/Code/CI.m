clear
% you will need to set this to a directory on your computer
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX2 Crowding Matched';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX2 Crowding Matched/Grand Averages';
cd(folder1)
subjects = 24;


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


conditionNames={'TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};

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

% Stim all on the left of the screen
ERPerror.TargetLeftSPN.amplitudes = ERPerror.TargetSymLeft.amplitudes- ERPerror.TargetRandLeft.amplitudes; % this one has a different subtraction
ERPerror.SymFlankerSLeftSPN.amplitudes = ERPerror.SymFlankerSLeft.amplitudes- ERPerror.RandFlankerRLeft.amplitudes;
ERPerror.SymFlankerRLeftSPN.amplitudes = ERPerror.SymFlankerRLeft.amplitudes- ERPerror.RandFlankerRLeft.amplitudes;
ERPerror.RandFlankerSLeftSPN.amplitudes = ERPerror.RandFlankerSLeft.amplitudes- ERPerror.RandFlankerRLeft.amplitudes;


% Stim all on the right of the screen
ERPerror.TargetRightSPN.amplitudes = ERPerror.TargetSymLeft.amplitudes- ERPerror.TargetRandLeft.amplitudes; % this one has a different subtraction
ERPerror.SymFlankerSRightSPN.amplitudes = ERPerror.SymFlankerSRight.amplitudes- ERPerror.RandFlankerRRight.amplitudes;
ERPerror.SymFlankerRRightSPN.amplitudes = ERPerror.SymFlankerRRight.amplitudes- ERPerror.RandFlankerRRight.amplitudes;
ERPerror.RandFlankerSRightSPN.amplitudes = ERPerror.RandFlankerSRight.amplitudes- ERPerror.RandFlankerRRight.amplitudes;


conditionNames={'TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight','TargetLeftSPN','SymFlankerSLeftSPN','SymFlankerRLeftSPN','RandFlankerSLeftSPN','TargetRightSPN','SymFlankerSRightSPN','SymFlankerRRightSPN','RandFlankerSRightSPN'};


for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end
cd(folder2);
save(name,'ERPerror'); 
clear all