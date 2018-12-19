classdef FileHandler
    %FileHandler This class handles the files to load and save.
    %   It holds a fileAccessor property used to access the database. The
    %   functions in this class "packages" the data before sending it to
    %   the fileAccessor, which handles the communication to the database.
    
    properties
        fileAccessor;
    end
    
    methods
        function obj = Constructor(obj)
            %Construct an instance of FileHandler
            obj.fileAccessor = FileAccessor;
        end
        
        function XLSXSave(obj, columnNames, absValues, relValues, totalFrames, path)
            %XLSXSave This function packages data into a cell array,
            %enabling it to be saved as an xlsx file by fileAccessor
            %   It receives the columnNames (which is the names of the ROI
            %   collections), the absolute and relative values, the total
            %   amount of frames in the scan, and a path in which to save
            %   the file.
            
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
            %MATSave This function packages data to be saved as a .Mat file
            %by fileAccessor
            %   It receives a dicomDisplay and RoiController object, which
            %   is all that is needed to restore the application to
            %   any state. It also receives the path.
            
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

