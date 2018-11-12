classdef ROIController < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ROICollections;
    end
    
    methods
        function obj = Constructor(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function AddNewCollection(obj,name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            RoiCollection = ROICollection;
            RoiCollection = RoiCollection.Constructor(name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon);
            obj.ROICollections{length(obj.ROICollections)+1} = RoiCollection;
        end
        
        function AddROI(obj, idx, framenumber, slicenumber, polygon) 
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)+1} = polygon;
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position)+1} = polygon.Position;
        end
        
        function Names = getNames(obj)
            for i =1:length(obj.ROICollections)
                if (isempty(obj.ROICollections{i}) ~= 1)
                    Names{i} = obj.ROICollections{i}.Name; 
                end
            end
        end
        
        function AnalysisStatus = getAnalysisStatus(obj)
            for i =1:length(obj.ROICollections)
                if (isempty(obj.ROICollections{i}) ~= 1)
                    AnalysisStatus{i} = obj.ROICollections{i}.AnalysisStatus; 
                end
            end
        end
        
        function ROITable = getROITable(obj)
            
            if (isempty(obj.ROICollections) == 0)
                cola = obj.getNames()';
                AnalysisStatus = obj.getAnalysisStatus()';
                for i=1: length(AnalysisStatus)
                    if(AnalysisStatus{i}==0)
                        colb{i} = false;
                    else
                        colb{i} = true;
                    end
                end
                ROITable = table(cola,colb'); 
            else
                ROITable = {};
            end
        end
        
        function DeleteROI(obj, idx, framenumber, slicenumber)
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)
                delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
            end
        end
        
        function DeleteROICollection(obj, idx, framenumber, slicenumber)
            
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)
                delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
            end
            
            obj.ROICollections{idx} = [];
            for i=idx+1:length(obj.ROICollections)
                if (isempty(obj.ROICollections{i}) == 0)
                    obj.ROICollections{i-1} = obj.ROICollections{i};
                end
            end
            
            obj.ROICollections(length(obj.ROICollections)) = [];
        end
        
    end
end

