function startupFcn(app, varargin)

warning on;

try
    
    % ======================================================= %
    % Get the folder in which the EXE was ran.
    % ======================================================= %
    
    ExeFolder = GetExecutableFolder();
    cd(ExeFolder);
    
    % ======================================================= %
    % Get folder for DATA.
    % ======================================================= %
    
    if isempty(varargin)
        app.DATADIR = [ExeFolder '/Data/'];
    else
        app.DATADIR = varargin{1};
    end
    
    % ======================================================= %
    % If the directory is not found in either the EXE folder or
    % in the first VARARGIN argument, a dialog box appears to
    % select the path.
    % ======================================================= %
    
    if ~exist(app.DATADIR,'dir')
        disp('Data folder now found, please provide the path to the Data folder.')
        app.DATADIR = uigetdir;
        waitfor(app.DATADIR);
    end
    
    % ======================================================= %
    % Read conditions file.
    % ======================================================= %
    
    app.CONDITIONS = readtable("Conditions.csv");
    
    % ======================================================= %
    % Read catalogue file.
    % ======================================================= %
    
    Catalogue = readtable('Catalogue.csv');
    %             [~,~,Catalogue] = xlsread('Catalogue.xlsx');
    
    % ======================================================= %
    % Let's get the mean SPN for the original clusters to do
    % some validation later.
    % ======================================================= %
    
    app.SPNVALIDATION = table(Catalogue.ProjectFolder, Catalogue.SubFolder, Catalogue.SPNID, Catalogue.SPN,Catalogue.SPN_1,Catalogue.SPN_2,Catalogue.SPN_3,Catalogue.D,'VariableNames',{'Project' 'Experiment' 'SPNID' 'MeanSPN' 'MeanSPN1' 'MeanSPN2' 'MeanSPN3' 'D'});
    
    % ======================================================= %
    % Remove NaN rows.
    % ======================================================= %
    
    Catalogue(find(isnan(table2array(Catalogue(2:end,1))))+1,:) = [];
    %             Catalogue(find(isnan(cell2mat(Catalogue(2:end,1))))+1,:) = [];
    
    % ======================================================= %
    % We are only interested in certain columns of catalogue. Some
    % columns have duplicate names so we need to avoid them.
    % ======================================================= %
    
    Catalogue = Catalogue(:,1:26);
    
    % ======================================================= %
    % Extract appropriate columns and rename as necessary.
    % ======================================================= %
    
    Titles = Catalogue.Properties.VariableNames;
    %             Titles = Catalogue(1,:);
    ColsToKeep = find(~cell2mat(cellfun(@(x) isnumeric(x), Titles, 'UniformOutput',false)));
    Titles = Titles(ColsToKeep);
    ColToRename = find(cellfun(@(x) ~isempty(str2num(x(1))),Titles));
    Titles(ColToRename) = cellfun(@(x) ['C' x],Titles(ColToRename),'UniformOutput',false);
    Titles = strrep(strrep(strrep(Titles,' ',''),'.','_'),'%','');
    
    % ======================================================= %
    % Extract appropriate portion of catlogue.
    % ======================================================= %
    
    Catalogue = Catalogue(:,ColsToKeep);
    Catalogue = table2struct(Catalogue);
    %             Catalogue = Catalogue(2:end,ColsToKeep);
    %             Catalogue = cell2struct(Catalogue,Titles,2);
    
    % ======================================================= %
    % Determine which folders are present in Data folder and remove
    % all other entries in Catalogue.
    % ======================================================= %
    
    SubFolders = ListSubfolders(app.DATADIR);
    SubFolders(~contains(SubFolders,'Project')) = [];
    
    FoldersPresent = cellfun(@str2num,cellfun(@(x) regexp(x,'\d*','Match'),SubFolders));
    
    for iFolder = unique([Catalogue.ProjectFolder])
        if ~any(ismember(FoldersPresent,iFolder))
            Catalogue([Catalogue.ProjectFolder] == iFolder) = [];
        end
    end
    
    % ======================================================= %
    % Formulate project names.
    % ======================================================= %
    
    ProjectNumbers = unique([Catalogue.ProjectFolder]);
    ProjectNames = cellfun(@(x) ['Project ' x], strrep(cellstr(num2str(ProjectNumbers')),' ',''), 'UniformOutput', false);
    
    % ======================================================= %
    % Add data into app.PROJECTS. This variable is the main
    % variable available globally for the APP. It contains the
    % data from all projects. This section loops through the
    % projects that were found in the DATA directory and
    % extracts the necessary values.
    % ======================================================= %
    
    for iProject = 1:length(ProjectNumbers)
        
        % =================================================== %
        % Assign project number and name.
        % =================================================== %
        
        app.PROJECTS(iProject).Project = ProjectNumbers(iProject);
        app.PROJECTS(iProject).Name = ProjectNames{iProject};
        
        % =================================================== %
        % For the current project, find all instances of that
        % project in the CATALOGUE. Each instance corresponds
        % to a condition for a specific EXPERIMENT within that
        % PROJECT.
        % =================================================== %
        
        ProjectIndex = find([Catalogue.ProjectFolder] == app.PROJECTS(iProject).Project);
        UniqueExperiments = unique({Catalogue(ProjectIndex).SubFolder});
        
        % =================================================== %
        % For each unique experiment found for that project, we
        % loop through each experiment.
        % =================================================== %
        
        for iExperiment = 1:length(UniqueExperiments)
            
            % =============================================== %
            % For each experiment we loop through, we also want
            % to find each condition for that experiment.
            % Hence, we find all instances of the PROJECT AND
            % EXPERIMENT.
            % =============================================== %
            
            ExperimentIndex = find([Catalogue.ProjectFolder] == app.PROJECTS(iProject).Project & strcmp({Catalogue.SubFolder},UniqueExperiments{iExperiment}));
            
            app.PROJECTS(iProject).Experiments(iExperiment).Name = UniqueExperiments{iExperiment};
            app.PROJECTS(iProject).Experiments(iExperiment).N_Exp = max([Catalogue(ExperimentIndex).NInExperiment]);
            
            % =============================================== %
            % We then loop through each CONDITION for that
            % PROJECT and EXPERIMENT and extract the necessary
            % information.
            % =============================================== %
            
            for iCond = 1:length(ExperimentIndex)
                
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Name = Catalogue(ExperimentIndex(iCond)).Original;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).SPNID = Catalogue(ExperimentIndex(iCond)).SPNID;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).N_Cond = Catalogue(ExperimentIndex(iCond)).NInCondition;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).AttendRegularity = Catalogue(ExperimentIndex(iCond)).AttendRegularity;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).W = Catalogue(ExperimentIndex(iCond)).WCalculation;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Regular_Cond = Catalogue(ExperimentIndex(iCond)).Regular;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Irregular_Cond = Catalogue(ExperimentIndex(iCond)).IrregularComparision;
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Electrode_Original = strsplit(Catalogue(ExperimentIndex(iCond)).OriginalElectrodeCluster,{',' ' '});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Electrode_Cluster1 = strsplit(Catalogue(ExperimentIndex(iCond)).Cluster1,{',' ' '});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Electrode_Cluster2 = strsplit(Catalogue(ExperimentIndex(iCond)).Cluster2,{',' ' '});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Electrode_Cluster3 = strsplit(Catalogue(ExperimentIndex(iCond)).Cluster3,{',' ' '});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Electrode_Custom = strsplit(Catalogue(ExperimentIndex(iCond)).OriginalElectrodeCluster,{',' ' '});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Time_Original = strsplit(Catalogue(ExperimentIndex(iCond)).OriginalTimeWindow,{',' ' ' '-'});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Time_Dogma = strsplit(Catalogue(ExperimentIndex(iCond)).TimeWindowForClusters,{',' ' ' '-'});
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).Time_Custom = strsplit(Catalogue(ExperimentIndex(iCond)).OriginalTimeWindow,{',' ' ' '-'});
                
                ConditionIndex = find(app.CONDITIONS.Project == app.PROJECTS(iProject).Project & strcmp(app.CONDITIONS.Experiment,app.PROJECTS(iProject).Experiments(iExperiment).Name) & app.CONDITIONS.SPNID == app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).SPNID);
                
                if isempty(ConditionIndex)
                    continue % THIS SHOULD RETURN AN ERROR IN THE FINAL VERSION TO SAY FILENAME WAS NOT FOUND
                end
                
                % =============================================== %
                % For every condition in the CATALOGUE, there
                % are two files of interest. First, we have the
                % condition corresponding to the REGULARITY
                % condition, and secondly, we have the
                % condition corresponding to the IRREGULARITY
                % condition. Here, we extract the appropriate
                % file prefixes for these. Note that the
                % CATALOGUE file does not contain these
                % prefixes. Hence, rather than editing the
                % CATALOGUE, we have a separate CONDITIONS file
                % that unifys the condition name with the name
                % of the file.
                % =============================================== %
                
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).File_Prefix_Regular = app.CONDITIONS.Prefix_Regular{ConditionIndex};
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).File_Prefix_Irregular = app.CONDITIONS.Prefix_Irregular{ConditionIndex};
                
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).File_Suffix = app.CONDITIONS.PostAVGSuffix{ConditionIndex};
                
                if isempty(app.CONDITIONS.SkipSubjects{ConditionIndex})
                    app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).SkipSubjects = [];
                else
                    app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).SkipSubjects = cellfun(@str2num,strsplit(app.CONDITIONS.SkipSubjects{ConditionIndex},' ')');
                end
                
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).SPN_Mean = app.SPNVALIDATION.MeanSPN(ConditionIndex);
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).D = app.SPNVALIDATION.D(ConditionIndex);
                
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).FolderOverride = app.CONDITIONS.FolderOverride(ConditionIndex);
                app.PROJECTS(iProject).Experiments(iExperiment).Conditions(iCond).ConditionOverride = app.CONDITIONS.ConditionOverride(ConditionIndex);
                
            end
            
        end
        
        % =================================================== %
        % We assign some final bits of information for the
        % project.
        % =================================================== %
        
        app.PROJECTS(iProject).Nickname = cell2mat(unique({Catalogue(ProjectIndex).NickName}));
        app.PROJECTS(iProject).Paper = cell2mat(unique({Catalogue(ProjectIndex).Paper}));
        app.PROJECTS(iProject).Lead_Researcher = cell2mat(unique({Catalogue(ProjectIndex).LeadResearcher}));
        
        %                 if strcmp(app.PROJECTS(iProject).Experiments.Name,'N/A')
        %                     app.PROJECTS(iProject).Experiments.Name = app.PROJECTS(iProject).Nickname;
        %                 end
        
        if strcmp(app.PROJECTS(iProject).Paper,'World')
            app.PROJECTS(iProject).Journal = cell2mat(unique({Catalogue(ProjectIndex).Journal}));
            app.PROJECTS(iProject).Year = unique(cellfun(@str2num,{Catalogue(ProjectIndex).Year}));
        end
        
    end
    
    % ======================================================= %
    % Add names of project to project PROJECTS LISTBOX.
    % ======================================================= %
    
    app.ProjectsListBox.Items = {app.PROJECTS.Name};
    app.ProjectsListBox.ItemsData = [app.PROJECTS.Project];
    
    % ======================================================= %
    % Load electrode locations file.
    % ======================================================= %
    
    LoadedData = load('BioSemi-64.mat');
    app.E = LoadedData.E;
    
    % ======================================================= %
    % Add electrode labels to ELECTRODES LISTBOX for each
    % EXPERIMENT.
    % ======================================================= %
    
    for iExperiment = 1:app.MAXEXP
        app.(['Electrodes' num2str(iExperiment) 'ListBox']).Items = {app.E.labels};
    end
    
    % ======================================================= %
    % We change the PROJECTS LISTBOX value to the first folder
    % that was found.
    % ======================================================= %
    
    app.ProjectsListBox.Value = app.PROJECTS(1).Project;
    
    ProjectData.Project = app.PROJECTS(1).Project;
    ProjectData.Name = app.PROJECTS(1).Name;
    
    % ======================================================= %
    % Configure diary. This creates a file that command window
    % output is sinked to. This file is then loaded and
    % displayed in the APP window.
    % ======================================================= %
    
    if exist(app.DFILE, 'file') ; diary off; delete(app.DFILE); end
    diary(app.DFILE)
    diary on
    
    % ======================================================= %
    % In order to set of the chain of events from changing the
    % current project, we manually reference the
    % ProjectsListBoxValueChanged callback. This is because
    % simply changing the value programatically does not
    % initiate the callback.
    % ======================================================= %
    
    ProjectsListBoxValueChanged(app, []);
    
catch ME
    ThrowError(app,ME);
end

% ======================================================= %
% Configure diary. This creates a file that command window
% output is sinked to. This file is then loaded and
% displayed in the APP window. This is duplicated from within
% the above loop since, if it fails, this will at least run to
% give some sort of log file.
% ======================================================= %

if exist(app.DFILE, 'file') ; diary off; delete(app.DFILE); end
diary(app.DFILE)
diary on

% =========================================================== %
% Update the diary window.
% =========================================================== %

UpdateDiary(app);

end