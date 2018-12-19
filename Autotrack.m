classdef Autotrack
    %Autotrack Holds the autotracking algorithm
    %   This class is used for tracking an anatomical structure. The class
    %   can be used by calling the TrackImage function in a loop. For more
    %   information, see the description for the TrackImage function in
    %   this class. To understand the approach, please refer to the
    %   autotracking document provided with this bachelor project.
    
    
    methods
        function newROI = TrackImage(obj,image,OldROI, threshold)
            %TrackImage This function is used for tracking the movement of
            %an anatomical structure
            %   This function returns the positions of the vertices of the
            %   new ROI. The function receives the following: 
            %   The raw (not normalized) image with the structure to track.
            %   The ROI in the previous image that will be used as a basis.
            %   This ROI should be in the form of a 2-column matrix.
            %   The threshold, which is the pixel value difference that
            %   defines when an edge is detected.
            %   The user should call this method in a loop, to continuously
            %   provide all images in a single slice.
            
            ROI.Position = OldROI;
            newROI = zeros(size(ROI.Position));
            
            % The skeleton of the ROI is determined. This will allow the
            % algorith to move the ROI slightly towards the center, when an
            % edge is found.
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

                % The terms of the line equations
                a_1 = (y2 - y1)/(x2-x1);
                b_1 = y1 - a_1*x1;

                a_2 = (y3 - y2)/(x3-x2);
                b_2 = y2 - a_2*x2;
                
                a_3 = (y3 - y1)/(x3-x1);
                b_3 = y1 - a_3*x1;
                
                % Used if no centerline is found in the ROI during
                % skeletonization.
                hypotenuse = obj.lineSeg([x1,x3], [y1,y3], image);


                
                % Taking horizontal and vertical slopes into account, and
                % making slight adjustments when they are found. This is
                % necessary in order to perform the trigonomic calculations
                % in the scenarios below.
                if(a_1==0)
                    a_1 = 0.01;
                end
                
                if(a_2 == 0)
                    a_2 = 0.01;
                end
                
                if(isinf(a_1) && isinf(a_2))
                    a_1 = 60;
                    a_2 = -60;
                    x2 = x2+0.1;
                
                elseif(isinf(a_1))
                    a_1 = 60;
                    if(x3<x2)
                        x2 = x2 + 0.1;
                    else
                        x2 = x2 - 0.1;
                    end
                
                elseif(isinf(a_2))
                    a_2 = -60;
                    if(x1<x2)
                        x2 = x2 + 0.1;
                    else
                        x2 = x2 - 0.1;
                    end
                end
                
                
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
                
                % NOTICE: the 'linecirc' function requires 'Mapping
                % Toolbox'
                [xinter, yinter] = linecirc(avinkelhalv, bvinkelhalv, x2, y2, 2.5);
                [lineSegPixelCoords, lineSegPixelIndex] = obj.lineSeg(xinter, yinter, image);
                
                if(isempty(xCenterlineIdx))
                   [xNew, yNew] = obj.Edgedetection(hypotenuse(:,1), hypotenuse(:,2), lineSegPixelCoords, lineSegPixelIndex,threshold, [x2,y2]);             
                   newROI(i,1)=xNew;
                   newROI(i,2)=yNew;
                else
                   [xNew, yNew] = obj.Edgedetection(xCenterlineIdx, yCenterlineIdx, lineSegPixelCoords, lineSegPixelIndex,threshold, [x2,y2]);           
                   newROI(i,1)=xNew;
                   newROI(i,2)=yNew;
                end
            end
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC1andSC2(obj, a_1, a_2, x2, y2)
            %SC1andSC2 Two of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC3 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC4andSC5 Two of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC6 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC7 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC8 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC9 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC10andSC11 Two of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
            %SC12 One of the scenarios used for trigonomic calculations
            %   This function returns the slope (avinkelhalv) and y-axis
            %   intersection (bvinkelhalv) of the angle bisector. It
            %   receives the slope (a_1 and a_2) of the lines made up of point of
            %   interest of the two adjacent points. x2 and y2 is the
            %   coordinates for the point of interest
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
        
        function [lineSegPixelCoords, lineSegPixelIndex] = lineSeg(obj, xinter, yinter, image)
            %lineSeg This function is used to find the line segment
            %   The line segment is used to identify which pixels that
            %   shall be evaluated when looking for an edge. The function
            %   returns an array with the coordinates of the line segment,
            %   which is by default a 2x26 column matrix. As the second
            %   return value, a matrix with the pixel indices is
            %   returned. It receives xinter and yinter as 1x2 vectors
            %   containing the coordinates of the two points that defines
            %   the line segment. The last parameter is the image.
            x1=xinter(1); y1=yinter(1); x2=xinter(2); y2=yinter(2);
            
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
                lineSegPixelIndex(i) = image(pixels(i,2),pixels(i,1));
            end
        end
                
        function [xEdge, yEdge] = Edgedetection(obj, xCenterlineIdx, yCenterlineIdx, lineSegPixelCoords, longLineSegPixelIndex,threshold, oldPoint)
            %Edgedetection Determines when an edge is found. It handles one
            %ROI vertex at a time.
            %   This method returns the x and y value of the point, which
            %   is determined to be an edge, thus the point which the the
            %   old ROI vertex should be moved to. It receives:
            %   xCenterlineIdx as the x-coordinates of the ROI skeleton and
            %   yCenterlineIdx as the y-coordinates of the ROI skelenton.
            %   lineSegPixelCoords as the coordinates of the line segment
            %   on which an edge is being searched for.
            %   longLineSegPixelIndex as the coordinates of an extended
            %   line segment, to allow for moving the vertex towards the
            %   center of the ROI, even if an edge is found as one of the
            %   end-coordinates of the line segment used for finding
            %   edges. The threshold is the value that determines when an
            %   edge is an edge. The oldPoint is the vertex that should be
            %   moved.
            
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
            % source for replicate. Replicate is used to prevent
            % identification of a non-existing edge at the end of the
            % array.
            %https://se.mathworks.com/help/images/imfilter-boundary-padding-options.html
            edgeArray = abs(imfilter(lineSegPixelIndex, filter,'replicate'));
            
            binaryEdgeArray = zeros(size(edgeArray));
            for i=1:length(edgeArray)
                if(edgeArray(i)>threshold)
                    binaryEdgeArray(i)=1;
                end
            end
            
            idxEdges = find(binaryEdgeArray==1);            
            if(length(idxEdges)>0)
                xmin = 120;
                index = [];
                idx = idxEdges +3;
                edgePixels = lineSegPixelCoords(idx,:);
                
                for(i=1: size(edgePixels,1))
                    if(sqrt(((edgePixels(i,1)-oldPoint(1))^2)+((edgePixels(i,2)-oldPoint(2))^2))<xmin)
                        xmin = sqrt(((edgePixels(i,1)-oldPoint(1))^2)+((edgePixels(i,2)-oldPoint(2))^2));
                        index = idx(i);
                    end
                end

                if(sqrt(((lineSegPixelCoords(1,1)-xComparison)^2)+((lineSegPixelCoords(1,2)-yComparison)^2))<sqrt(((lineSegPixelCoords(length(lineSegPixelCoords),1)-xComparison)^2)+((lineSegPixelCoords(length(lineSegPixelCoords),2)-yComparison)^2)))
                      xEdge = lineSegPixelCoords(index-3,1);
                      yEdge = lineSegPixelCoords(index-3,2);
                else
                      xEdge = lineSegPixelCoords(index+3,1);
                      yEdge = lineSegPixelCoords(index+3,2);
                end
            else
                xEdge = oldPoint(1);
                yEdge = oldPoint(2);
            end
        end
    end
end

