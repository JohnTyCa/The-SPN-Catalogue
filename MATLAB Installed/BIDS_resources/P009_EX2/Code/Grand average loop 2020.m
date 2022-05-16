clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided';
folder2='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided/Grand Averages';
cd(folder1);
load timeVector

%SUBJECTS
nSubjects = 24;
skip=[];
subjects = nSubjects-length(skip)

%CONDITIONS
conditionNames={'REFNOTHING','RANDNOTHING','NOTHINGREF','NOTHINGRAND','REFNOTHINGDARK','RANDNOTHINGDARK','NOTHINGREFDARK','NOTHINGRANDDARK','REFNOTHINGLIGHT','RANDNOTHINGLIGHT','NOTHINGREFLIGHT','NOTHINGRANDLIGHT'};

%LOOP
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
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

%SAVE
cd(folder2);
save('grandAverages','grandAverages');
clear;


