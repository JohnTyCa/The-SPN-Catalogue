

%DIRECTORY
clear
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages250';
cd(folder1);
load timeVector250

%SUBJECTS
nSubjects = 40;  
skip = [1 3 9 14 17 19 20 21 24 25 26 29 31 32 34 37]; % the first 16 are complex, the last 24 are simple. We excluded the worst participants so as to give 24 in total, with 12 simple and 12 complex. 
subjects = nSubjects-length(skip);

%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects

        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'250AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages250','grandAverages');
clear


%DIRECTORY
clear
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages500';
cd(folder1);
load timeVector500

%SUBJECTS
nSubjects = 40;
skip = [1 3 9 14 17 19 20 21 24 25 26 29 31 32 34 37]; 
subjects = nSubjects-length(skip);

%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects

        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'500AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages500','grandAverages');
clear


%DIRECTORY
clear
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages750';
cd(folder1);
load timeVector750;

%SUBJECTS
nSubjects = 40;
skip = [1 3 9 14 17 19 20 21 24 25 26 29 31 32 34 37]; 
subjects = nSubjects-length(skip);

%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};


%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects

        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'750AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages750','grandAverages')
clear all







clear
%DIRECTORY
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages1000';
cd(folder1)
load timeVector1000

%SUBJECTS
nSubjects = 40;
skip = [1 3 9 14 17 19 20 21 24 25 26 29 31 32 34 37]; 
subjects = nSubjects-length(skip);

%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects

        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'1000AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages1000','grandAverages')
