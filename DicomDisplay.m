classdef DicomDisplay < handle
    %DicomDisplay This class handles the communication to the reader class
    %and holds all the dicom DTO objects
    %   DicomDisplay has the responsibility of providing the user interface
    %   with the correct images.
    
    properties
        dicom_files;
        dicomLocalizers;
        reader;
    end
    
    methods
        function obj = Constructor(obj)
            %Construct an instance of this DicomDisplay
            obj.reader = Reader;
            obj.reader = obj.reader.Constructor();
        end
        
        function dicomFile = ChangeDICOM_file(obj,sliceCounter,frameCounter)
            %ChangeDICOM_file This function accesses the DICOM DTO
            %structure to fetch the correct image
            %   It returns a Dicom DTO object with the pixeldata and
            %   metadata. It receives the slice- and frame number.
            dicomFile = obj.dicom_files{sliceCounter}.DTO{frameCounter};
            dicomFile = obj.NormalizeFrame(dicomFile);
            
            % Converts the metadata to a table enable it to be displayed in
            % the user interface
            dicomFile.dicomInfo = obj.CreateTable(dicomFile.dicomInfo);
        end
        
        function [dicomFile, numberOfFrames, numberOfSlices] = ReadDicomFiles(obj, path)
            %ReadDicomFiles This method reads the DICOM files in the
            %provided folder path
            %   It returns a dicom DTO object, containing the first frame
            %   in the first slice, and the belonging metadata. It returns
            %   values of the total number of frames and slices. It
            %   receives a path to a folder containing DICOM files.
            pathsWithDotFolders = dir(fullfile(path));
            Counter = 1;            
            for i=3: length(pathsWithDotFolders) 
                paths{Counter} = pathsWithDotFolders(i); 
                Counter = Counter+1; 
            end
            [obj.dicom_files, obj.dicomLocalizers] = obj.reader.ReadDicomFiles(paths);
            dicomFile = obj.dicom_files{1}.DTO{1};
            dicomFile = obj.NormalizeFrame(dicomFile);

            % Converts the metadata to a table enable it to be displayed in
            % the user interface
            dicomFile.dicomInfo = obj.CreateTable(dicomFile.dicomInfo);
            
            numberOfFrames = length(obj.dicom_files{1}.DTO);
            numberOfSlices = length(obj.dicom_files);
        end
        
        function NormalizedDicom = NormalizeFrame(obj,DicomDTOFile)
            %NormalizeFrame This function returns a dicom DTO file, in
            %which the pixeldata is normalized.
            %   It receives a Dicom DTO object with non-normalized pixeldata.
            DicomDTOFile.pixelData= double(DicomDTOFile.pixelData);
            DicomDTOFile.pixelData = DicomDTOFile.pixelData/max(DicomDTOFile.pixelData(:));
            NormalizedDicom = DicomDTOFile;
        end
        
        function dicomTable = CreateTable(obj,dicomInfo)
            %CreateTable This function creates a table from the dicominfo.
            %   It receives the metadata and returns a table object.
            
            cola = fieldnames(dicomInfo);
            colb = struct2cell(dicomInfo);
            dicomTable = table(cola,colb); 
        end
    end
end

