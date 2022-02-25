% ======================================================================= %
%
% Created by John Tyson-Carr
%
% First Created 01/02/2018
%
% Current version = v1.1
%
% Converts a number to a character array of letters with leading zeros to
% equalise character length. For example, can convert the number 90 to a
% character array of "0090", or 127 to "0127". Does not work with negative
% numbers.
%
% ======================================================================= %
% Required Inputs:
% ======================================================================= %
%
% iteration         -   Number to convert.
% lengthOfString    -   Length of string to produce. Can also be an array
%                       of 1xN / Nx1.
%
% ======================================================================= %
% Outputs:
% ======================================================================= %
%
% string    -   String of lengthOfString length.
%
% ======================================================================= %
% Example
% ======================================================================= %
%
% string = nDigitString(127,5);
%
% ======================================================================= %
% Dependencies.
% ======================================================================= %
%
% ======================================================================= %
% UPDATE HISTORY:
%
% 01/02/2018 (v1.0) -   V1.0 Created.
% 13/02/2019 (v1.1) -   V1.1 Created. Implemented ability to analyse whole
%                       array of numbers.
%
% ======================================================================= %

function charArray = nDigitString(iteration,lengthOfString)

for iVal = 1:length(iteration)
    
    newChar = zeros(1,lengthOfString);
    valueString = num2str(iteration(iVal));
    
    if size(valueString,2) > lengthOfString
        disp(' ')
        disp('Error in nDigitString')
        disp('Desired Length of String < Iteration Size')
        disp(['Desired Length = ' num2str(lengthOfString)])
        disp(['Current Length = ' num2str(size(valueString,2))])
        disp(' ')
        return
    end
    
    counter1 = lengthOfString;
    for iCharacter = size(valueString,2):-1:1
        newChar(1,counter1) = str2num(valueString(1,iCharacter));
        counter1=counter1-1;
    end
    
    charArray(iVal,:) = sprintf('%d',newChar);
    
end

end