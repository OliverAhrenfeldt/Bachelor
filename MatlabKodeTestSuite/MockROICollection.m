classdef MockROICollection
    %STUBREADER Summary of this class goes here
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
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
%             Opretter tomme pladser i strukturen
            
            for i=1: totalSliceNumber
                for j=1: totalFrameNumber
                    obj.ROIs{i}.Frames{j}.ROI{1} = [];
                    obj.ROIs{i}.Frames{j}.Position{1} = [];
                end
            end
            
            
%              Opretter polygon objekt
%             points = [500 500;400 600;400 700;500 800;600 800;700 700; 700 600];
%             poly = images.roi.Polygon
%             poly.Position = points;
%             obj.ROIs{slicenumber}.Frames{framenumber}.Position
%             Sætter objektets properties
            obj.ROIs{slicenumber}.Frames{framenumber}.ROI{1} = polygon;
            obj.ROIs{slicenumber}.Frames{framenumber}.Position{1} = polygon.Position;
            
            obj.Name = name;
            obj.Color = color;
            obj.Autotracking = 0;
            obj.D3ROI = 0;
            obj.AnalysisStatus = 1;            
        end

    end
end

