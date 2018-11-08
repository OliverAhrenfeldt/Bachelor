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
            obj.ROIs{totalSliceNumber}.Frames{totalFrameNumber}.ROI{1} = [];
            obj.ROIs{slicenumber}.Frames{framenumber}.ROI{1} = polygon;
            obj.Name = name;
            obj.Color = color;
            obj.Autotracking = 0;
            obj.D3ROI = 0;
            obj.AnalysisStatus = 0;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

