clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX5 Distribution Task';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX5 Distribution Task/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 26;
skip = [];
subjects = nSubjects-length(skip);


%CONDITIONS
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'Med'];
        load(n)
        g = g+condMed;
        clear condMed
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAveragesMed','grandAverages');
clear;



clear all
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX5 Distribution Task';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX5 Distribution Task/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 26;
skip = [];
subjects = nSubjects-length(skip);


%CONDITIONS
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'Skew'];
        load(n)
        g = g+condSkew;
        clear condSkew
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAveragesSkew','grandAverages');
clear;