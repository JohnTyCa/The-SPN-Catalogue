clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 24;
skip = [];
subjects = nSubjects-length(skip)

%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};

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
        %n = ['S',k,condName,'NoICAAVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages','grandAverages')
clear all

% 
% clear
% %DIRECTORY
% folder1 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape'
% folder2 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape/Grand Averages'
% cd(folder1)
% load timeVector
% 
% %SUBJECTS
% nSubjects = 24;
% skip = [];
% subjects = nSubjects-length(skip)
% 
% %CONDITIONS
% conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};
% 
% %LOOP
% for c = 1:length(conditionNames);
%     g = zeros(64,length(timeVector));
%     condName = conditionNames{c};
%     for s = 1:nSubjects
%        
%         if ismember(s,skip)
%             continue
%         end
%         k = num2str(s);
%         %n = ['S',k,condName,'AVG'];
%         n = ['S',k,condName,'NoICAAVG'];
%         load(n)
%         g = g+condAVG;
%         clear condAVG
%     end
%     grandAverages.(condName) =  g/subjects;
%     clear g
% end
% 
% cd(folder2);
% save('grandAveragesNoICA','grandAverages')
% clear all
% 
% 
% 
% clear
% %DIRECTORY
% folder1 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape'
% folder2 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape/Grand Averages'
% cd(folder1)
% load timeVectorSamplePlusProbe
% 
% %SUBJECTS
% nSubjects = 24;
% skip = [8 16 21];
% subjects = nSubjects-length(skip)
% 
% %CONDITIONS
% conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};
% 
% %LOOP
% for c = 1:length(conditionNames);
%     g = zeros(64,length(timeVector));
%     condName = conditionNames{c};
%     for s = 1:nSubjects
%        
%         if ismember(s,skip)
%             continue
%         end
%         k = num2str(s);
%         n = ['S',k,'SamplePlusProbe',condName,'AVG'];
%         %n = ['S',k,condName,'NoICAAVG'];
%         load(n)
%         g = g+condAVG;
%         clear condAVG
%     end
%     grandAverages.(condName) =  g/subjects;
%     clear g
% end
% 
% cd(folder2);
% save('grandAveragesSamplePlusProbe','grandAverages')
% clear all
% 
