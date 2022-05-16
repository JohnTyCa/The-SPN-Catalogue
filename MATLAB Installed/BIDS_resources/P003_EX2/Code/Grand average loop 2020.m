clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX2 Num';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX2 Num/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 20;
skip=[];
subjects = nSubjects-length(skip)

% CONDITIONS
conditionNames = {'ReflectionOne','ReflectionTwo', 'TranslationOne', 'TranslationTwo'};

for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,'40Hz ',condName,'AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('LowPass40grandAverages','grandAverages')
clear

%THIS PROJECT IS SLIGHTLY UNUSUAL, BECAUSE WE HAVE DATA THAT WAS LOW PASS
%FILTERED AT 40Hz (reported in manuscript), and DATA THAT WAS LOW PASS FILTERED AT THE TYPICAL
%25HZ. 

%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX2 Num';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX2 Num/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 20;
skip=[];
subjects = nSubjects-length(skip)
conditionNames = {'ReflectionOne','ReflectionTwo', 'TranslationOne', 'TranslationTwo'};
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG;
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages','grandAverages')
clear

