classdef ROICollection < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ROIs;
        Name;
        Color;
        Autotracking;
        D3ROI;
        AnalysisStatus;
    end
    
    methods
        function obj = Constructor(obj,name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here           
            obj.createStructure(totalFrameNumber,totalSliceNumber);
            obj.ROIs{slicenumber}.Frames{framenumber}.ROI{1} = polygon;
            obj.ROIs{slicenumber}.Frames{framenumber}.Position{1} = polygon.Position;
            obj.Name = name;
            obj.Color = color;
            obj.Autotracking = 0;
            obj.D3ROI = 0;
            obj.AnalysisStatus = 1;
        end
        
        function createStructure(obj,totalFrameNumber, totalSliceNumber)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for i=1: totalSliceNumber
                for j=1: totalFrameNumber
                    obj.ROIs{i}.Frames{j}.ROI{1} = [];
                    obj.ROIs{i}.Frames{j}.Position{1} = [];
                end
            end
        end
    end
end

