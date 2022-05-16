classdef SPNCAT_func < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        GridLayout              matlab.ui.container.GridLayout
        LeftPanel               matlab.ui.container.Panel
        ProjectsListBox         matlab.ui.control.ListBox
        Experiment1Panel        matlab.ui.container.Panel
        Experiment1ListBox      matlab.ui.control.ListBox
        ClusterDropDownLabel    matlab.ui.control.Label
        Cluster1DropDown        matlab.ui.control.DropDown
        TimeDropDownLabel       matlab.ui.control.Label
        Time1DropDown           matlab.ui.control.DropDown
        StartEditFieldLabel     matlab.ui.control.Label
        Start1EditField         matlab.ui.control.NumericEditField
        EndEditFieldLabel       matlab.ui.control.Label
        End1EditField           matlab.ui.control.NumericEditField
        Electrodes1ListBox      matlab.ui.control.ListBox
        Experiment2Panel        matlab.ui.container.Panel
        Experiment2ListBox      matlab.ui.control.ListBox
        Electrodes2ListBox      matlab.ui.control.ListBox
        ClusterDropDownLabel_2  matlab.ui.control.Label
        Cluster2DropDown        matlab.ui.control.DropDown
        TimeDropDownLabel_2     matlab.ui.control.Label
        Time2DropDown           matlab.ui.control.DropDown
        StartEditFieldLabel_2   matlab.ui.control.Label
        Start2EditField         matlab.ui.control.NumericEditField
        EndEditFieldLabel_2     matlab.ui.control.Label
        End2EditField           matlab.ui.control.NumericEditField
        Experiment3Panel        matlab.ui.container.Panel
        Experiment3ListBox      matlab.ui.control.ListBox
        Electrodes3ListBox      matlab.ui.control.ListBox
        ClusterDropDownLabel_3  matlab.ui.control.Label
        Cluster3DropDown        matlab.ui.control.DropDown
        TimeDropDownLabel_3     matlab.ui.control.Label
        Time3DropDown           matlab.ui.control.DropDown
        StartEditFieldLabel_3   matlab.ui.control.Label
        Start3EditField         matlab.ui.control.NumericEditField
        EndEditFieldLabel_3     matlab.ui.control.Label
        End3EditField           matlab.ui.control.NumericEditField
        Experiment4Panel        matlab.ui.container.Panel
        Experiment4ListBox      matlab.ui.control.ListBox
        Electrodes4ListBox      matlab.ui.control.ListBox
        ClusterDropDownLabel_4  matlab.ui.control.Label
        Cluster4DropDown        matlab.ui.control.DropDown
        TimeDropDownLabel_4     matlab.ui.control.Label
        Time4DropDown           matlab.ui.control.DropDown
        StartEditFieldLabel_4   matlab.ui.control.Label
        Start4EditField         matlab.ui.control.NumericEditField
        EndEditFieldLabel_4     matlab.ui.control.Label
        End4EditField           matlab.ui.control.NumericEditField
        Experiment5Panel        matlab.ui.container.Panel
        Experiment5ListBox      matlab.ui.control.ListBox
        Electrodes5ListBox      matlab.ui.control.ListBox
        ClusterDropDownLabel_5  matlab.ui.control.Label
        Cluster5DropDown        matlab.ui.control.DropDown
        TimeDropDownLabel_5     matlab.ui.control.Label
        Time5DropDown           matlab.ui.control.DropDown
        StartEditFieldLabel_5   matlab.ui.control.Label
        Start5EditField         matlab.ui.control.NumericEditField
        EndEditFieldLabel_5     matlab.ui.control.Label
        End5EditField           matlab.ui.control.NumericEditField
        RightPanel              matlab.ui.container.Panel
        PlotButton              matlab.ui.control.StateButton
        DifferenceWaveButton    matlab.ui.control.StateButton
        PlotIrregularButton     matlab.ui.control.StateButton
        UITableSPN              matlab.ui.control.Table
        DiaryOutput             matlab.ui.control.TextArea
        ExportButton            matlab.ui.control.Button
        UIAxesWaveform          matlab.ui.control.UIAxes
        UIAxesBar               matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        MAXEXP = 5; % Max number of experiments for UI.
        CONDITIONS = struct(); % Details conditions and their corresponding file names.
        INITIATED = 0;
        DFILE = 'DiaryOutput';
        ExportApp;
        VALIDATE;
        CATALOGUELOADED;
    end
    
    properties (Access = public)
        PROJECTS = struct(); % Structure detailing all aspects of projects.
        CURRENTPROJECT = struct(); % All details of current project selected.
        E; % Electrode locations.
        PROJECT;
        EXP;
        CAT;
        DATADIR;
        Dependencies_Folder;
        APPENDIX;
    end
    
    methods (Access = private)
        
        function ThrowError(~,ME)
            % Displays the report for the exception ME in a dialog box.
            ErrorReport = getReport(ME,'extended','hyperlinks','off');
            Stack = dbstack;
            FunctionString = Stack(2).name;
            errordlg(ErrorReport,['Error in ' FunctionString]);
        end
        
        function UpdateDiary(app)
            % Updates the output window in the APP with the most recent
            % Diary Output.
            try
                DiaryData = fileread(app.DFILE);
                app.DiaryOutput.Value = DiaryData;
            catch ME
                ThrowError(app,ME);
            end
        end
        
        function SelectConditions(app,Selection)
            
            % Selects a subset of the CONDITIONS in the EXPERIMENT LISTBOX.
            % This is useful for when the project is changed and we need to
            % automatically select some conditions so that the data can be
            % extracted properly.
            
            UniqueExperiments = unique({app.CURRENTPROJECT.Experiment});
            
            try
                if strcmp(Selection,'all')
                    for iExp = 1:length(UniqueExperiments)
                        app.(['Experiment' num2str(iExp) 'ListBox']).Value = app.(['Experiment' num2str(iExp) 'ListBox']).ItemsData;
                    end
                elseif strcmp(Selection,'first')
                    for iExp = 1:length(UniqueExperiments)
                        app.(['Experiment' num2str(iExp) 'ListBox']).Value = app.(['Experiment' num2str(iExp) 'ListBox']).ItemsData(1);
                    end
                elseif isempty(Selection)
                    if app.PlotButton.Value
                        for iExp = 1:length(UniqueExperiments)
                            app.(['Experiment' num2str(iExp) 'ListBox']).Value = [app.CURRENTPROJECT(strcmp({app.CURRENTPROJECT.Experiment},UniqueExperiments{iExp}) & [app.CURRENTPROJECT.Plot_Selection]).SPNID];
                        end
                    else
                        for iExp = 1:length(UniqueExperiments)
                            app.(['Experiment' num2str(iExp) 'ListBox']).Value = [app.CURRENTPROJECT(strcmp({app.CURRENTPROJECT.Experiment},UniqueExperiments{iExp}) & [app.CURRENTPROJECT.Configure_Selection]).SPNID];
                        end
                    end
                end
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
        end
        
        function ExtractPlotData(app)
            
            % Extracts the data required for plotting the current project.
            
            try
                
                % =================================================== %
                % Extract the REGULARITY condition first.
                % =================================================== %
                
                for iCond = 1:length(app.CURRENTPROJECT)
                    
                    % =============================================== %
                    % Based on the options selected for each EXPERIMENT
                    % and CONDITION, we only want to select the
                    % ELECTRODES and TIMEPOINTS of interest.
                    % =============================================== %
                    
                    ElectrodeSelection = app.CURRENTPROJECT(iCond).Cluster_Options_Electrodes;
                    
                    Time_Windows = app.CURRENTPROJECT(iCond).Cluster_Options_Time;
                    Time_Windows(ismember(Time_Windows,{'and', 'to'})) = [];
                    TimeSelection = cellfun(@str2num,Time_Windows);
                    
                    % =============================================== %
                    % Get the indices for the desired ELECTRODES and
                    % TIMEPOINTS from the respective variables.
                    % =============================================== %
                    
                    ElectrodeIndices = ismember({app.E.labels}, ElectrodeSelection);
                    TimeIndices = app.CURRENTPROJECT(iCond).TimeVector >= TimeSelection(1) & app.CURRENTPROJECT(iCond).TimeVector <= TimeSelection(2);
                    
                    % =============================================== %
                    % Extract the data for both REGULARITY and
                    % IRREGULARITY.
                    % =============================================== %
                    
                    PlotData_All = app.CURRENTPROJECT(iCond).Data;
                    PlotData_All_Irregular = app.CURRENTPROJECT(iCond).Data_Irregular;
                    
                    % =============================================== %
                    % If we want to plot the difference wave, as
                    % indicated by the DIFFERENCEWAVEBUTTON, we
                    % subtract the IRREGULARITY data from the
                    % REGULARITY data.
                    % =============================================== %
                    
                    if app.DifferenceWaveButton.Value
                        PlotData_All = PlotData_All - PlotData_All_Irregular;
                    end
                    
                    % =============================================== %
                    % Get the average across the selected ELECTRODES.
                    % =============================================== %
                    
                    PlotData_ElectrodeMean = squeeze(mean(PlotData_All(ElectrodeIndices,:,:),1));
                    PlotData_Irregular_ElectrodeMean = squeeze(mean(PlotData_All_Irregular(ElectrodeIndices,:,:),1));
                    
                    % =============================================== %
                    % Get the average across the TIMEPOINTS for the
                    % selected ELECTRODES.
                    % =============================================== %
                    
                    PlotData_MeanInRange = mean(PlotData_ElectrodeMean(TimeIndices,:),1);
                    PlotData_Irregular_MeanInRange = mean(PlotData_Irregular_ElectrodeMean(TimeIndices,:),1);
                    
                    % =============================================== %
                    % Here is where we assign an extra suffix depending
                    % on whether REGULARITY was attended to or now.
                    % This is to differentiate identical conditions
                    % that only differ in terms of attention.
                    % =============================================== %
                    
                    if app.CURRENTPROJECT(iCond).Attend_Regularity
                        NameSuffix = '(Attend Reg)';
                    else
                        NameSuffix = '(Disregard Reg)';
                    end
                    
                    % =============================================== %
                    % Add the necessary information for each CONDITION,
                    % including the plot data and the name of the
                    % condition. We also define the LEGENDNAME
                    % variable, a variable containing a list of names
                    % indicating whether REGULARITY was attended to or
                    % now. This is important for differentiating
                    % conditions.
                    % =============================================== %
                    
                    app.CURRENTPROJECT(iCond).PlotData = mean(PlotData_ElectrodeMean,2);
                    app.CURRENTPROJECT(iCond).PlotData_Irregular = mean(PlotData_Irregular_ElectrodeMean,2);
                    app.CURRENTPROJECT(iCond).PlotData_LegendName = ['(' num2str(app.CURRENTPROJECT(iCond).SPNID) ') ' app.CURRENTPROJECT(iCond).Full_Name ' ' NameSuffix];
                    app.CURRENTPROJECT(iCond).PlotData_MeanInRange = PlotData_MeanInRange;
                    app.CURRENTPROJECT(iCond).PlotData_Irregular_MeanInRange = PlotData_Irregular_MeanInRange;
                    app.CURRENTPROJECT(iCond).PlotData_Time = TimeSelection;
                    app.CURRENTPROJECT(iCond).PlotData_Electrodes = ElectrodeSelection;
                    app.CURRENTPROJECT(iCond).PlotData_TimeVector = app.CURRENTPROJECT(iCond).TimeVector;
                    
                end
                
                % ======================================================= %
                % Since some projects have different time vectors, we need to
                % create an "average" time series. Combining multiple time
                % vectors and interpolating values might produce interpolated
                % values asymmetrically across the time series, thus changing
                % the mean. Hence, we will assume that the time vectors for any
                % single experiment all have the same starting point and
                % sampling rate. This SHOULD produce the same time samples up
                % until the point at which they diverge, hopefully at the end
                % of the respective epochs rather than within them. This way,
                % the size of the time vectors can simply be padded with NaN
                % values at the end.
                % ======================================================= %
                
                CurrentTimeVectors = {app.CURRENTPROJECT.PlotData_TimeVector}';
                MinValue = cellfun(@min,CurrentTimeVectors);
                MaxValue = cellfun(@max,CurrentTimeVectors);
                
                if length(unique(MinValue)) > 1
                    error('Epochs have different starting times. You will have to figure out another way of equalising time vector lengths.')
                end
                
                % ======================================================= %
                % We find the epoch with the latest value and create a
                % unified TIMEVECTOR, with the conditions that do not
                % contain those values simply being padded with NAN values.
                % ======================================================= %
                
                LongestTimeVector = CurrentTimeVectors{MaxValue == max(MaxValue)};
                
                if length(unique(MaxValue)) > 1
                    MaxLength = max(cellfun(@length,{app.CURRENTPROJECT.PlotData}));
                    for iCond = 1:length(app.CURRENTPROJECT)
                        if length(app.CURRENTPROJECT(iCond).PlotData) < MaxLength
                            app.CURRENTPROJECT(iCond).PlotData(end+1:MaxLength) = NaN;
                        end
                    end
                end
                
                % ======================================================= %
                % Remove conditions we do not want to plot.
                % ======================================================= %
                
                PLOT = [];
                
                PLOT.PLOTDATA = struct();
                
                for iCond = 1:length(app.CURRENTPROJECT)
                    
                    PLOT.PLOTDATA(iCond).SPNID = app.CURRENTPROJECT(iCond).SPNID;
                    PLOT.PLOTDATA(iCond).Full_Name = app.CURRENTPROJECT(iCond).Full_Name;
                    PLOT.PLOTDATA(iCond).Regular_Condition = app.CURRENTPROJECT(iCond).Regular_Condition;
                    PLOT.PLOTDATA(iCond).Irregular_Condition = app.CURRENTPROJECT(iCond).Irregular_Condition;
                    PLOT.PLOTDATA(iCond).Window_Original = app.CURRENTPROJECT(iCond).Window_Original;
                    PLOT.PLOTDATA(iCond).Plot_Data = app.CURRENTPROJECT(iCond).PlotData;
                    PLOT.PLOTDATA(iCond).Plot_Data_Irregular = app.CURRENTPROJECT(iCond).PlotData_Irregular;
                    PLOT.PLOTDATA(iCond).Legend = app.CURRENTPROJECT(iCond).PlotData_LegendName;
                    PLOT.PLOTDATA(iCond).Mean_in_Range = app.CURRENTPROJECT(iCond).PlotData_MeanInRange;
                    PLOT.PLOTDATA(iCond).Mean_in_Range_Irregular = app.CURRENTPROJECT(iCond).PlotData_Irregular_MeanInRange;
                    PLOT.PLOTDATA(iCond).Mean_Original_SPN = app.CURRENTPROJECT(iCond).SPN;
                    PLOT.PLOTDATA(iCond).Plot_Selection = app.CURRENTPROJECT(iCond).Plot_Selection;
                    
                end
                
                PLOT.PLOTDATA(~[PLOT.PLOTDATA.Plot_Selection]) = [];
                
                % ======================================================= %
                % Assign irregular conditions to plot variable.
                % ======================================================= %
                
                if ~app.DifferenceWaveButton.Value && app.PlotIrregularButton.Value
                    
                    UniqueExperiments = unique({PLOT.PLOTDATA.Full_Name});
                    
                    for iExp = 1:length(UniqueExperiments)
                        Experiment_Index = strcmp({PLOT.PLOTDATA.Full_Name},UniqueExperiments{iExp});
                        Experiment_Irregular_Conditions = unique({PLOT.PLOTDATA(Experiment_Index).Irregular_Condition});
                        for iCond = 1:length(Experiment_Irregular_Conditions)
                            Condition_Index = find(Experiment_Index & strcmp({PLOT.PLOTDATA.Irregular_Condition},Experiment_Irregular_Conditions{iCond}));
                            Experiment_Index(end+1) = 0;
                            PLOT.PLOTDATA(end+1) = PLOT.PLOTDATA(Condition_Index(end));
                            PLOT.PLOTDATA(end).Plot_Data = PLOT.PLOTDATA(end).Plot_Data_Irregular;
                            PLOT.PLOTDATA(end).Mean_in_Range = PLOT.PLOTDATA(end).Mean_in_Range_Irregular;
                            PLOT.PLOTDATA(end).Legend = [PLOT.PLOTDATA(end).Full_Name ' (' PLOT.PLOTDATA(end).Irregular_Condition ')'];
                            
                        end
                    end
                    
                    PLOT.PLOTDATA = table2struct(sortrows(struct2table(PLOT.PLOTDATA),'SPNID'));
                    
                end
                
                % ======================================================= %
                % Now that we have the longest time vector, we can extract
                % plot data. First, we extract the line data for the plots,
                % the legend and the TIMEVECTOR.
                % ======================================================= %
                
                PLOT.Line_Data = cat(2,PLOT.PLOTDATA.Plot_Data);
                PLOT.Legend = strrep({PLOT.PLOTDATA.Legend},'_',' ');
                PLOT.Time = LongestTimeVector;
                
                % ======================================================= %
                % Get the MEAN and STD for each condition.
                % ======================================================= %
                
                PLOT.Mean_in_Range = cellfun(@double,cellfun(@mean,{PLOT.PLOTDATA.Mean_in_Range},'UniformOutput',false));
                PLOT.STD_in_Range = cellfun(@double,cellfun(@std,{PLOT.PLOTDATA.Mean_in_Range},'UniformOutput',false));
                PLOT.N = cellfun(@length,{PLOT.PLOTDATA.Mean_in_Range});
                PLOT.Mean_Original_SPN = [PLOT.PLOTDATA.Mean_Original_SPN];
                
                % ======================================================= %
                % Let's give some warnings about values that do not match
                % the catalogue with respect to mean SPN amplitude, but
                % only when plotting ORIGINAL ELECTRODES and TIME, as well
                % as the DIFFERENCE WAVE, as these are the values used in
                % the catalogue. We will use a sensible tolerance here. We
                % do not care if the values do not match to 10 decimal
                % places, so we will set it to 10^-5.
                % ======================================================= %
                
                if app.CATALOGUELOADED && app.DifferenceWaveButton.Value
                    
                    MultipleWindows = 0;
                    for iCond = 1:length(PLOT.PLOTDATA)
                        if length(PLOT.PLOTDATA(iCond).Window_Original) > 2
                            MultipleWindows = 1;
                        end
                    end
                    
                    Tolerance = 10^-5;
                    
                    for iCond = 1:length(PLOT.PLOTDATA)
                        if abs(PLOT.Mean_in_Range(iCond) - PLOT.Mean_Original_SPN(iCond)) > Tolerance
                            
                            if ~MultipleWindows
                                warning([PLOT.Legend{iCond} ' - SPN Mean in CAT_ORIG (' num2str(round(PLOT.Mean_Original_SPN(iCond),5)) ') does not match that extracted here (' num2str(round(PLOT.Mean_in_Range(iCond),5)) ' - Difference of ' num2str(PLOT.Mean_in_Range(iCond) - PLOT.Mean_Original_SPN(iCond)) ').'])
                            end
                            
                        end
                    end
                    
                    app.CATALOGUELOADED = 0;
                    
                end
                
                % ======================================================= %
                % We want to present a table within the APP that details
                % means, std's, N, etc. Hence, we build a table variable to
                % be used later, with each column representing a condition.
                % ======================================================= %
                
                PLOT.TableColumns = PLOT.Legend;
                PLOT.TableColumns = strrep(strrep(PLOT.TableColumns,';','_'),' ','');
                
                StringInput = repmat('nan(6,1),',1,length(PLOT.Legend));
                StringInput(end) = [];
                
                PLOT.Table = eval(['table(' StringInput ')']);
                PLOT.Table.Properties.RowNames = {'SPN' 'SD' 'D' 'N' 't' 'p'};
                PLOT.Table.Properties.VariableNames = PLOT.TableColumns;
                for iCond = 1:length(PLOT.Legend)
                    ColumnName = PLOT.TableColumns{iCond};
                    PLOT.Table.(ColumnName)(1,1) = PLOT.Mean_in_Range(iCond);
                    PLOT.Table.(ColumnName)(2,1) = PLOT.STD_in_Range(iCond);
                    PLOT.Table.(ColumnName)(3,1) = PLOT.Mean_in_Range(iCond)/PLOT.STD_in_Range(iCond);
                    PLOT.Table.(ColumnName)(4,1) = PLOT.N(iCond);
                    PLOT.Table.(ColumnName)(5,1) = PLOT.Table.(ColumnName)(3,1) * sqrt(PLOT.N(iCond));
                    [~,PLOT.Table.(ColumnName)(6,1)] = ttest(PLOT.PLOTDATA(iCond).Mean_in_Range);
                end
                
                % ======================================================= %
                % Now that the table has been built, we put the table
                % inside the UITABLE.
                % ======================================================= %
                
                app.UITableSPN.Data = PLOT.Table;
                app.UITableSPN.RowName = PLOT.Table.Properties.RowNames;
                app.UITableSPN.ColumnName = PLOT.Table.Properties.VariableNames;
                %                 app.UITableSPN.ColumnFormat = repmat({'bank'},1,length(PLOT.Legend));
                
                app.UITableSPN.Visible = 1;
                
                % ======================================================= %
                % Determine XTick for the line plot and set the UIAXES
                % XTICK property.
                % ======================================================= %
                
                if any(PLOT.Time > 100)
                    TimeFormat = 'ms';
                    PLOT.StartEnd = [round(PLOT.Time(1),-2) round(PLOT.Time(end),-2)];
                    PLOT.Intervals = ((PLOT.StartEnd(2) - PLOT.StartEnd(1)) / 100) + 1;
                    PLOT.NewTime = linspace(PLOT.StartEnd(1),PLOT.StartEnd(2),PLOT.Intervals);
                else
                    TimeFormat = 's';
                    PLOT.StartEnd = [round(PLOT.Time(1),1) round(PLOT.Time(end),1)];
                    PLOT.Intervals = ((PLOT.StartEnd(2) - PLOT.StartEnd(1)) / 0.1) + 1;
                    PLOT.NewTime = linspace(PLOT.StartEnd(1),PLOT.StartEnd(2),PLOT.Intervals);
                end
                
                set(app.UIAxesWaveform,'XTick',PLOT.NewTime);
                
                % ======================================================= %
                % Clear the UIAXESWAVEFORM, then plot the waveform.
                % ======================================================= %
                
                cla(app.UIAxesWaveform);
                
                for iLine = 1:size(PLOT.Line_Data,2)
                    plot(app.UIAxesWaveform,PLOT.Time,PLOT.Line_Data(:,iLine));
                    if ~ishold(app.UIAxesWaveform)
                        hold(app.UIAxesWaveform,'on');
                    end
                end
                legend(app.UIAxesWaveform,PLOT.Legend);
                hold(app.UIAxesWaveform,'off');
                
                % ======================================================= %
                % We do some maths to get an appropriate value
                % for the Y AXIS.
                % ======================================================= %
                
                MinVal = min(PLOT.Line_Data,[],'all');
                MaxVal = max(PLOT.Line_Data,[],'all');
                
                if MinVal < 0
                    MinVal = MinVal*1.2;
                else
                    MinVal = MinVal - (MinVal*0.2);
                end
                
                if MaxVal < 0
                    MaxVal = MaxVal + (MaxVal*0.2);
                else
                    MaxVal = MaxVal*1.2;
                end
                
                axis(app.UIAxesWaveform,[PLOT.NewTime(1) PLOT.NewTime(end) MinVal MaxVal])
                
                % ======================================================= %
                % Now we do some general configuration to make the plot
                % look a bit nicer.
                % ======================================================= %
                
                grid(app.UIAxesWaveform,'on');
                box(app.UIAxesWaveform,'on');
                
                set(app.UIAxesWaveform, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
                app.UIAxesWaveform.XLabel.String = ['Time (' TimeFormat ')'];
                app.UIAxesWaveform.YLabel.String = 'Amplitude (uV)';
                
                app.UIAxesWaveform.Visible = 1;
                
                % ======================================================= %
                % Plot and configure the bar chart containing mean values.
                % ======================================================= %
                
                cla(app.UIAxesBar);
                
                bar(app.UIAxesBar,1:length(PLOT.Mean_in_Range),PLOT.Mean_in_Range);
                hold(app.UIAxesBar,'on');
                ErrorHandle = errorbar(app.UIAxesBar,PLOT.Mean_in_Range,PLOT.STD_in_Range);
                
                ErrorHandle.Color = [0 0 0];
                ErrorHandle.LineStyle = 'none';
                
                grid(app.UIAxesBar,'on');
                box(app.UIAxesBar,'on');
                
                set(app.UIAxesBar,'XTick',1:length(PLOT.Legend));
                set(app.UIAxesBar,'XTickLabel',PLOT.Legend);
                
                app.UIAxesBar.XLabel.String = 'Condition';
                app.UIAxesBar.YLabel.String = 'Mean Amplitude (uV)';
                
                yline(app.UIAxesBar,0,'LineWidth',2);
                
                hold(app.UIAxesBar,'off');
                
                app.UIAxesBar.Visible = 1;
                
                drawnow;
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end
        
        function RefreshExperimentLists(app)
            
            % Refreshes the EXPERIMENT LSITBOX for each experiment to the
            % values inside the CURRENTPROJECT structure.
            
            try
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Experiment});
                
                for iExp = 1:length(UniqueExperiments)
                    
                    % =================================================== %
                    % This will only run if there are actually conditions
                    % that have been selected in the EXPERIMENTS LISTBOX.
                    % ======================================================= %
                    
                    value = app.(['Experiment' num2str(iExp) 'ListBox']).Value;
                    
                    if isempty(value)
                        continue
                    end
                    
                    for iVal = value
                        
                        ConditionIndex = find([app.CURRENTPROJECT.SPNID] == iVal);
                        
                        ElectrodeSelection = app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes;
                        TimeSelection = app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time;
                        ElectrodeOption = app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option;
                        TimeOption = app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time_Option;
                        
                        ElectrodeSelection = unique(ElectrodeSelection);
                        
                        app.(['Electrodes' num2str(iExp) 'ListBox']).Value = ElectrodeSelection;
                        app.(['Start' num2str(iExp) 'EditField']).Value = str2double(TimeSelection{1});
                        app.(['End' num2str(iExp) 'EditField']).Value = str2double(TimeSelection{2});
                        app.(['Cluster' num2str(iExp) 'DropDown']).Value = ElectrodeOption;
                        app.(['Time' num2str(iExp) 'DropDown']).Value = TimeOption;
                        
                    end
                    
                end
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end
        
        function ParametersStatusCheck(app)
            
            % This enables and disables the appropriate editable fields
            % depending on whether conditions have been selected in the
            % EXPERIMENTS LISTBOX for each EXPERIMENT.
            
            try
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Experiment});
                
                for iExp = 1:length(UniqueExperiments)
                    
                    % =================================================== %
                    % Get the selected experiments and whether plotting is
                    % enabled.
                    % =================================================== %
                    
                    SelectedExperiments = app.(['Experiment' num2str(iExp) 'ListBox']).Value;
                    PlottingEnabled = app.PlotButton.Value;
                    
                    % =================================================== %
                    % Enable/disable multiselect depending on whether
                    % plotting is enabled.
                    % =================================================== %
                    
                    app.(['Experiment' num2str(iExp) 'ListBox']).Multiselect = PlottingEnabled;
                    
                    % =================================================== %
                    % If plotting is enabled, disable all boxes, besides
                    % the experiments listbox. If plotting is disabled and
                    % experiments are not selected, disable all boxes
                    % besides the experiments listbox. If plotting is
                    % disabled and experiments are selected, enable the
                    % cluster and time drop down boxes. If CUSTOM is
                    % selected for any box, enable the appropriate boxes.
                    % =================================================== %
                    
                    if PlottingEnabled
                        
                        app.(['Cluster' num2str(iExp) 'DropDown']).Enable = 0;
                        app.(['Time' num2str(iExp) 'DropDown']).Enable = 0;
                        app.(['Electrodes' num2str(iExp) 'ListBox']).Enable = 0;
                        app.(['Start' num2str(iExp) 'EditField']).Enable = 0;
                        app.(['End' num2str(iExp) 'EditField']).Enable = 0;
                        
                    elseif isempty(SelectedExperiments)
                        
                        app.(['Cluster' num2str(iExp) 'DropDown']).Enable = 0;
                        app.(['Time' num2str(iExp) 'DropDown']).Enable = 0;
                        app.(['Electrodes' num2str(iExp) 'ListBox']).Enable = 0;
                        app.(['Start' num2str(iExp) 'EditField']).Enable = 0;
                        app.(['End' num2str(iExp) 'EditField']).Enable = 0;
                        
                    else
                        
                        app.(['Cluster' num2str(iExp) 'DropDown']).Enable = 1;
                        app.(['Time' num2str(iExp) 'DropDown']).Enable = 1;
                        
                        TimeOption = app.(['Time' num2str(iExp) 'DropDown']).Value;
                        ElectrodeOption = app.(['Cluster' num2str(iExp) 'DropDown']).Value;
                        
                        % =============================================== %
                        % Configure time.
                        % =============================================== %
                        
                        if strcmp(TimeOption, 'Custom')
                            app.(['Start' num2str(iExp) 'EditField']).Enable = 1;
                            app.(['End' num2str(iExp) 'EditField']).Enable = 1;
                        else
                            app.(['Start' num2str(iExp) 'EditField']).Enable = 0;
                            app.(['End' num2str(iExp) 'EditField']).Enable = 0;
                        end
                        
                        % =============================================== %
                        % Configure electrodes.
                        % =============================================== %
                        
                        if strcmp(ElectrodeOption, 'Custom')
                            app.(['Electrodes' num2str(iExp) 'ListBox']).Enable = 1;
                        else
                            app.(['Electrodes' num2str(iExp) 'ListBox']).Enable = 0;
                        end
                        
                    end
                    
                end
                
            catch ME
                ThrowError(app,ME);
            end
            
        end
        
        % % %         function [PROJECT,EXP,CAT,APPENDIX,VALIDATE] = CreateSimplifiedCatalogue(app)
        % % %
        % % %             % ======================================================= %
        % % %             % Read CAT_ORIG file.
        % % %             % ======================================================= %
        % % %
        % % %             CAT_ORIG = readtable('Catalogue.csv');
        % % %
        % % %             APPENDIX_opts = detectImportOptions('Appendix.csv');
        % % %             APPENDIX_opts = setvaropts(APPENDIX_opts,{'SET_Suffix' 'SET_ICA_Suffix' 'SET_ICA_Max_Suffix'},'WhiteSpaceRule','preserve');
        % % %             APPENDIX = readtable('Appendix.csv',APPENDIX_opts);
        % % %
        % % %             % ======================================================= %
        % % %             % Remove NaN rows.
        % % %             % ======================================================= %
        % % %
        % % %             CAT_ORIG(find(isnan(table2array(CAT_ORIG(2:end,1))))+1,:) = [];
        % % %
        % % %             % ======================================================= %
        % % %             % Let's get the mean SPN for the original clusters to do
        % % %             % some validation later.
        % % %             % ======================================================= %
        % % %
        % % %             VALIDATE = table(CAT_ORIG.ProjectFolder, CAT_ORIG.SubFolder, CAT_ORIG.SPNID, CAT_ORIG.M, CAT_ORIG.SD, CAT_ORIG.M_1,CAT_ORIG.M_2,CAT_ORIG.M_3,CAT_ORIG.D,'VariableNames',{'Project' 'Experiment' 'SPNID' 'MeanSPN' 'SPN_SD' 'MeanSPN1' 'MeanSPN2' 'MeanSPN3' 'D'});
        % % %
        % % %             % ======================================================= %
        % % %             % We are only interested in certain columns of CAT_ORIG. Some
        % % %             % columns have duplicate names so we need to avoid them.
        % % %             % ======================================================= %
        % % %
        % % %             CAT_ORIG = CAT_ORIG(:,1:26);
        % % %
        % % %             % ======================================================= %
        % % %             % Extract appropriate columns and rename as necessary.
        % % %             % ======================================================= %
        % % %
        % % %             Titles = CAT_ORIG.Properties.VariableNames;
        % % %             %             Titles = CAT_ORIG(1,:);
        % % %             ColsToKeep = find(~cell2mat(cellfun(@(x) isnumeric(x), Titles, 'UniformOutput',false)));
        % % %             Titles = Titles(ColsToKeep);
        % % %             ColToRename = find(cellfun(@(x) ~isempty(str2num(x(1))),Titles));
        % % %             Titles(ColToRename) = cellfun(@(x) ['C' x],Titles(ColToRename),'UniformOutput',false);
        % % %             Titles = strrep(strrep(strrep(Titles,' ',''),'.','_'),'%','');
        % % %
        % % %             % ======================================================= %
        % % %             % Extract appropriate portion of catlogue.
        % % %             % ======================================================= %
        % % %
        % % %             CAT_ORIG = CAT_ORIG(:,ColsToKeep);
        % % %             CAT_ORIG = table2struct(CAT_ORIG);
        % % %
        % % %             % ======================================================= %
        % % %             % Create simplified catalogue.
        % % %             % ======================================================= %
        % % %
        % % %             CAT = table();
        % % %
        % % %             CAT.SPNID = [CAT_ORIG.SPNID]';
        % % %             CAT.Project = [CAT_ORIG.ProjectFolder]';
        % % %
        % % %             for iCond = 1:length(CAT_ORIG)
        % % %                 CAT.Experiment{iCond,1} = strrep(strrep(CAT_ORIG(iCond).SubFolder,'N/A','EX1'),'Sup EX','SX');
        % % %                 CAT.Experiment{iCond,1} = CAT.Experiment{iCond,1}(1:3);
        % % %                 CAT.Full_Name{iCond,1} = ['P' nDigitString(CAT.Project(iCond,1),3) '_' CAT.Experiment{iCond,1}];
        % % %             end
        % % %
        % % %             CAT.Experiment_Folder = {CAT_ORIG.SubFolder}';
        % % %
        % % %             CAT.N = [CAT_ORIG.NInCondition]';
        % % %             CAT.AKA = {CAT_ORIG.NickName}';
        % % %             CAT.Year = {CAT_ORIG.Year}';
        % % %             CAT.Regular_Condition = {CAT_ORIG.Regular}';
        % % %             CAT.Irregular_Condition = {CAT_ORIG.LessRegularComparision}';
        % % %
        % % %             CAT.Electrodes_Original = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.OriginalElectrodeCluster},'UniformOutput',false)';
        % % %             CAT.Electrodes_Cluster_1 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster1},'UniformOutput',false)';
        % % %             CAT.Electrodes_Cluster_2 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster2},'UniformOutput',false)';
        % % %             CAT.Electrodes_Cluster_3 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster3},'UniformOutput',false)';
        % % %             CAT.Electrodes_Custom = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.OriginalElectrodeCluster},'UniformOutput',false)';
        % % %             CAT.Window_Original = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.OriginalTimeWindow},'UniformOutput',false)';
        % % %             %             CAT.Window_Cluster = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.TimeWindowForClusters},'UniformOutput',false)';
        % % %             CAT.Window_Custom = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.OriginalTimeWindow},'UniformOutput',false)';
        % % %
        % % %             CAT.Attend_Regularity = [CAT_ORIG.AttendRegularity]';
        % % %             CAT.W = [CAT_ORIG.WCalculation]';
        % % %             CAT.SPN = VALIDATE.MeanSPN;
        % % %             CAT.SD = VALIDATE.SPN_SD;
        % % %             CAT.D = VALIDATE.D;
        % % %             CAT.SPN1 = VALIDATE.MeanSPN1;
        % % %             CAT.SPN2 = VALIDATE.MeanSPN2;
        % % %             CAT.SPN3 = VALIDATE.MeanSPN3;
        % % %
        % % %             CAT.Regular_Prefix = APPENDIX.Prefix_Regular;
        % % %             CAT.Irregular_Prefix = APPENDIX.Prefix_Irregular;
        % % %
        % % %             CAT.Regular_Prefix_AllData = APPENDIX.Prefix_Regular_AllData;
        % % %             CAT.Irregular_Prefix_AllData = APPENDIX.Prefix_Irregular_AllData;
        % % %
        % % %             CAT.Time_Vector_Name = APPENDIX.TimeVectorName;
        % % %
        % % %             CAT.Post_AVG_Suffix = APPENDIX.PostAVGSuffix;
        % % %             CAT.Post_AVG_Suffix_AllData = APPENDIX.PostAVGSuffix_AllData;
        % % %
        % % %             CAT.Skip_Subjects = cellfun(@(x) strsplit(x,'; '),APPENDIX.SkipSubjects,'UniformOutput',false);
        % % %             CAT.Skip_Subjects = cellfun(@(x) cellfun(@str2num,x,'UniformOutput',false),CAT.Skip_Subjects,'UniformOutput',false);
        % % %
        % % %             CAT.Skip_Subjects_AllData = cellfun(@(x) strsplit(x,'; '),APPENDIX.SkipSubjects_AllData,'UniformOutput',false);
        % % %             CAT.Skip_Subjects_AllData = cellfun(@(x) cellfun(@str2num,x,'UniformOutput',false),CAT.Skip_Subjects_AllData,'UniformOutput',false);
        % % %
        % % %             CAT.Folder_Override = cellfun(@(x) strsplit(x,'; '), APPENDIX.FolderOverride,'UniformOutput',false);
        % % %             CAT.Folder_Override_AllData = cellfun(@(x) strsplit(x,'; '), APPENDIX.FolderOverride_AllData,'UniformOutput',false);
        % % %
        % % %             CAT.Condition_Name_Override = APPENDIX.ConditionOverride;
        % % %
        % % %             CAT.Two_Digit_Subject_String = APPENDIX.Two_Digit_Subject_String_Original;
        % % %             CAT.Two_Digit_Subject_String_AllData = APPENDIX.Two_Digit_Subject_String_AllData;
        % % %
        % % %             CAT.SET_Suffix = APPENDIX.SET_Suffix;
        % % %             CAT.SET_ICA_Suffix = APPENDIX.SET_ICA_Suffix;
        % % %             CAT.SET_ICA_Max_Suffix = APPENDIX.SET_ICA_Max_Suffix;
        % % %
        % % %             CAT.Task_Names = APPENDIX.Task_Names;
        % % %             CAT.File_Notes = APPENDIX.File_Notes;
        % % %
        % % %             CAT = table2struct(CAT);
        % % %
        % % %             % ======================================================= %
        % % %             % Produce Projects.
        % % %             % ======================================================= %
        % % %
        % % %             UniqueProjects = unique([CAT.Project]);
        % % %
        % % %             PROJECT = struct();
        % % %             Count = 0;
        % % %             for iProject = 1:length(UniqueProjects)
        % % %
        % % %                 CurrentProjectIndices = [CAT.Project] == UniqueProjects(iProject);
        % % %                 CurrentProjectCond = CAT(CurrentProjectIndices);
        % % %
        % % %                 PROJECT(iProject).Project = CurrentProjectCond(1).Project;
        % % %                 PROJECT(iProject).Experiment = {CurrentProjectCond.Experiment};
        % % %                 PROJECT(iProject).Full_Name = {CurrentProjectCond.Full_Name};
        % % %                 PROJECT(iProject).N = [CurrentProjectCond.N];
        % % %                 PROJECT(iProject).SPNID = [CurrentProjectCond.SPNID];
        % % %                 PROJECT(iProject).Regular_Condition = {CurrentProjectCond.Regular_Condition};
        % % %                 PROJECT(iProject).W = [CurrentProjectCond.W];
        % % %                 PROJECT(iProject).Attend_Regularity = [CurrentProjectCond.Attend_Regularity];
        % % %
        % % %             end
        % % %
        % % %             % ======================================================= %
        % % %             % Produce Experiments.
        % % %             % ======================================================= %
        % % %
        % % %             UniqueExperiments = unique({CAT.Full_Name});
        % % %
        % % %             EXP = struct();
        % % %             Count = 0;
        % % %             for iExp = 1:length(UniqueExperiments)
        % % %
        % % %                 CurrentExperimentIndices = strcmp({CAT.Full_Name},UniqueExperiments{iExp});
        % % %                 CurrentExperimentCond = CAT(CurrentExperimentIndices);
        % % %
        % % %                 EXP(iExp).Project = CurrentExperimentCond(1).Project;
        % % %                 EXP(iExp).Experiment = CurrentExperimentCond(1).Experiment;
        % % %                 EXP(iExp).Full_Name = CurrentExperimentCond(1).Full_Name;
        % % %                 EXP(iExp).N = CurrentExperimentCond(1).N;
        % % %                 EXP(iExp).SPNID = [CurrentExperimentCond.SPNID];
        % % %                 EXP(iExp).Regular_Condition = {CurrentExperimentCond.Regular_Condition};
        % % %                 EXP(iExp).W = [CurrentExperimentCond.W];
        % % %                 EXP(iExp).Attend_Regularity = [CurrentExperimentCond.Attend_Regularity];
        % % %
        % % %             end
        % % %
        % % %         end
        
    end
    
    methods (Access = public)
        
        % % %         function [Condition_Data, Error] = ExtractConditionData(app,SPNID,InfoOnly,varargin)
        % % %
        % % %             % varargin input order:
        % % %             %
        % % %             % varargin{1} = BDF
        % % %             % varargin{2} = SET (Epoched)
        % % %             % varargin{3} = SET (Epoched, ICA)
        % % %             % varargin{4} = SET (Epoched, ICA, Max)
        % % %             % varargin{5} = TriggerInfo
        % % %
        % % %             if length(varargin) == 0
        % % %                 varargin = {0 0 0 0 0};
        % % %             elseif length(varargin) == 1
        % % %                 varargin = {varargin{1} 0 0 0};
        % % %             elseif length(varargin) == 2
        % % %                 varargin = {varargin{1} varargin{2} 0 0};
        % % %             elseif length(varargin) == 3
        % % %                 varargin = {varargin{1} varargin{2} varargin{3} 0};
        % % %             elseif length(varargin) == 4
        % % %                 varargin = {varargin{1} varargin{2} varargin{3} varargin{4} 0};
        % % %             end
        % % %
        % % %             Condition_Data = app.CAT([app.CAT.SPNID] == SPNID);
        % % %
        % % %             % ======================================================= %
        % % %             % Check existence of the REGULARITY condition files.
        % % %             % ======================================================= %
        % % %
        % % %             Error = 0;
        % % %
        % % %             % =============================================== %
        % % %             % The suffix is defined based on the corresponding
        % % %             % SUFFIX from the CONDITIONS file.
        % % %             % =============================================== %
        % % %
        % % %             Prefix_Reg = Condition_Data.Regular_Prefix;
        % % %             Prefix_Irreg = Condition_Data.Irregular_Prefix;
        % % %
        % % %             Prefix_Reg_AllData = Condition_Data.Regular_Prefix_AllData;
        % % %             Prefix_Irreg_AllData = Condition_Data.Irregular_Prefix_AllData;
        % % %
        % % %             PostAVGSuffix = Condition_Data.Post_AVG_Suffix;
        % % %             PostAVGSuffix_AllData = Condition_Data.Post_AVG_Suffix_AllData;
        % % %
        % % %             Suffix_Reg = [Prefix_Reg 'AVG' PostAVGSuffix '.mat'];
        % % %             Suffix_Irreg = [Prefix_Irreg 'AVG' PostAVGSuffix '.mat'];
        % % %
        % % %             Suffix_Reg_AllData = [Prefix_Reg_AllData PostAVGSuffix_AllData '.set'];
        % % %             Suffix_Irreg_AllData = [Prefix_Irreg_AllData PostAVGSuffix_AllData '.set'];
        % % %
        % % %             % =============================================== %
        % % %             % The folder depends on whether there were multiple
        % % %             % experiments for the project. For example, if
        % % %             % there was more than one experiment, the path is
        % % %             % directed to the corresponding sub folder in the
        % % %             % PROJECT folder.
        % % %             % =============================================== %
        % % %
        % % %             Folder = {};
        % % %             if ~isempty(Condition_Data.Folder_Override{1})
        % % %                 for iFolder = 1:length(Condition_Data.Folder_Override)
        % % %                     Folder{iFolder} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) filesep Condition_Data.Folder_Override{iFolder} filesep];
        % % %                 end
        % % %             elseif strcmp(Condition_Data.Experiment_Folder,'N/A')
        % % %                 Folder{1} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) filesep];
        % % %             else
        % % %                 Folder{1} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) filesep Condition_Data.Experiment_Folder filesep];
        % % %             end
        % % %
        % % %             Folder_AllData = {};
        % % %             if ~isempty(Condition_Data.Folder_Override_AllData{1})
        % % %                 for iFolder = 1:length(Condition_Data.Folder_Override_AllData)
        % % %                     Folder_AllData{iFolder} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep Condition_Data.Folder_Override_AllData{iFolder} filesep];
        % % %                 end
        % % %             elseif strcmp(Condition_Data.Experiment_Folder,'N/A')
        % % %                 Folder_AllData{1} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep];
        % % %             else
        % % %                 Folder_AllData{1} = [app.DATADIR filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep Condition_Data.Experiment_Folder filesep];
        % % %             end
        % % %
        % % %             % =============================================== %
        % % %             % We extract the subject numbers that are in the
        % % %             % project folder.
        % % %             % =============================================== %
        % % %
        % % %             SubjectNumbers_Reg = {}; SubjectFiles_Reg = {};
        % % %             SubjectNumbers_Irreg = {}; SubjectFiles_Irreg = {};
        % % %             for iFolder = 1:length(Folder)
        % % %                 [SubjectNumbers_Reg{iFolder}, SubjectFiles_Reg{iFolder}] = CheckFileExistence(app,Folder{iFolder},Suffix_Reg,Condition_Data.Two_Digit_Subject_String);
        % % %                 [SubjectNumbers_Irreg{iFolder}, SubjectFiles_Irreg{iFolder}] = CheckFileExistence(app,Folder{iFolder},Suffix_Irreg,Condition_Data.Two_Digit_Subject_String);
        % % %             end
        % % %
        % % %             SubjectNumbers_Reg_AllData = {}; SubjectFiles_Reg_AllData = {};
        % % %             SubjectNumbers_Irreg_AllData = {}; SubjectFiles_Irreg_AllData = {};
        % % %             for iFolder = 1:length(Folder_AllData)
        % % %                 [SubjectNumbers_Reg_AllData{iFolder}, SubjectFiles_Reg_AllData{iFolder}] = CheckFileExistence(app,Folder_AllData{iFolder},Suffix_Reg_AllData,Condition_Data.Two_Digit_Subject_String_AllData);
        % % %                 [SubjectNumbers_Irreg_AllData{iFolder}, SubjectFiles_Irreg_AllData{iFolder}] = CheckFileExistence(app,Folder_AllData{iFolder},Suffix_Irreg_AllData,Condition_Data.Two_Digit_Subject_String_AllData);
        % % %             end
        % % %
        % % %             % =============================================== %
        % % %             % Delete subjects present in the SKIP column.
        % % %             % =============================================== %
        % % %
        % % %             for iFolder = 1:length(Folder)
        % % %
        % % %                 try
        % % %                     SubjectsToSkip = Condition_Data.Skip_Subjects{iFolder};
        % % %                 catch
        % % %                     SubjectsToSkip = [];
        % % %                 end
        % % %
        % % %                 DeleteIndices_Reg = ismember(SubjectNumbers_Reg{iFolder},SubjectsToSkip);
        % % %                 SubjectNumbers_Reg{iFolder}(DeleteIndices_Reg) = [];
        % % %                 SubjectFiles_Reg{iFolder}(DeleteIndices_Reg) = [];
        % % %
        % % %                 DeleteIndices_Irreg = ismember(SubjectNumbers_Irreg{iFolder},SubjectsToSkip);
        % % %                 SubjectNumbers_Irreg{iFolder}(DeleteIndices_Irreg) = [];
        % % %                 SubjectFiles_Irreg{iFolder}(DeleteIndices_Irreg) = [];
        % % %
        % % %             end
        % % %
        % % %             for iFolder = 1:length(Folder_AllData)
        % % %
        % % %                 try
        % % %                     SubjectsToSkip = Condition_Data.Skip_Subjects_AllData{iFolder};
        % % %                 catch
        % % %                     SubjectsToSkip = [];
        % % %                 end
        % % %
        % % %                 DeleteIndices_Reg = ismember(SubjectNumbers_Reg_AllData{iFolder},SubjectsToSkip);
        % % %                 SubjectNumbers_Reg_AllData{iFolder}(DeleteIndices_Reg) = [];
        % % %                 SubjectFiles_Reg_AllData{iFolder}(DeleteIndices_Reg) = [];
        % % %
        % % %                 DeleteIndices_Irreg = ismember(SubjectNumbers_Irreg_AllData{iFolder},SubjectsToSkip);
        % % %                 SubjectNumbers_Irreg_AllData{iFolder}(DeleteIndices_Irreg) = [];
        % % %                 SubjectFiles_Irreg_AllData{iFolder}(DeleteIndices_Irreg) = [];
        % % %
        % % %             end
        % % %
        % % %             % =============================================== %
        % % %             % Compare subject numbers between different project
        % % %             % folders for same exeriment.
        % % %             % =============================================== %
        % % %
        % % %             if varargin{1} | varargin{2} | varargin{3} | varargin{4}
        % % %
        % % %                 if length(cat(2,SubjectNumbers_Reg{:})) ~= length(cat(2,SubjectNumbers_Reg_AllData{:}))
        % % %                     disp(['Subject numbers not the same between original folder and alldata - ' Condition_Data.Full_Name ' (SPN ' num2str(Condition_Data.SPNID) ' Reglar Condition)!']);
        % % %                     disp(['Original Folder = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
        % % %                     disp(['AllData Folder = ' num2str(cat(2,SubjectNumbers_Reg_AllData{:}))]);
        % % %                     Error = 1;
        % % %                 end
        % % %
        % % %                 if length(cat(2,SubjectNumbers_Irreg{:})) ~= length(cat(2,SubjectNumbers_Irreg_AllData{:}))
        % % %                     disp(['Subject numbers not the same between original folder and alldata - ' Condition_Data.Full_Name ' (SPN ' num2str(Condition_Data.SPNID) ' Irregular Condition)!']);
        % % %                     disp(['Original Folder = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
        % % %                     disp(['AllData Folder = ' num2str(cat(2,SubjectNumbers_Reg_AllData{:}))]);
        % % %                     Error = 1;
        % % %                 end
        % % %
        % % %             end
        % % %
        % % %             % =============================================== %
        % % %             % We configure some output depending on what we
        % % %             % would expect. We would expect the SUBJECTNUMBERS
        % % %             % to correspond to the expected number in the
        % % %             % catalogue.
        % % %             % =============================================== %
        % % %
        % % %             if Condition_Data.N ~= length(cat(2,SubjectNumbers_Reg{:})) |  Condition_Data.N ~= length(cat(2,SubjectNumbers_Irreg{:}))
        % % %                 disp(['Catalogue reports ' num2str(Condition_Data.N) ' subjects, but ' num2str(length(cat(2,SubjectNumbers_Reg{:}))) ' were found for [' Condition_Data.Full_Name '] - [SPN ' num2str(Condition_Data.SPNID) ' ' Condition_Data.Regular_Prefix ']']);
        % % %                 disp(['Subjects Found = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
        % % %                 disp(['Catalogue reports ' num2str(Condition_Data.N) ' subjects, but ' num2str(length(cat(2,SubjectNumbers_Irreg{:}))) ' were found for [' Condition_Data.Full_Name '] - [SPN ' num2str(Condition_Data.SPNID) ' ' Condition_Data.Irregular_Prefix ']'])
        % % %                 disp(['Subjects Found = ' num2str(cat(2,SubjectNumbers_Irreg{:}))]);
        % % %                 Error = 1;
        % % %             elseif ~all(cat(2,SubjectNumbers_Reg{:}) == cat(2,SubjectNumbers_Irreg{:}))
        % % %                 disp(['Subject numbers for [' Condition_Data.Full_Name '] - [SPN ' num2str(num2str(Condition_Data.SPNID)) ' ' Condition_Data.Regular_Prefix '] do not match numbers for [' Condition_Data.Full_Name '] - [SPN ' num2str(num2str(Condition_Data.SPNID)) ' ' Condition_Data.Irregular_Prefix ']']);
        % % %                 Error = 1;
        % % %             end
        % % %
        % % %             % =========================================== %
        % % %             % We can assume the BDF files have the same subject numbers as
        % % %             % the set files, so we just use those subject numbers.
        % % %             % =========================================== %
        % % %
        % % %             BDF_Files = {};
        % % %             if varargin{1}
        % % %                 for iFolder = 1:length(Folder_AllData)
        % % %                     for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
        % % %                         if Condition_Data.Two_Digit_Subject_String_AllData
        % % %                             BDF_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep '*.bdf']);
        % % %                         else
        % % %                             BDF_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep '*.bdf']);
        % % %                         end
        % % %                         if isempty(BDF_Files{iFolder}{iSub})
        % % %                             disp(['No BDF file present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
        % % %                             Error = 1;
        % % %                         end
        % % %                     end
        % % %                 end
        % % %             end
        % % %
        % % %             % =========================================== %
        % % %             % We can assume the SET files have the same subject numbers as
        % % %             % the set files, so we just use those subject numbers.
        % % %             % =========================================== %
        % % %
        % % %             % SET (Epoched).
        % % %
        % % %             SET_Epoched_Files = {};
        % % %             if varargin{2}
        % % %                 if isempty(Condition_Data.SET_Suffix)
        % % %                     disp(['No SET file (Epoched) listed in APPENDIX for ' Condition_Data.Full_Name]);
        % % %                     Error = 1;
        % % %                 else
        % % %                     for iFolder = 1:length(Folder_AllData)
        % % %                         for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
        % % %                             if Condition_Data.Two_Digit_Subject_String_AllData
        % % %                                 SET_Epoched_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_Suffix]);
        % % %                             else
        % % %                                 SET_Epoched_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_Suffix]);
        % % %                             end
        % % %                             if isempty(SET_Epoched_Files{iFolder}{iSub})
        % % %                                 disp(['No SET file (Epoched) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
        % % %                                 Error = 1;
        % % %                             end
        % % %                         end
        % % %                     end
        % % %                 end
        % % %             end
        % % %
        % % %             % SET (Epoched, ICA).
        % % %
        % % %             SET_Epoched_ICA_Files = {};
        % % %             if varargin{3}
        % % %                 if isempty(Condition_Data.SET_ICA_Suffix)
        % % %                     disp(['No SET file (Epoched, ICA) listed in APPENDIX for ' Condition_Data.Full_Name]);
        % % %                     Error = 1;
        % % %                 else
        % % %                     for iFolder = 1:length(Folder_AllData)
        % % %                         for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
        % % %                             if Condition_Data.Two_Digit_Subject_String_AllData
        % % %                                 SET_Epoched_ICA_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_ICA_Suffix]);
        % % %                             else
        % % %                                 SET_Epoched_ICA_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_ICA_Suffix]);
        % % %                             end
        % % %                             if isempty(SET_Epoched_ICA_Files{iFolder}{iSub})
        % % %                                 disp(['No SET file (Epoched, ICA) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
        % % %                                 Error = 1;
        % % %                             end
        % % %                         end
        % % %                     end
        % % %                 end
        % % %             end
        % % %
        % % %             % SET (Epoched, ICA, Max).
        % % %
        % % %             SET_Epoched_ICA_Max_Files = {};
        % % %             if varargin{4}
        % % %                 if isempty(Condition_Data.SET_ICA_Max_Suffix)
        % % %                     disp(['No SET file (Epoched, ICA, Max) listed in APPENDIX for ' Condition_Data.Full_Name]);
        % % %                     Error = 1;
        % % %                 else
        % % %                     for iFolder = 1:length(Folder_AllData)
        % % %                         for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
        % % %                             if Condition_Data.Two_Digit_Subject_String_AllData
        % % %                                 SET_Epoched_ICA_Max_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_ICA_Max_Suffix]);
        % % %                             else
        % % %                                 SET_Epoched_ICA_Max_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_ICA_Max_Suffix]);
        % % %                             end
        % % %                             if isempty(SET_Epoched_ICA_Max_Files{iFolder}{iSub})
        % % %                                 disp(['No SET file (Epoched, ICA, Max) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
        % % %                                 Error = 1;
        % % %                             end
        % % %                         end
        % % %                     end
        % % %                 end
        % % %             end
        % % %
        % % %             % =========================================== %
        % % %             % We can also extract the triggerInfo file from the parent
        % % %             % alldata directory.
        % % %             % =========================================== %
        % % %
        % % %             Trigger_Info_Files = {}; TEMP = {};
        % % %             if varargin{5}
        % % %                 for iFolder = 1:length(Folder_AllData)
        % % %                     Trigger_Info_Files{iFolder} = dir([Folder_AllData{iFolder} 'triggerInfo.mat']);
        % % %                     if isempty(Trigger_Info_Files{iFolder})
        % % %                         disp(['No triggerInfo file for ' Condition_Data.Full_Name '!'])
        % % %                         Error = 1;
        % % %                     else
        % % %                         TEMP{iFolder} = load(fullfile(Trigger_Info_Files{iFolder}.folder,Trigger_Info_Files{iFolder}.name));
        % % %                         TEMP{iFolder} = TEMP{iFolder}.triggerInfo;
        % % %                         TEMP{iFolder}(cellfun(@isnumeric,TEMP{iFolder})) = cellfun(@num2str,(TEMP{iFolder}(cellfun(@isnumeric,TEMP{iFolder}))),'UniformOutput',false);
        % % %                     end
        % % %                 end
        % % %                 if ~isempty(TEMP) & length(TEMP) > 1
        % % %                     if isempty(setdiff(TEMP{:}))
        % % %                         Trigger_Info_Files = Trigger_Info_Files{1};
        % % %                     else
        % % %                         disp(['Multiple triggerInfo files that do not match for ' Condition_Data.Full_Name ' do not match!']);
        % % %                         Error = 1;
        % % %                     end
        % % %                 else
        % % %                     Trigger_Info_Files = Trigger_Info_Files{1};
        % % %                 end
        % % %             end
        % % %
        % % %             % % %             % =========================================== %
        % % %             % % %             % Extract all .m files to detail all code files in alldata.
        % % %             % % %             % =========================================== %
        % % %             % % %
        % % %             % % %             Code_Files_AllData = {};
        % % %             % % %             for iFolder = 1:length(Folder_AllData)
        % % %             % % %                 Code_Files_AllData{iFolder} = dir([Folder_AllData{iFolder} '*.m']);
        % % %             % % %
        % % %             % % %
        % % %             % % %                 [Folder_AllData{iFolder} 'triggerInfo.mat'];
        % % %             % % %                 if ~exist(Trigger_Info_Files{iFolder})
        % % %             % % %                     disp([Trigger_Info_Files{iFolder} ' does not exist, but expected!'])
        % % %             % % %                 end
        % % %             % % %             end
        % % %
        % % %             % =========================================== %
        % % %             % If no errors found above, we assign the
        % % %             % variables to the APP.CURRENTPROJECT
        % % %             % structure.
        % % %             % =============================================== %
        % % %
        % % %             Condition_Data.Folder = Folder;
        % % %             Condition_Data.SubjectNumbers = cat(2,SubjectNumbers_Reg{:});
        % % %             Condition_Data.SubjectNumbers_AllData = cat(2,SubjectNumbers_Reg_AllData{:});
        % % %             Condition_Data.SubjectFiles_Reg = cat(2,SubjectFiles_Reg{:});
        % % %             Condition_Data.SubjectFiles_Irreg = cat(2,SubjectFiles_Irreg{:});
        % % %             Condition_Data.SubjectFiles_Reg_AllData = cat(2,SubjectFiles_Reg_AllData{:});
        % % %             Condition_Data.SubjectFiles_Irreg_AllData = cat(2,SubjectFiles_Irreg_AllData{:});
        % % %             Condition_Data.SubjectFiles_BDF_AllData = cat(2,BDF_Files{:});
        % % %             Condition_Data.SubjectFiles_SET_Epoched_AllData = cat(2,SET_Epoched_Files{:});
        % % %             Condition_Data.SubjectFiles_SET_Epoched_ICA_AllData = cat(2,SET_Epoched_ICA_Files{:});
        % % %             Condition_Data.SubjectFiles_SET_Epoched_ICA_Max_AllData = cat(2,SET_Epoched_ICA_Max_Files{:});
        % % %             Condition_Data.SubjectFiles_Trigger_Info_AllData = Trigger_Info_Files;
        % % %
        % % %             if Error; return; end
        % % %
        % % %             % ======================================================= %
        % % %             % If only the info is needed, we return so as to not load the
        % % %             % data and waste processing time.
        % % %             % ======================================================= %
        % % %
        % % %             if InfoOnly
        % % %                 return
        % % %             end
        % % %
        % % %             % ======================================================= %
        % % %             % Load up the data from .mat files.
        % % %             % ======================================================= %
        % % %
        % % %             % =============================================== %
        % % %             % Loop through each subject number found in the
        % % %             % previous section.
        % % %             % =============================================== %
        % % %
        % % %             SubCount = 0;
        % % %
        % % %             for iSub = 1:length(Condition_Data.SubjectNumbers)
        % % %
        % % %                 FileName_Reg = Condition_Data.SubjectFiles_Reg{iSub};
        % % %                 FileName_Irreg = Condition_Data.SubjectFiles_Irreg{iSub};
        % % %
        % % %                 % =========================================== %
        % % %                 % Load up the regularity condition.
        % % %                 % =========================================== %
        % % %
        % % %                 if exist(FileName_Reg)
        % % %                     LoadedData = load(FileName_Reg);
        % % %                     FieldNames = fieldnames(LoadedData);
        % % %                     LoadedData = LoadedData.(FieldNames{1});
        % % %                     Condition_Data.Data(:,:,iSub) = LoadedData;
        % % %                 else
        % % %                     error(['File not found - ' FileName_Reg])
        % % %                 end
        % % %
        % % %                 % =========================================== %
        % % %                 % Load up the corresponding irregularity condition.
        % % %                 % =========================================== %
        % % %
        % % %                 if exist(FileName_Irreg)
        % % %                     LoadedData = load(FileName_Irreg);
        % % %                     FieldNames = fieldnames(LoadedData);
        % % %                     LoadedData = LoadedData.(FieldNames{1});
        % % %                     Condition_Data.Data_Irregular(:,:,iSub) = LoadedData;
        % % %                 else
        % % %                     error(['File not found - ' FileName_Irreg])
        % % %                 end
        % % %
        % % %             end
        % % %
        % % %             % ======================================================= %
        % % %             % Load up time vector for each EXPERIMENT and CONDITION.
        % % %             % Some conditions for the same experiment have different
        % % %             % time vectors. Hence, we load up the time vector for each
        % % %             % CONDITION individually.
        % % %             % ======================================================= %
        % % %
        % % %             TimeVectorFile = [Condition_Data.Folder{1} filesep Condition_Data.Time_Vector_Name '.mat'];
        % % %
        % % %             if exist(TimeVectorFile)
        % % %                 TempVar = load(TimeVectorFile);
        % % %             else
        % % %                 error(['Time Vector file not found - ' TimeVectorFile]);
        % % %             end
        % % %
        % % %             FieldNames = fieldnames(TempVar);
        % % %             Condition_Data.TimeVector = TempVar.(FieldNames{1});
        % % %
        % % %         end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
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
                    disp('Data folder not found, please provide the path to the Data folder.')
                    app.DATADIR = uigetdir;
                    waitfor(app.DATADIR);
                end
                
               % ======================================================= %
               % Add dependencies folder.
               % ======================================================= %
               
               File_Name = mfilename;
               if ~isdeployed() || strcmp(File_Name,'SPNCAT_func')
                   addpath('Dependencies');
               end
                
                % ======================================================= %
                % Create simplified catalogue files.
                % ======================================================= %
                
                [app.PROJECT,app.EXP,app.CAT,app.APPENDIX,app.VALIDATE] = CreateSimplifiedCatalogue();
                
                % ======================================================= %
                % Determine which folders are present in Data folder and remove
                % all other entries in CAT_ORIG.
                % ======================================================= %
                
                SubFolders = ListSubfolders(app.DATADIR);
                SubFolders(~contains(SubFolders,'Project')) = [];
                
                FoldersPresent = cellfun(@str2num,cellfun(@(x) regexp(x,'\d*','Match'),SubFolders));
                
                app.PROJECT(~ismember([app.PROJECT.Project],FoldersPresent)) = [];
                app.EXP(~ismember([app.EXP.Project],FoldersPresent)) = [];
                app.CAT(~ismember([app.CAT.Project],FoldersPresent)) = [];
                
                % ======================================================= %
                % Add names of project to project PROJECTS LISTBOX.
                % ======================================================= %
                
                app.ProjectsListBox.Items = cellfun(@(x) strjoin({'Project' x},' '), cellstr(num2str(cell2mat({app.PROJECT.Project})')),'UniformOutput',false);
                app.ProjectsListBox.ItemsData = [app.PROJECT.Project];
                
                % ======================================================= %
                % Load electrode locations file.
                % ======================================================= %
                
                LoadedData = load('BioSemi-64.mat');
                app.E = LoadedData.E;
                
                % ======================================================= %
                % Add electrode labels to ELECTRODES LISTBOX for each
                % EXPERIMENT.
                % ======================================================= %
                
                for iExp = 1:app.MAXEXP
                    app.(['Electrodes' num2str(iExp) 'ListBox']).Items = {app.E.labels};
                end
                
                % ======================================================= %
                % We change the PROJECTS LISTBOX value to the first folder
                % that was found.
                % ======================================================= %
                
                app.ProjectsListBox.Value = app.PROJECT(1).Project;
                
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

        % Value changed function: ProjectsListBox
        function ProjectsListBoxValueChanged(app, event)
            
            try
                
                % ======================================================= %
                % Get the value of the project that is selected. This value
                % will be an integer corresponding to the project number.
                % Next, find the index of this project inside the
                % APP.PROJECTS structure.
                % ======================================================= %
                
                Current_Project = app.ProjectsListBox.ItemsData(app.ProjectsListBox.Value);
                
                % ======================================================= %
                % Rather than having to reference the master APP.PROJECTS
                % variable each time we need data, we create another
                % structure inside the APP structure called CURRENTPROJECT.
                % This contains all of the data for the currently selected
                % project. This section will only initiate in two
                % scenarios. Firstly, it will only run if a different
                % project is selected to what has already been displayed.
                % This saves having to rerun the same code unnecessarily.
                % Secondly, it will only run if it has not been ran at all
                % yet, such as when the APP has only just opened.
                % ======================================================= %
                
                if app.INITIATED && strcmp(app.CURRENTPROJECT(1).Project,Current_Project)
                    return
                else
                    
                    Current_Conditions = [app.CAT([app.CAT.Project] == Current_Project).SPNID];
                    
                    app.CURRENTPROJECT = {};
                    
                    for iCond = 1:length(Current_Conditions)
                        [app.CURRENTPROJECT{iCond}, Error] = ExtractConditionData(app.CAT,app.DATADIR,Current_Conditions(iCond),0);
                    end
                    app.CURRENTPROJECT = vertcat(app.CURRENTPROJECT{:});
                    if ~app.INITIATED; app.INITIATED = 1; end
                    app.CATALOGUELOADED = 1;
                    
                    % ======================================================= %
                    % If error found, then return the script, since there is no
                    % point trying to load the files below. We will also update
                    % the diary so it is visible in the APP.
                    % ======================================================= %
                    
                    if Error; UpdateDiary(app); return; end
                    
                end
                
                % =================================================== %
                % In addition to the data, we also extract the relevant
                % information regarding the currently selected TIME and
                % ELECTRODE for each EXPERIMENT and CONDITION. By
                % default, the original TIME and ELECTRODE cluster is
                % selected.
                % =================================================== %
                
                for iCond = 1:length(app.CURRENTPROJECT)
                    app.CURRENTPROJECT(iCond).Cluster_Options_Electrodes = unique(app.CURRENTPROJECT(iCond).Electrodes_Original);
                    app.CURRENTPROJECT(iCond).Cluster_Options_Time = app.CURRENTPROJECT(iCond).Window_Original;
                    app.CURRENTPROJECT(iCond).Cluster_Options_Electrodes_Option = 'Original';
                    app.CURRENTPROJECT(iCond).Cluster_Options_Time_Option = 'Original';
                end
                
                % ======================================================= %
                % Assign conditions to each EXPERIMENT LISTBOX.
                % ======================================================= %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                for iExp = 1:length(UniqueExperiments)
                    
                    Experiment_Index = find(strcmp({app.CURRENTPROJECT.Full_Name},UniqueExperiments{iExp}));
                    EXPERIMENT_DATA = app.CURRENTPROJECT(Experiment_Index);
                    
                    % =================================================== %
                    % Some experiments have identical condition names,
                    % with the only thing differentiating them is whether
                    % regularity was attended to or not. Hence, we create
                    % new condition names that indicate whether regularity
                    % was attended or not.
                    % =================================================== %
                    
                    AttendRegularity = repmat({'(Attend Reg)'},length(EXPERIMENT_DATA),1);
                    AttendRegularity(~[EXPERIMENT_DATA.Attend_Regularity]) = {'(Disregard Reg)'};
                    
                    ConditionNames = {};
                    for iCond = 1:length(EXPERIMENT_DATA)
                        if isempty(EXPERIMENT_DATA(iCond).Condition_Name_Override)
                            ConditionNames{iCond} = EXPERIMENT_DATA(iCond).Regular_Condition;
                        else
                            ConditionNames{iCond} = EXPERIMENT_DATA(iCond).Condition_Name_Override;
                        end
                    end
                    
                    ListNames = ConditionNames';
                    ListNames(:,2) = AttendRegularity;
                    ListNames = join(ListNames);
                    
                    % =================================================== %
                    % Title the EXPERIMENT LSITBOX, the CONDITIONS and the
                    % ItemsData variable. There are two ways of assigning
                    % a value for a LISTBOX. First, if only the ITEMS field
                    % is given, the selected VALUE will correspond to the
                    % name of the selected value, e.g. "Reflection1".
                    % However, if the ITEMSDATA field is also given, the
                    % value will correspond to the ITEMSDATA values. Since
                    % some conditions have duplicate names, using the name
                    % of the condition is not an appropiate way to select
                    % the value. Hence, we use the SPNID value as the way
                    % to select a VALUE for the LISTBOX. Thus, the SPNID is
                    % used as the ITEMSDATA variable.
                    % =================================================== %
                    
                    app.(['Experiment' num2str(iExp) 'Panel']).Title = UniqueExperiments{iExp};
                    app.(['Experiment' num2str(iExp) 'ListBox']).Items = ListNames;
                    app.(['Experiment' num2str(iExp) 'ListBox']).Value = {};
                    app.(['Experiment' num2str(iExp) 'ListBox']).ItemsData = [EXPERIMENT_DATA.SPNID];
                    app.(['Experiment' num2str(iExp) 'Panel']).Visible = 1;
                    
                    for iCond = Experiment_Index
                        app.CURRENTPROJECT(iCond).Plot_Selection = 1;
                        app.CURRENTPROJECT(iCond).Configure_Selection = 0;
                    end
                    app.CURRENTPROJECT(Experiment_Index(1)).Configure_Selection = 1;
                    
                end
                
                % ======================================================= %
                % Since we do not want all the EXPERIMENT boxes to be
                % visible all of the time, only when being used, we empty
                % out the unused panels and make them invisible.
                % ======================================================= %
                
                if iExp < app.MAXEXP
                    for iExp = length(UniqueExperiments)+1:app.MAXEXP
                        app.(['Experiment' num2str(iExp) 'Panel']).Title = '';
                        app.(['Experiment' num2str(iExp) 'ListBox']).Items = {};
                        app.(['Experiment' num2str(iExp) 'ListBox']).Value = {};
                        app.(['Experiment' num2str(iExp) 'ListBox']).ItemsData = [];
                        app.(['Experiment' num2str(iExp) 'Panel']).Visible = 0;
                        
                    end
                end
                
                % If the function runs without this section in, delete it.
                % The structure is defined soon after in ExtractPlotData.
                
                % % %                 % ======================================================= %
                % % %                 % Create empty plot data variable. This structure will
                % % %                 % contain all data we need for plotting.
                % % %                 % ======================================================= %
                % % %
                % % %                 Condition_Data.PlotData = struct();
                
                % ======================================================= %
                % If the PLOTBUTTON is pushed down, we select all
                % conditions first, and then we extract the plot data. If
                % we are already plotting the data and then change the
                % project, selecting all of the conditions automatically
                % will stop it from crashing. If we are not plotting the
                % data, we only select the first condition for each
                % experiment. This is because multi-select of conditions is
                % only enabled when we are plotting data.
                % ======================================================= %
                
                ParametersStatusCheck(app);
                
                if app.PlotButton.Value
                    SelectConditions(app,[]);
                    ExtractPlotData(app);
                else
                    SelectConditions(app,'first');
                end
                
                % ======================================================= %
                % This allows us to refresh the selected ELECTRODES and
                % TIMES for each EXPERIMENT LISTBOX.
                % ======================================================= %
                
                RefreshExperimentLists(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
            disp(['Data loaded successfully for ' num2str(app.CURRENTPROJECT(1).Project) '.']);
            
            UpdateDiary(app);
            updateAppLayout(app, []);
            
        end

        % Value changed function: Experiment1ListBox, 
        % Experiment2ListBox, Experiment3ListBox, 
        % Experiment4ListBox, Experiment5ListBox
        function ExperimentListBoxValueChanged(app, event)
            
            % Initiated when the selected CONDITIONS for any EXPERIMENT
            % LISTBOX are changed.
            
            try
                
                % ======================================================= %
                % If we are current plotting data, as is the case if the
                % PLOTBUTTON is currently ON, we extract the plot data.
                % Else, we refresh the selected ELETRODES and TIME in the
                % EXPERIMENT PANELS, as well as check the status of the
                % EDITABLE FIELDS to be enabled or disabled depending on
                % whether there are CONDITIONS selected.
                % ======================================================= %
                
                if app.PlotButton.Value
                    
                    % =================================================== %
                    % To allow memory of previously selected conditions when
                    % plotting data, we will update a variable inside of the
                    % APP.CURRENTPROJECT structure. However, we only update
                    % this if we are currently plotting the data.
                    % =================================================== %
                    
                    UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                    
                    for iCond = 1:length(app.CURRENTPROJECT)
                        Experiment_Index = find(strcmp({app.CURRENTPROJECT(iCond).Full_Name},UniqueExperiments));
                        if isempty(app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value)
                            app.CURRENTPROJECT(iCond).Plot_Selection = 0;
                        else
                            app.CURRENTPROJECT(iCond).Plot_Selection = any(ismember(app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value,app.CURRENTPROJECT(iCond).SPNID));
                        end
                    end
                    
                    % =================================================== %
                    % If no conditions are selected across all experiments,
                    % we simply skip plotting to avoid errors. Also, turn
                    % off plots if nothing is being plotted.
                    % =================================================== %
                    
                    SelectedConditions = [app.CURRENTPROJECT.Plot_Selection];
                    
                    if all(~SelectedConditions)
                        app.UIAxesWaveform.Legend.Visible = 'off';
                        cla(app.UIAxesBar);
                        cla(app.UIAxesWaveform);
                        app.UIAxesBar.Visible = 'off';
                        app.UIAxesWaveform.Visible = 'off';
                        app.UITableSPN.Visible = 'off';
                        return
                    else
                        app.UIAxesBar.Visible = 'on';
                        app.UIAxesWaveform.Visible = 'on';
                        app.UITableSPN.Visible = 'on';
                        app.UIAxesWaveform.Legend.Visible = 'on';
                    end
                    
                    % % %                     % =================================================== %
                    % % %                     % A little workaround to allow toggle of listbox, rather
                    % % %                     % than requiring control click.
                    % % %                     % =================================================== %
                    % % %
                    % % %                     Value = event.Value;
                    % % %                     ValuePrevious = event.PreviousValue;
                    % % %
                    % % %                     Value2 = Value;
                    % % %                     ValuePrevious2 = ValuePrevious;
                    % % %
                    % % %                     if any(ismember(ValuePrevious,Value))
                    % % %                         ValuePrevious2(ismember(ValuePrevious,Value)) = [];
                    % % %                         Value2(ismember(Value,ValuePrevious)) = [];
                    % % %                     end
                    % % %
                    % % %                     ValueNew = sort([Value2 ValuePrevious2]);
                    % % %
                    % % %                     if isempty(ValueNew); ValueNew = []; end
                    % % %
                    % % %                     event.Source.Value = ValueNew;
                    
                    ExtractPlotData(app);
                    
                else
                    
                    % =================================================== %
                    % To allow memory of previously selected conditions when
                    % configuring data, we will update a variable inside of
                    % the APP.CURRENTPROJECT structure. However, we only
                    % update this if we are not plotting the data.
                    % =================================================== %
                    
                    UniqueExperiments = unique({app.CURRENTPROJECT.Experiment});
                    for iExp = 1:length(UniqueExperiments)
                        Experiment_Index = find(strcmp({app.CURRENTPROJECT.Experiment},UniqueExperiments{iExp}));
                        ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(iExp) 'ListBox']).Value);
                        for iCond = Experiment_Index
                            app.CURRENTPROJECT(iCond).Configure_Selection = 0;
                        end
                        app.CURRENTPROJECT(ConditionIndex).Configure_Selection = 1;
                    end
                    
                end
                
                RefreshExperimentLists(app);
                ParametersStatusCheck(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Value changed function: Cluster1DropDown, 
        % Cluster2DropDown, Cluster3DropDown, Cluster4DropDown, 
        % Cluster5DropDown
        function ClusterDropDownValueChanged(app, event)
            
            % Initiated when the ELECTRODES DOGMA DROPDOWN is changed.
            
            try
                
                % ======================================================= %
                % Since we use the same callback for all EXPERIMENTS, we
                % need to figure out which one actually initiated the
                % callback. I've done this using the title of the
                % experiment as this is stored in the event.Source
                % variable.
                % ======================================================= %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                ExperimentTitle = event.Source.Parent.Title;
                Experiment_Index = find(strcmp(UniqueExperiments,ExperimentTitle));
                
                ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value);
                
                % ======================================================= %
                % Depending on the value that was selected for the
                % ELECTRODE DOGMA DROPDOWN, we extract the corresponding
                % electrodes.
                % ======================================================= %
                
                value = app.(['Cluster' num2str(Experiment_Index) 'DropDown']).Value;
                
                if strcmp(value, 'Original')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = app.CURRENTPROJECT(ConditionIndex).Electrodes_Original;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option = 'Original';
                elseif strcmp(value, 'Cluster 1')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = app.CURRENTPROJECT(ConditionIndex).Electrodes_Cluster_1;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option = 'Cluster 1';
                elseif strcmp(value, 'Cluster 2')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = app.CURRENTPROJECT(ConditionIndex).Electrodes_Cluster_2;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option = 'Cluster 2';
                elseif strcmp(value, 'Cluster 3')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = app.CURRENTPROJECT(ConditionIndex).Electrodes_Cluster_3;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option = 'Cluster 3';
                elseif strcmp(value, 'Custom')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = app.CURRENTPROJECT(ConditionIndex).Electrodes_Custom;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes_Option = 'Custom';
                end
                
                app.(['Electrodes' num2str(Experiment_Index) 'ListBox']).Value = app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes;
                
                RefreshExperimentLists(app);
                ParametersStatusCheck(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Value changed function: Time1DropDown, Time2DropDown, 
        % Time3DropDown, Time4DropDown, Time5DropDown
        function TimeDropDownValueChanged(app, event)
            
            % Initiated when the time option is changed for any EXPERIMENT.
            
            try
                
                % ======================================================= %
                % Since we use the same callback for all EXPERIMENTS, we
                % need to figure out which one actually initiated the
                % callback. I've done this using the title of the
                % experiment as this is stored in the event.Source
                % variable.
                % ======================================================= %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                ExperimentTitle = event.Source.Parent.Title;
                Experiment_Index = find(strcmp(UniqueExperiments,ExperimentTitle));
                
                ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value);
                
                % ======================================================= %
                % Depending on the value that was selected for the TIME
                % DROPDOWN, we extract the corresponding times.
                % ======================================================= %
                
                value = app.(['Time' num2str(Experiment_Index) 'DropDown']).Value;
                
                if strcmp(value, 'Original')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time = app.CURRENTPROJECT(ConditionIndex).Window_Original;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time_Option = 'Original';
                elseif strcmp(value, 'Dogma')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time = app.CURRENTPROJECT(ConditionIndex).Window_Cluster;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time_Option = 'Dogma';
                elseif strcmp(value, 'Custom')
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time = app.CURRENTPROJECT(ConditionIndex).Window_Custom;
                    app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time_Option = 'Custom';
                end
                
                app.(['Start' num2str(Experiment_Index) 'EditField']).Value = str2double(app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time{1});
                app.(['End' num2str(Experiment_Index) 'EditField']).Value = str2double(app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time{2});
                
                RefreshExperimentLists(app);
                ParametersStatusCheck(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Value changed function: Electrodes1ListBox, 
        % Electrodes2ListBox, Electrodes3ListBox, 
        % Electrodes4ListBox, Electrodes5ListBox
        function ElectrodesListBoxValueChanged(app, event)
            
            try
                
                % =========================================================== %
                % Since we use the same callback for all EXPERIMENTS, we
                % need to figure out which one actually initiated the
                % callback. I've done this using the title of the
                % experiment as this is stored in the event.Source
                % variable.
                % =========================================================== %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                ExperimentTitle = event.Source.Parent.Title;
                Experiment_Index = find(strcmp(UniqueExperiments,ExperimentTitle));
                
                value = app.(['Electrodes' num2str(Experiment_Index) 'ListBox']).Value;
                
                ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value);
                
                % =========================================================== %
                % We can now assign the selected electrodes to the appropriate
                % variables.
                % =========================================================== %
                
                app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Electrodes = value;
                app.CURRENTPROJECT(ConditionIndex).Electrodes_Custom = value;
                
                RefreshExperimentLists(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
        end

        % Value changed function: Start1EditField, Start2EditField, 
        % Start3EditField, Start4EditField, Start5EditField
        function StartEditFieldValueChanged(app, event)
            
            try
                
                % =========================================================== %
                % Since we use the same callback for all EXPERIMENTS, we
                % need to figure out which one actually initiated the
                % callback. I've done this using the title of the
                % experiment as this is stored in the event.Source
                % variable.
                % =========================================================== %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                ExperimentTitle = event.Source.Parent.Title;
                Experiment_Index = find(strcmp(UniqueExperiments,ExperimentTitle));
                
                value = app.(['Start' num2str(Experiment_Index) 'EditField']).Value;
                
                ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value);
                
                % =========================================================== %
                % We can now assign the selected electrodes to the appropriate
                % variables.
                % =========================================================== %
                
                app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time{1} = num2str(value);
                app.CURRENTPROJECT(ConditionIndex).Window_Custom{1} = num2str(value);
                
                RefreshExperimentLists(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
        end

        % Value changed function: End1EditField, End2EditField, 
        % End3EditField, End4EditField, End5EditField
        function EndEditFieldValueChanged(app, event)
            
            try
                
                % =========================================================== %
                % Since we use the same callback for all EXPERIMENTS, we
                % need to figure out which one actually initiated the
                % callback. I've done this using the title of the
                % experiment as this is stored in the event.Source
                % variable.
                % =========================================================== %
                
                UniqueExperiments = unique({app.CURRENTPROJECT.Full_Name});
                
                ExperimentTitle = event.Source.Parent.Title;
                Experiment_Index = find(strcmp(UniqueExperiments,ExperimentTitle));
                
                value = app.(['End' num2str(Experiment_Index) 'EditField']).Value;
                
                ConditionIndex = find([app.CURRENTPROJECT.SPNID] == app.(['Experiment' num2str(Experiment_Index) 'ListBox']).Value);
                
                % =========================================================== %
                % We can now assign the selected electrodes to the appropriate
                % variables.
                % =========================================================== %
                
                app.CURRENTPROJECT(ConditionIndex).Cluster_Options_Time{2} = num2str(value);
                app.CURRENTPROJECT(ConditionIndex).Window_Custom{2} = num2str(value);
                
                RefreshExperimentLists(app);
                
            catch ME
                ThrowError(app,ME);
            end
            
        end

        % Value changed function: PlotButton
        function PlotButtonValueChanged(app, event)
            
            % If PLOTBUTTON is selected, this callback is referenced.
            
            try
                
                PlottingEnabled = app.PlotButton.Value;
                
                ParametersStatusCheck(app);
                
                if PlottingEnabled
                    
                    % =================================================== %
                    % If the PLOTBUTTON is enabled, we want to select
                    % conditions in the EXPERIMENT LISTBOX. We also extract
                    % the plot data and ultimately plot it.
                    % =================================================== %
                    
                    SelectConditions(app,[]);
                    ExtractPlotData(app);
                    
                    % =================================================== %
                    % We enable the PLOT IRREGULAR and DIFFERENCE WAVE
                    % buttons when plotting.
                    
                    app.PlotIrregularButton.Enable = 1;
                    app.DifferenceWaveButton.Enable = 1;
                    
                else
                    
                    % =================================================== %
                    % Refresh the parameters in the experiments panel.
                    % =================================================== %
                    
                    SelectConditions(app,[]);
                    RefreshExperimentLists(app);
                    
                    % =================================================== %
                    % We disable the PLOT IRREGULAR and DIFFERENCE WAVE
                    % buttons when not plotting.
                    % =================================================== %
                    
                    app.PlotIrregularButton.Enable = 0;
                    app.DifferenceWaveButton.Enable = 0;
                    
                end
                
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Value changed function: DifferenceWaveButton
        function DifferenceWaveButtonValueChanged(app, event)
            
            % If the DIFFERENCE WAVE BUTTON is pressed, the data is
            % extracted again and plotted.
            
            try
                ExtractPlotData(app);
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Value changed function: PlotIrregularButton
        function PlotIrregularButtonValueChanged(app, event)
            
            % If the PLOT IRREGULAR button is pressed, the data is
            % extracted again and plotted.
            
            try
                ExtractPlotData(app);
            catch ME
                ThrowError(app,ME);
            end
            
            UpdateDiary(app);
            
        end

        % Button pushed function: ExportButton
        function ExportButtonValueChanged(app, event)
            
            % Disable Plot Options button while dialog is open
            
            app.ExportButton.Enable = 'off';
            
            % Open the options dialog and pass inputs
            
            File_Name = mfilename;
            if isdeployed() || strcmp(File_Name,'SPNCAT')
                app.ExportApp = SPNCAT_Export(app);
            else
                app.ExportApp = SPNCAT_Export_func(app);
            end
            
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app.ExportApp);
            delete(app);
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {831, 831};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {443, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 783 831];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);
            app.UIFigure.Scrollable = 'on';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {443, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create ProjectsListBox
            app.ProjectsListBox = uilistbox(app.LeftPanel);
            app.ProjectsListBox.Items = {};
            app.ProjectsListBox.ValueChangedFcn = createCallbackFcn(app, @ProjectsListBoxValueChanged, true);
            app.ProjectsListBox.Position = [21 20 80 790];
            app.ProjectsListBox.Value = {};

            % Create Experiment1Panel
            app.Experiment1Panel = uipanel(app.LeftPanel);
            app.Experiment1Panel.Title = 'Experiment 1';
            app.Experiment1Panel.Position = [111 660 320 150];

            % Create Experiment1ListBox
            app.Experiment1ListBox = uilistbox(app.Experiment1Panel);
            app.Experiment1ListBox.Items = {};
            app.Experiment1ListBox.ValueChangedFcn = createCallbackFcn(app, @ExperimentListBoxValueChanged, true);
            app.Experiment1ListBox.Position = [11 10 80 110];
            app.Experiment1ListBox.Value = {};

            % Create ClusterDropDownLabel
            app.ClusterDropDownLabel = uilabel(app.Experiment1Panel);
            app.ClusterDropDownLabel.HorizontalAlignment = 'right';
            app.ClusterDropDownLabel.Position = [161 98 40 22];
            app.ClusterDropDownLabel.Text = 'Cluster';

            % Create Cluster1DropDown
            app.Cluster1DropDown = uidropdown(app.Experiment1Panel);
            app.Cluster1DropDown.Items = {'Original', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Custom'};
            app.Cluster1DropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.Cluster1DropDown.Position = [211 100 100 20];
            app.Cluster1DropDown.Value = 'Original';

            % Create TimeDropDownLabel
            app.TimeDropDownLabel = uilabel(app.Experiment1Panel);
            app.TimeDropDownLabel.HorizontalAlignment = 'right';
            app.TimeDropDownLabel.Position = [161 68 40 22];
            app.TimeDropDownLabel.Text = 'Time';

            % Create Time1DropDown
            app.Time1DropDown = uidropdown(app.Experiment1Panel);
            app.Time1DropDown.Items = {'Original', 'Dogma', 'Custom'};
            app.Time1DropDown.ValueChangedFcn = createCallbackFcn(app, @TimeDropDownValueChanged, true);
            app.Time1DropDown.Position = [211 70 100 20];
            app.Time1DropDown.Value = 'Original';

            % Create StartEditFieldLabel
            app.StartEditFieldLabel = uilabel(app.Experiment1Panel);
            app.StartEditFieldLabel.HorizontalAlignment = 'right';
            app.StartEditFieldLabel.Position = [161 39 40 22];
            app.StartEditFieldLabel.Text = 'Start';

            % Create Start1EditField
            app.Start1EditField = uieditfield(app.Experiment1Panel, 'numeric');
            app.Start1EditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.Start1EditField.Position = [211 39 100 22];

            % Create EndEditFieldLabel
            app.EndEditFieldLabel = uilabel(app.Experiment1Panel);
            app.EndEditFieldLabel.HorizontalAlignment = 'right';
            app.EndEditFieldLabel.Position = [161 8 40 22];
            app.EndEditFieldLabel.Text = 'End';

            % Create End1EditField
            app.End1EditField = uieditfield(app.Experiment1Panel, 'numeric');
            app.End1EditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.End1EditField.Position = [211 8 100 22];

            % Create Electrodes1ListBox
            app.Electrodes1ListBox = uilistbox(app.Experiment1Panel);
            app.Electrodes1ListBox.Items = {};
            app.Electrodes1ListBox.Multiselect = 'on';
            app.Electrodes1ListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.Electrodes1ListBox.Position = [101 10 50 110];
            app.Electrodes1ListBox.Value = {};

            % Create Experiment2Panel
            app.Experiment2Panel = uipanel(app.LeftPanel);
            app.Experiment2Panel.Title = 'Experiment 2';
            app.Experiment2Panel.Position = [111 500 320 150];

            % Create Experiment2ListBox
            app.Experiment2ListBox = uilistbox(app.Experiment2Panel);
            app.Experiment2ListBox.Items = {};
            app.Experiment2ListBox.ValueChangedFcn = createCallbackFcn(app, @ExperimentListBoxValueChanged, true);
            app.Experiment2ListBox.Position = [11 10 80 110];
            app.Experiment2ListBox.Value = {};

            % Create Electrodes2ListBox
            app.Electrodes2ListBox = uilistbox(app.Experiment2Panel);
            app.Electrodes2ListBox.Items = {};
            app.Electrodes2ListBox.Multiselect = 'on';
            app.Electrodes2ListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.Electrodes2ListBox.Position = [101 10 50 110];
            app.Electrodes2ListBox.Value = {};

            % Create ClusterDropDownLabel_2
            app.ClusterDropDownLabel_2 = uilabel(app.Experiment2Panel);
            app.ClusterDropDownLabel_2.HorizontalAlignment = 'right';
            app.ClusterDropDownLabel_2.Position = [161 98 40 22];
            app.ClusterDropDownLabel_2.Text = 'Cluster';

            % Create Cluster2DropDown
            app.Cluster2DropDown = uidropdown(app.Experiment2Panel);
            app.Cluster2DropDown.Items = {'Original', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Custom'};
            app.Cluster2DropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.Cluster2DropDown.Position = [211 100 100 20];
            app.Cluster2DropDown.Value = 'Original';

            % Create TimeDropDownLabel_2
            app.TimeDropDownLabel_2 = uilabel(app.Experiment2Panel);
            app.TimeDropDownLabel_2.HorizontalAlignment = 'right';
            app.TimeDropDownLabel_2.Position = [161 68 40 22];
            app.TimeDropDownLabel_2.Text = 'Time';

            % Create Time2DropDown
            app.Time2DropDown = uidropdown(app.Experiment2Panel);
            app.Time2DropDown.Items = {'Original', 'Dogma', 'Custom'};
            app.Time2DropDown.ValueChangedFcn = createCallbackFcn(app, @TimeDropDownValueChanged, true);
            app.Time2DropDown.Position = [211 70 100 20];
            app.Time2DropDown.Value = 'Original';

            % Create StartEditFieldLabel_2
            app.StartEditFieldLabel_2 = uilabel(app.Experiment2Panel);
            app.StartEditFieldLabel_2.HorizontalAlignment = 'right';
            app.StartEditFieldLabel_2.Position = [161 39 40 22];
            app.StartEditFieldLabel_2.Text = 'Start';

            % Create Start2EditField
            app.Start2EditField = uieditfield(app.Experiment2Panel, 'numeric');
            app.Start2EditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.Start2EditField.Position = [211 39 100 22];

            % Create EndEditFieldLabel_2
            app.EndEditFieldLabel_2 = uilabel(app.Experiment2Panel);
            app.EndEditFieldLabel_2.HorizontalAlignment = 'right';
            app.EndEditFieldLabel_2.Position = [161 8 40 22];
            app.EndEditFieldLabel_2.Text = 'End';

            % Create End2EditField
            app.End2EditField = uieditfield(app.Experiment2Panel, 'numeric');
            app.End2EditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.End2EditField.Position = [211 8 100 22];

            % Create Experiment3Panel
            app.Experiment3Panel = uipanel(app.LeftPanel);
            app.Experiment3Panel.Title = 'Experiment 3';
            app.Experiment3Panel.Position = [111 340 320 150];

            % Create Experiment3ListBox
            app.Experiment3ListBox = uilistbox(app.Experiment3Panel);
            app.Experiment3ListBox.Items = {};
            app.Experiment3ListBox.ValueChangedFcn = createCallbackFcn(app, @ExperimentListBoxValueChanged, true);
            app.Experiment3ListBox.Position = [11 10 80 110];
            app.Experiment3ListBox.Value = {};

            % Create Electrodes3ListBox
            app.Electrodes3ListBox = uilistbox(app.Experiment3Panel);
            app.Electrodes3ListBox.Items = {};
            app.Electrodes3ListBox.Multiselect = 'on';
            app.Electrodes3ListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.Electrodes3ListBox.Position = [101 10 50 110];
            app.Electrodes3ListBox.Value = {};

            % Create ClusterDropDownLabel_3
            app.ClusterDropDownLabel_3 = uilabel(app.Experiment3Panel);
            app.ClusterDropDownLabel_3.HorizontalAlignment = 'right';
            app.ClusterDropDownLabel_3.Position = [161 98 40 22];
            app.ClusterDropDownLabel_3.Text = 'Cluster';

            % Create Cluster3DropDown
            app.Cluster3DropDown = uidropdown(app.Experiment3Panel);
            app.Cluster3DropDown.Items = {'Original', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Custom'};
            app.Cluster3DropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.Cluster3DropDown.Position = [211 100 100 20];
            app.Cluster3DropDown.Value = 'Original';

            % Create TimeDropDownLabel_3
            app.TimeDropDownLabel_3 = uilabel(app.Experiment3Panel);
            app.TimeDropDownLabel_3.HorizontalAlignment = 'right';
            app.TimeDropDownLabel_3.Position = [161 68 40 22];
            app.TimeDropDownLabel_3.Text = 'Time';

            % Create Time3DropDown
            app.Time3DropDown = uidropdown(app.Experiment3Panel);
            app.Time3DropDown.Items = {'Original', 'Dogma', 'Custom'};
            app.Time3DropDown.ValueChangedFcn = createCallbackFcn(app, @TimeDropDownValueChanged, true);
            app.Time3DropDown.Position = [211 70 100 20];
            app.Time3DropDown.Value = 'Original';

            % Create StartEditFieldLabel_3
            app.StartEditFieldLabel_3 = uilabel(app.Experiment3Panel);
            app.StartEditFieldLabel_3.HorizontalAlignment = 'right';
            app.StartEditFieldLabel_3.Position = [161 39 40 22];
            app.StartEditFieldLabel_3.Text = 'Start';

            % Create Start3EditField
            app.Start3EditField = uieditfield(app.Experiment3Panel, 'numeric');
            app.Start3EditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.Start3EditField.Position = [211 39 100 22];

            % Create EndEditFieldLabel_3
            app.EndEditFieldLabel_3 = uilabel(app.Experiment3Panel);
            app.EndEditFieldLabel_3.HorizontalAlignment = 'right';
            app.EndEditFieldLabel_3.Position = [161 8 40 22];
            app.EndEditFieldLabel_3.Text = 'End';

            % Create End3EditField
            app.End3EditField = uieditfield(app.Experiment3Panel, 'numeric');
            app.End3EditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.End3EditField.Position = [211 8 100 22];

            % Create Experiment4Panel
            app.Experiment4Panel = uipanel(app.LeftPanel);
            app.Experiment4Panel.Title = 'Experiment 4';
            app.Experiment4Panel.Position = [111 180 320 150];

            % Create Experiment4ListBox
            app.Experiment4ListBox = uilistbox(app.Experiment4Panel);
            app.Experiment4ListBox.Items = {};
            app.Experiment4ListBox.ValueChangedFcn = createCallbackFcn(app, @ExperimentListBoxValueChanged, true);
            app.Experiment4ListBox.Position = [11 10 80 110];
            app.Experiment4ListBox.Value = {};

            % Create Electrodes4ListBox
            app.Electrodes4ListBox = uilistbox(app.Experiment4Panel);
            app.Electrodes4ListBox.Items = {};
            app.Electrodes4ListBox.Multiselect = 'on';
            app.Electrodes4ListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.Electrodes4ListBox.Position = [101 10 50 110];
            app.Electrodes4ListBox.Value = {};

            % Create ClusterDropDownLabel_4
            app.ClusterDropDownLabel_4 = uilabel(app.Experiment4Panel);
            app.ClusterDropDownLabel_4.HorizontalAlignment = 'right';
            app.ClusterDropDownLabel_4.Position = [161 98 40 22];
            app.ClusterDropDownLabel_4.Text = 'Cluster';

            % Create Cluster4DropDown
            app.Cluster4DropDown = uidropdown(app.Experiment4Panel);
            app.Cluster4DropDown.Items = {'Original', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Custom'};
            app.Cluster4DropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.Cluster4DropDown.Position = [211 100 100 20];
            app.Cluster4DropDown.Value = 'Original';

            % Create TimeDropDownLabel_4
            app.TimeDropDownLabel_4 = uilabel(app.Experiment4Panel);
            app.TimeDropDownLabel_4.HorizontalAlignment = 'right';
            app.TimeDropDownLabel_4.Position = [161 68 40 22];
            app.TimeDropDownLabel_4.Text = 'Time';

            % Create Time4DropDown
            app.Time4DropDown = uidropdown(app.Experiment4Panel);
            app.Time4DropDown.Items = {'Original', 'Dogma', 'Custom'};
            app.Time4DropDown.ValueChangedFcn = createCallbackFcn(app, @TimeDropDownValueChanged, true);
            app.Time4DropDown.Position = [211 70 100 20];
            app.Time4DropDown.Value = 'Original';

            % Create StartEditFieldLabel_4
            app.StartEditFieldLabel_4 = uilabel(app.Experiment4Panel);
            app.StartEditFieldLabel_4.HorizontalAlignment = 'right';
            app.StartEditFieldLabel_4.Position = [161 39 40 22];
            app.StartEditFieldLabel_4.Text = 'Start';

            % Create Start4EditField
            app.Start4EditField = uieditfield(app.Experiment4Panel, 'numeric');
            app.Start4EditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.Start4EditField.Position = [211 39 100 22];

            % Create EndEditFieldLabel_4
            app.EndEditFieldLabel_4 = uilabel(app.Experiment4Panel);
            app.EndEditFieldLabel_4.HorizontalAlignment = 'right';
            app.EndEditFieldLabel_4.Position = [161 8 40 22];
            app.EndEditFieldLabel_4.Text = 'End';

            % Create End4EditField
            app.End4EditField = uieditfield(app.Experiment4Panel, 'numeric');
            app.End4EditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.End4EditField.Position = [211 8 100 22];

            % Create Experiment5Panel
            app.Experiment5Panel = uipanel(app.LeftPanel);
            app.Experiment5Panel.Title = 'Experiment 5';
            app.Experiment5Panel.Position = [111 21 320 150];

            % Create Experiment5ListBox
            app.Experiment5ListBox = uilistbox(app.Experiment5Panel);
            app.Experiment5ListBox.Items = {};
            app.Experiment5ListBox.ValueChangedFcn = createCallbackFcn(app, @ExperimentListBoxValueChanged, true);
            app.Experiment5ListBox.Position = [11 9 80 110];
            app.Experiment5ListBox.Value = {};

            % Create Electrodes5ListBox
            app.Electrodes5ListBox = uilistbox(app.Experiment5Panel);
            app.Electrodes5ListBox.Items = {};
            app.Electrodes5ListBox.Multiselect = 'on';
            app.Electrodes5ListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.Electrodes5ListBox.Position = [101 9 50 110];
            app.Electrodes5ListBox.Value = {};

            % Create ClusterDropDownLabel_5
            app.ClusterDropDownLabel_5 = uilabel(app.Experiment5Panel);
            app.ClusterDropDownLabel_5.HorizontalAlignment = 'right';
            app.ClusterDropDownLabel_5.Position = [161 97 40 22];
            app.ClusterDropDownLabel_5.Text = 'Cluster';

            % Create Cluster5DropDown
            app.Cluster5DropDown = uidropdown(app.Experiment5Panel);
            app.Cluster5DropDown.Items = {'Original', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Custom'};
            app.Cluster5DropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.Cluster5DropDown.Position = [211 99 100 20];
            app.Cluster5DropDown.Value = 'Original';

            % Create TimeDropDownLabel_5
            app.TimeDropDownLabel_5 = uilabel(app.Experiment5Panel);
            app.TimeDropDownLabel_5.HorizontalAlignment = 'right';
            app.TimeDropDownLabel_5.Position = [161 67 40 22];
            app.TimeDropDownLabel_5.Text = 'Time';

            % Create Time5DropDown
            app.Time5DropDown = uidropdown(app.Experiment5Panel);
            app.Time5DropDown.Items = {'Original', 'Dogma', 'Custom'};
            app.Time5DropDown.ValueChangedFcn = createCallbackFcn(app, @TimeDropDownValueChanged, true);
            app.Time5DropDown.Position = [211 69 100 20];
            app.Time5DropDown.Value = 'Original';

            % Create StartEditFieldLabel_5
            app.StartEditFieldLabel_5 = uilabel(app.Experiment5Panel);
            app.StartEditFieldLabel_5.HorizontalAlignment = 'right';
            app.StartEditFieldLabel_5.Position = [161 38 40 22];
            app.StartEditFieldLabel_5.Text = 'Start';

            % Create Start5EditField
            app.Start5EditField = uieditfield(app.Experiment5Panel, 'numeric');
            app.Start5EditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.Start5EditField.Position = [211 38 100 22];

            % Create EndEditFieldLabel_5
            app.EndEditFieldLabel_5 = uilabel(app.Experiment5Panel);
            app.EndEditFieldLabel_5.HorizontalAlignment = 'right';
            app.EndEditFieldLabel_5.Position = [161 7 40 22];
            app.EndEditFieldLabel_5.Text = 'End';

            % Create End5EditField
            app.End5EditField = uieditfield(app.Experiment5Panel, 'numeric');
            app.End5EditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.End5EditField.Position = [211 7 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create PlotButton
            app.PlotButton = uibutton(app.RightPanel, 'state');
            app.PlotButton.ValueChangedFcn = createCallbackFcn(app, @PlotButtonValueChanged, true);
            app.PlotButton.Text = 'Plot';
            app.PlotButton.Position = [11 780 50 30];

            % Create DifferenceWaveButton
            app.DifferenceWaveButton = uibutton(app.RightPanel, 'state');
            app.DifferenceWaveButton.ValueChangedFcn = createCallbackFcn(app, @DifferenceWaveButtonValueChanged, true);
            app.DifferenceWaveButton.Text = 'Difference Wave';
            app.DifferenceWaveButton.Position = [69 780 104 30];

            % Create PlotIrregularButton
            app.PlotIrregularButton = uibutton(app.RightPanel, 'state');
            app.PlotIrregularButton.ValueChangedFcn = createCallbackFcn(app, @PlotIrregularButtonValueChanged, true);
            app.PlotIrregularButton.Text = 'Plot Irregular';
            app.PlotIrregularButton.Position = [180 780 84 30];

            % Create UITableSPN
            app.UITableSPN = uitable(app.RightPanel);
            app.UITableSPN.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITableSPN.RowName = {};
            app.UITableSPN.FontSize = 10;
            app.UITableSPN.Position = [11 110 302 200];

            % Create DiaryOutput
            app.DiaryOutput = uitextarea(app.RightPanel);
            app.DiaryOutput.Position = [11 20 300 70];

            % Create ExportButton
            app.ExportButton = uibutton(app.RightPanel, 'push');
            app.ExportButton.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonValueChanged, true);
            app.ExportButton.Position = [271 779 50 30];
            app.ExportButton.Text = 'Export';

            % Create UIAxesWaveform
            app.UIAxesWaveform = uiaxes(app.RightPanel);
            title(app.UIAxesWaveform, 'Title')
            xlabel(app.UIAxesWaveform, 'X')
            ylabel(app.UIAxesWaveform, 'Y')
            zlabel(app.UIAxesWaveform, 'Z')
            app.UIAxesWaveform.PlotBoxAspectRatio = [1.75483870967742 1 1];
            app.UIAxesWaveform.FontSize = 10;
            app.UIAxesWaveform.Position = [11 550 310 200];

            % Create UIAxesBar
            app.UIAxesBar = uiaxes(app.RightPanel);
            title(app.UIAxesBar, 'Title')
            xlabel(app.UIAxesBar, 'X')
            ylabel(app.UIAxesBar, 'Y')
            zlabel(app.UIAxesBar, 'Z')
            app.UIAxesBar.PlotBoxAspectRatio = [1.75483870967742 1 1];
            app.UIAxesBar.FontSize = 10;
            app.UIAxesBar.Position = [11 330 310 200];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SPNCAT_func(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end