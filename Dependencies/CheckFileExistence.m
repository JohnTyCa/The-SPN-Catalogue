function [SubjectNumbers, SubjectFiles] = CheckFileExistence(Folder,Suffix,TwoDigitString)

% This checks to see if the files corresponding to each
% CONDITION and SUBJECT are present in the folder. This
% requires the FOLDER and the SUFFIX. This assumes that the
% SUFFIX is preceded by "SX", where X is the subject number. It
% also determines the subject numbers. This is because if an
% experiment has 25 subjects, they may not be named uniformly
% between 1 and 25. This is done via a pure brute force method
% by checking the existence up to S100.

% =========================================================== %
% Loop through each potential subject number and check the for
% the existence of a file with that subject number prefix.
% =========================================================== %

FilesInFolder = dir(fullfile(Folder, '**\*.*'));  %get list of files and folders in any subfolder
FilesInFolder = FilesInFolder(~[FilesInFolder.isdir]);  %remove folders from list

FolderNames = {FilesInFolder.name}';

SubjectNumbers = []; SubjectFiles = {}; Finished = 0; SubCount = 0; SubIndex = 0;
while ~Finished
    SubCount = SubCount + 1;
    if TwoDigitString
        FileName = ['S' nDigitString(SubCount,2) '_' Suffix];
    else
        FileName = ['S' num2str(SubCount) Suffix];
    end
    FilePresent = find(contains(FolderNames,FileName,'IgnoreCase',true));
    if ~isempty(FilePresent)
        SubIndex = SubIndex + 1;
        SubjectNumbers(end+1) = SubCount;
        SubjectFiles{end+1} = [FilesInFolder(FilePresent).folder filesep FilesInFolder(FilePresent).name];
    end
    if SubCount >= 99
        Finished = 1;
    end
end

end