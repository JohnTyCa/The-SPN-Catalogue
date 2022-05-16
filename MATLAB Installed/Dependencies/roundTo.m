% ======================================================================= %
%
% Created by John Tyson-Carr
%
% First Created 24/01/2019
%
% Current version = v1.0
%
% Round to the nearest defined amount. For example, round to nearest 0.25.
% Also has the ability to round up or down with optional argument input.
%
% ======================================================================= %
% Required Inputs:
% ======================================================================= %
%
% val       -   Value to round.
% increment -   Increment to round to.
%
% ======================================================================= %
% Optional Inputs:
% ======================================================================= %
%
% Direction     -   'up'        >   Round up to increment.
%                   'down'      >   Round down to increment.
%                   'nearest'   >   Round to nearest increment.
%
% ======================================================================= %
% Outputs:
% ======================================================================= %
%
% newVal    -   Rounded value.
%
% ======================================================================= %
% Example
% ======================================================================= %
%
% newVal = roundTo(3.85,0.25,'Direction','down');
%
% ======================================================================= %
% Dependencies.
% ======================================================================= %
%
% ======================================================================= %
% UPDATE HISTORY:
%
% 24/01/2019 (v1.0) -   V1.0 Created.
% 27/04/2020 (v1.1) -   Now handles incremembts > 1.
% 
% ======================================================================= %

function newVal = roundTo(val,increment,varargin)

varInput = [];
for iVar = 1:2:length(varargin)
    varInput = setfield(varInput, varargin{iVar}, varargin{iVar+1});
end
if ~isfield(varInput, 'Direction'), varInput.Direction = 'nearest'; end

if increment <= 1
    
    if strcmp(varInput.Direction,'nearest')
        
        upper = floor(val) + ceil( (val-floor(val))/increment) * increment;
        lower = floor(val) + floor( (val-floor(val))/increment) * increment;
        
        upperDiff = abs(upper - val);
        lowerDiff = abs(lower - val);
        
        if upperDiff > lowerDiff
            newVal = lower;
        elseif upperDiff < lowerDiff
            newVal = upper;
        elseif upperDiff == lowerDiff
            newVal = upper;
        end
        
    elseif strcmp(varInput.Direction,'up')
        newVal = floor(val) + ceil( (val-floor(val))/increment) * increment;
    elseif strcmp(varInput.Direction,'down')
        newVal = floor(val) + floor( (val-floor(val))/increment) * increment;
    end
    
else
    
    if strcmp(varInput.Direction,'nearest')
        newVal = round(val/increment)*increment;
    elseif strcmp(varInput.Direction,'up')
        newVal = ceil(val/increment)*increment;
    elseif strcmp(varInput.Direction,'down')
        newVal = floor(val/increment)*increment;
    end
    
end


end