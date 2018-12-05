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
        
        function XLSXSave(obj, columnNames, absValues, relValues, totalFrames, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % Identifying the amount of rows that need to be in the Excel
            % file.
            largestNumberOfFrames = length(absValues{1}.XValues);
            for i=2:length(absValues)
                if(length(absValues{i}.XValues) > largestNumberOfFrames)
                    largestNumberOfFrames = length(absValues{i}.XValues);
                end
            end
            
            outputMatrixAbs(:,1) = linspace(1,totalFrames,totalFrames);
            
            % Arranging the matrices for writing to the Excel file
%             outputMatrixAbs(:,1) = linspace(1,largestNumberOfFrames,largestNumberOfFrames);
            
            % Inputting the absolute values:
            for i=1:length(absValues)
                currentColumnArray=(zeros((totalFrames),1));
                for j=1:length(absValues{i}.XValues)
                    currentColumnArray(absValues{i}.XValues(j),1)=absValues{i}.CollectionValues(j);
                end
                outputMatrixAbs(:,i+1) = currentColumnArray';
            end
            
            % Inputting the relative values:
            for i=1:length(absValues)
                currentColumnArray=(zeros((totalFrames),1));
                currentRelColumn = relValues{i};
                for j=1:length(absValues{i}.XValues)
                    currentColumnArray(absValues{i}.XValues(j),1)=currentRelColumn(j);
                end
                outputMatrixRel(:,i) = currentColumnArray';
            end
            
            outputCell = [outputMatrixAbs, outputMatrixRel];
            outputCell = num2cell(outputCell);
            
            columnNames = [{'Frame no.'} columnNames columnNames];
            
            outputCell = [columnNames; outputCell];
            
            obj.fileAccessor.XLSXSave(path, outputCell);
        end
        
        function MATSave(obj, dicomDisplay, RoiController, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            outputStruct{1} = dicomDisplay;
            outputStruct{2} = RoiController;
            
            obj.fileAccessor.MATSave(path,outputStruct);
        end
        
        function [dicomDisplay, RoiController, dicomFile, numberOfFrames, numberOfSlices] = MATRead(obj, path)
            %MATRead sets up the data received from FileAccessor
            %   Returns the necessary variables to the GUI, to restore the
            %   state in which it was saved by the user.
            
            inputCell = obj.fileAccessor.MATRead(path);
            
            dicomDisplay = inputCell.outputStruct{1};
            RoiController = inputCell.outputStruct{2};
            dicomFile = dicomDisplay.dicom_files{1}.DTO{1};
            dicomFile = dicomDisplay.NormalizeFrame(dicomFile);
            
            numberOfFrames = length(dicomDisplay.dicom_files{1}.DTO);
            numberOfSlices = length(dicomDisplay.dicom_files);
            
            dicomFile.dicomInfo = dicomDisplay.CreateTable(dicomFile.dicomInfo);
        end        
    end
end

