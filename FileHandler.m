classdef FileHandler
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileAccessor;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.fileAccessor = FileAccessor;
        end
        
        function XLSXSave(obj, columnNames, boldValues, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % Identifying the amount of rows that need to be in the Excel
            % file.
            largestNumberOfFrames = length(boldValues{1}.XValues);
            for i=2:length(boldValues)
                if(length(boldValues{i}.XValues) > largestNumberOfFrames)
                    largestNumberOfFrames = length(boldValues{i}.XValues);
                end
            end
            
            % Arranging the matrix for writing to the Excel file
            outputMatrix(:,1) = linspace(1,largestNumberOfFrames,largestNumberOfFrames);
            
            for i=1:length(boldValues)
                currentColumnArray=(zeros((largestNumberOfFrames),1));
                for j=1:length(boldValues{i}.XValues)
                    currentColumnArray(boldValues{i}.XValues(j),1)=boldValues{i}.CollectionValues(j);
                end
                outputMatrix(:,i+1) = currentColumnArray';
            end
            
            outputCell = num2cell(outputMatrix);
            columnNames = [{'Frame no.'} columnNames];
            
            outputCell = [columnNames; outputCell];
            
            obj.fileAccessor.XLSXSave(path, outputCell);
        end
        
        function MATSave(obj, dicomDisplay, RoiController)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
        end
        
        function outputArg = MATRead(obj, dicomDisplay, RoiController)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
        end
        
    end
end

