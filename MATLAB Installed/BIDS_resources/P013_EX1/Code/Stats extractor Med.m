clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX1 Reg Task';
folder2 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX1 Reg Task/Grand Averages';
cd(folder1);

% SUBJECCTS
subjects = 26;
skip = []

%CONDITIONS
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};

% TIME WINDOWS
low = 300
high = 1000
% 
% low = 300
% high = 400
% 
% low = 600
% high = 1000 


load timeVector
ii = find(timeVector >=low & timeVector <=high);


% ELECTRODES
electrodes = [25 27 62 64];
d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    electrodes = [25 27 62 64]; 
end

if d ==2;
    display 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3;
    display 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4;
    display 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5;
    display 'dogmatic right'
    electrodes = [62 64];
end

if d < 1|d> 5;
    display('Original electrodes used');
end

% LOOP
for c = 1:length(conditionNames)
    p = 0;
    for i = 1:subjects;
        if ismember(i,skip)
            disp(['excluded' num2str(i)])
            continue
        end
        p = p+1;
        k = num2str(i); 
        %n = ['S',k,conditionNames{c},'AVG.mat'];
        n = ['S',k,conditionNames{c},'Med.mat'];
        load(n);
        %Results(p,c) = mean(mean(condAVG(electrodes,ii)));
        Results(p,c) = mean(mean(condMed(electrodes,ii)));
    end
end

% SAVE AND RELOAD
cd(folder2)
save('Results','Results');
clear all
load 'Results'


