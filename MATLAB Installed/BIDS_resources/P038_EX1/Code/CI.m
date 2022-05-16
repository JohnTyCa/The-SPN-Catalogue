clear
% you will need to set this to a directory on your computer
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 38';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 38/Grand Averages';
cd(folder1)
subjects = 22;
%ELECTRODES



d = input('which dogma?');
electrodes = [25 27 62 64];
if d ==1
    disp 'dogma 1'
    electrodes = [25 27 62 64]; 
end

if d ==2
    disp 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3
    disp 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4
    disp 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5    
    disp 'dogmatic right'
    electrodes = [62 64];
end

if d < 1||d> 5
    disp('Original electrodes used');
end

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;

conditionNames={'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup','RandRandRand'};

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

ERPerror.REFdownRANDupSPN.amplitudes = ERPerror.REFdownRANDup.amplitudes- ERPerror.RandRandRand.amplitudes;
ERPerror.RANDdownREFupSPN.amplitudes = ERPerror.RANDdownREFup.amplitudes- ERPerror.RandRandRand.amplitudes;
ERPerror.REFdownREFupREFdownSPN.amplitudes = ERPerror.REFdownREFupREFdown.amplitudes- ERPerror.RandRandRand.amplitudes;
ERPerror.REFupREFdownREFupSPN.amplitudes = ERPerror.REFupREFdownREFup.amplitudes- ERPerror.RandRandRand.amplitudes;



conditionNames={'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup','RandRandRand','REFdownRANDupSPN','RANDdownREFupSPN','REFdownREFupREFdownSPN','REFupREFdownREFupSPN'};
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerror','ERPerror');
clear all