classdef Autotrack
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = untitled(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function newROI = TrackImage(obj,image,OldROI, threshold)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            %I1 = dicomread('C:\Users\Mads_\OneDrive - Aarhus universitet\Bachelor\DICOM\BOLD Datasæt\198\CD-rom\A\Z894');
            
            ROI.Position = OldROI;
            %Tror vi skal fjerne normaliseringen og finde et threshold
            %baseret på std i det forrige roi, og så gøre det hele på det
            %ikke normaliserede billede.
            I1norm = double(image)/max(double(image(:)));
%             figure(1); imshow(I1norm); ROI= drawpolygon;
            newROI = zeros(size(ROI.Position));
            %Vi finder centerlinjen gennem ROI'et, for at bestemme hvilken
            %retning ud fra hvert punkt der er hhv. mod midten af ROIet og
            %væk fra ROI'et. Løsningen til at finde denne centerlinje er
            %fundet med inspiration fra Samuels slides fra BDP:
            mask = poly2mask(ROI.Position(:,1),ROI.Position(:,2),size(image,1),size(image,2));
            skeleton = bwmorph(mask,'skel',Inf);
            centerline = bwmorph(skeleton,'spur',10);
            [xCenterlineIdx, yCenterlineIdx] = find(centerline==1);
            
            for i=1:size(ROI.Position,1)      
                %% SETUP
                % To find the angle bisector of every point in the ROI, the
                % point of interest and the two adjacent points are
                % identified:
                if(i==1)
                    punkt1 = [ROI.Position(size(ROI.Position,1),1),ROI.Position(size(ROI.Position,1),2)];
                    punkt2 = [ROI.Position(1,1),ROI.Position(1,2)];
                    punkt3 = [ROI.Position(2,1),ROI.Position(2,2)];
                    
                elseif(i==size(ROI.Position,1))
                    punkt1 = [ROI.Position(i-1,1),ROI.Position(i-1,2)];
                    punkt2 = [ROI.Position(i,1),ROI.Position(i,2)];
                    punkt3 = [ROI.Position(1,1),ROI.Position(1,2)];
                else
                    punkt1 = [ROI.Position(i-1,1),ROI.Position(i-1,2)];
                    punkt2 = [ROI.Position(i,1),ROI.Position(i,2)];
                    punkt3 = [ROI.Position(i+1,1),ROI.Position(i+1,2)];
                end
                
                x1 = punkt1(1);
                y1 = punkt1(2);
                
                x2 = punkt2(1);
                y2 = punkt2(2);

                x3 = punkt3(1);
                y3 = punkt3(2);

                a_1 = (y2 - y1)/(x2-x1);
                b_1 = y1 - a_1*x1;

                a_2 = (y3 - y2)/(x3-x2);
                b_2 = y2 - a_2*x2;
                
                %% Scenarios:
                % The point of interest can be either to the left, right or
                % in center of the two adjacent points.
                left = false; right = false; center = false;
                
                if (x2-x1<0 && x2-x3<0)
                    left = true;
                elseif (x2-x1>0 && x2-x3>0)
                    right = true;
                else
                    center = true;
                end
                
                % Source for method of angle calculation: https://www.studieportalen.dk/forums/Thread.aspx?id=568435&fbclid=IwAR0SbmeZVewMB-OOZwPCNLfHm6lJV52ulpYHTkH8oGZE4zvcFVukI5s0miM
                
                % All of the possible positions of the three points:
                % Scenario 1:
                if (a_1<0 && a_2<0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC1andSC2(a_1, a_2, x2, y2);
                % Scenario 2:
                elseif (a_1<0 && a_2<0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC1andSC2(a_1, a_2, x2, y2);
                % Scenario 3:
                elseif (a_1<0 && a_2<0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC3(a_1, a_2, x2, y2);
                % Scenario 4:
                elseif (a_1<0 && a_2>0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC4andSC5(a_1, a_2, x2, y2);
                % Scenario 5:
                elseif (a_1<0 && a_2>0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC4andSC5(a_1, a_2, x2, y2);
                % Scenario 6:
                elseif (a_1<0 && a_2>0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC6(a_1, a_2, x2, y2);
                % Scenario 7:
                elseif (a_1>0 && a_2>0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC7(a_1, a_2, x2, y2);
                % Scenario 8:
                elseif (a_1>0 && a_2>0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC8(a_1, a_2, x2, y2);
                % Scenario 9:
                elseif (a_1>0 && a_2>0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC9(a_1, a_2, x2, y2);
                % Scenario 10:
                elseif (a_1>0 && a_2<0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC10andSC11(a_1, a_2, x2, y2);
                % Scenario 11:
                elseif (a_1>0 && a_2<0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC10andSC11(a_1, a_2, x2, y2);
                % Scenario 12:
                elseif (a_1>0 && a_2<0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC12(a_1, a_2, x2, y2);
                end
                
                %% Creation of line segment
                % To find a line segment, a circle is drawn. The cirlce 
                % center is the point of interest. The intersection between 
                % the circle and the angle bisector defines the line 
                % segment.
                
                %drawcircle('Center', [x2,y2], 'Radius', 5);

                
                % NOTICE: the 'linecirc' function requires 'Mapping
                % Toolbox'
                [xinter, yinter] = linecirc(avinkelhalv, bvinkelhalv, x2, y2, 5);
%                 drawpoint('Position',[xinter(1),yinter(1)], 'Color', 'r');
%                 drawpoint('Position',[xinter(2),yinter(2)], 'Color', 'r');
                [lineSegPixelCoords, lineSegPixelIndex] = obj.lineSeg(xinter, yinter, I1norm);                
                %% 
                [xNew, yNew] = obj.Edgedetection(xCenterlineIdx, yCenterlineIdx, lineSegPixelCoords, lineSegPixelIndex,threshold, [x2,y2]);
%                 drawpoint('Position',[xNew,yNew], 'Color', 'r');                 
               newROI(i,1)=xNew;
               newROI(i,2)=yNew;             
            end
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC1andSC2(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = 180-b_x-a_x_inner;
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-a_x_inner;
            vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC3(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = (360-2*(180-b_x-a_x_inner))/2;
            if (C > 180)
                C = 360-C;
            end
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC4andSC5(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(180-a_x-b_x);
            halvC = C/2;
            
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x, b_x]));
            
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
                
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC6(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(a_x+b_x);

            halvC = C/2;

            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            if (a_x<b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC7(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = abs(180-b_x-a_x_inner);
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x,b_x]));
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC8(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = abs(180-b_x-a_x_inner);
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x,b_x]));
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC9(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = (360-2*(180-b_x-a_x_inner))/2;
            if (C > 180)
                C = 360-C;
            end
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]));
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC10andSC11(obj, a_1, a_2, x2, y2)
            b_x = abs(atand(a_1));
            a_x = abs(atand(a_2));
            C = 180-(180-a_x-b_x);
            halvC = C/2;
            
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x, b_x]));
            
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC12(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(a_x+b_x);

            halvC = C/2;

            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [lineSegPixelCoords, lineSegPixelIndex] = lineSeg(obj, xinter, yinter, I1norm)
            x1=xinter(1); y1=yinter(1); x2=xinter(2); y2=yinter(2);
            
%             linePos = [x1,y1;x2,y2];
%             drawline('Position',linePos,'Color','g','LineWidth',1);

            % 20 points destributed evenly along the line segment. These
            % will identify which pixels we are looking at.
            n=26;
            xPoints = linspace(x1,x2,n);
            yPoints = linspace(y1,y2,n);
            
            lineSegPixelCoords = [xPoints;yPoints]';
            % The function 'round' is used to get an integer, representing the
            % coordinates of the pixels the line segment cuts through
            xPixels = round(xPoints);
            yPixels = round(yPoints);

            pixels = [xPixels;yPixels]';
            

            for i = 1:length(pixels(:,1))
                lineSegPixelIndex(i) = I1norm(pixels(i,2),pixels(i,1));
            end
%             figure(2);
%             imshow(I1norm);
%             drawline('Position',linePos,'Color','g','LineWidth',1);
        end
                
        function [xEdge, yEdge] = Edgedetection(obj, xCenterlineIdx, yCenterlineIdx, lineSegPixelCoords, longLineSegPixelIndex,threshold, oldPoint)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            lineSegPixelIndex = zeros(1,length(longLineSegPixelIndex)-6);
            counter = 1;
            for i = 4:length(longLineSegPixelIndex)-3
                lineSegPixelIndex(counter)=longLineSegPixelIndex(i);
                counter = counter+1;
            end
            
            centerLineDistances = zeros(size(xCenterlineIdx));
            for i=1:length(centerLineDistances)              
                dist = sqrt(((oldPoint(1)-xCenterlineIdx(i))^2)+((oldPoint(2)-yCenterlineIdx(i))^2));
                centerLineDistances(i)=dist;
            end
            
            [~, minCenterDistanceIdx] = min(centerLineDistances);
            xComparison = xCenterlineIdx(minCenterDistanceIdx);
            yComparison = yCenterlineIdx(minCenterDistanceIdx);
            
            filter = [-1 0 1];
            %Kilde til replicate. Vi bruger replicate, for at der ikke
            %identificeres en ikke-eksisterende kant i slutningen af
            %arrayet pga. zero padding.
            %https://se.mathworks.com/help/images/imfilter-boundary-padding-options.html
            edgeArray = abs(imfilter(lineSegPixelIndex, filter,'replicate'));
            binaryEdgeArray = zeros(size(edgeArray));
            for i=1:length(edgeArray)
                if(edgeArray(i)>threshold)
                    binaryEdgeArray(i)=1;
                end
            end
            
            idxEdges = find(binaryEdgeArray==1);
            if(length(idxEdges)>1)
                distArray = zeros(size(idxEdges));
                for i=1:length(idxEdges)
                    x = lineSegPixelCoords(idxEdges(i)+3,1);
                    y = lineSegPixelCoords(idxEdges(i)+3,2);
                    dist = sqrt(((oldPoint(1)-x)^2)+((oldPoint(2)-y)^2));
                    distArray(i) = dist;
                end
                [~,minIdx] = min(distArray);
                edgeIndex = idxEdges(minIdx);
                
                xPotential1 = lineSegPixelCoords(3+edgeIndex-3,1);
                yPotential1 = lineSegPixelCoords(3+edgeIndex-3,2);
                dist1 = sqrt(((xComparison-xPotential1)^2)+((yComparison-yPotential1)^2));
                
                xPotential2 = lineSegPixelCoords(3+edgeIndex+3,1);
                yPotential2 = lineSegPixelCoords(3+edgeIndex+3,2);
                dist2 = sqrt(((xComparison-xPotential2)^2)+((yComparison-yPotential2)^2));
                
                if(dist1<dist2)
                    xEdge = xPotential1;
                    yEdge = yPotential1;
                else
                    xEdge = xPotential2;
                    yEdge = yPotential2;
                end
                
            elseif(length(idxEdges)==1)
                
                xPotential1 = lineSegPixelCoords(3+idxEdges-3,1);
                yPotential1 = lineSegPixelCoords(3+idxEdges-3,2);
                dist1 = sqrt(((xComparison-xPotential1)^2)+((yComparison-yPotential1)^2));
                
                xPotential2 = lineSegPixelCoords(3+idxEdges+3,1);
                yPotential2 = lineSegPixelCoords(3+idxEdges+3,2);
                dist2 = sqrt(((xComparison-xPotential2)^2)+((yComparison-yPotential2)^2));
                
                if(dist1<dist2)
                    xEdge = xPotential1;
                    yEdge = yPotential1;
                else
                    xEdge = xPotential2;
                    yEdge = yPotential2;
                end
                
            else
                xEdge = oldPoint(1);
                yEdge = oldPoint(2);
            end
        end
    end
end

