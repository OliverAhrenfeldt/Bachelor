classdef DataAccessor
    %DataAccessor This class handles the communication with a database in
    %order to load in DICOM files.
    %   The class contains two functions that reads DICOM pixeldata and
    %   metadata respectively. 

    methods
        function outputFrame = Dicomread(obj,path)
            %Dicomread This function reads the pixeldata from a DICOM-file
            %   It is provided with a path, and called in a loop to
            %   continuously return pixeldata of dicomfiles in a folder
            outputFrame = dicomread(fullfile(path{1}.folder, path{1}.name));
        end
        
        function outputDicomInfo = Dicominfo(obj,path)
            %Dicominfo This function reads the metadata from a DICOM-file
            %   It is provided with a path, and called in a loop to
            %   continuously return metadata of dicomfiles in a folder
            outputDicomInfo = dicominfo(fullfile(path{1}.folder, path{1}.name));
        end
    end
end