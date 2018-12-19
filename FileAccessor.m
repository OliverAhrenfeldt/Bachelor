classdef FileAccessor
    %FileAccessor This class handles the communication with a database in
    %order to save and load user data
    %   It holds functionality to save the BOLD analysis as a Microsoft
    %   Excel file (.xlsx), save the users work as a .Mat file, and load
    %   the users work afterwards.
    methods
        
        function XLSXSave(obj, path, outputCell)
            %XLSXSave This function is used to save the BOLD values in an
            %Excel file
            %   The function receives a path and the cell to save. The
            %   function displays a message box when the file has been
            %   saved, allowing the user to open it right away.
            xlswrite(path,outputCell);
            
            % Let the user know the Excel file has been saved, and ask if they
            % want to open it right away. 
            answer = questdlg({'File has been saved as a MAT file at:';path}, ...
                'Success', ...
                'OK','Open file','OK');
            % Handle user response
            switch answer
                case 'OK'
                    % Nothing happens here
                case 'Open file'
                    winopen(path)
            end
        end
        
        function MATSave(obj, path, outputStruct)
            %MATSave This function saves a .Mat file with the user data.
            %   It receives a path and an outputStruct containing the data.
            %   It displays a messagebox after saving is complete.
            save(path, 'outputStruct');
             msgbox({'File has been saved as a MAT file at:';path},'Success','help')
        end
        
        function inputCell = MATRead(obj, path)
            %MATRead This function loads a .Mat file with user data.
            %   The function returns an inputCell, which is a .Mat file. It
            %   receives a path to load from. The method will typically be
            %   used to load data saved with the MATSave function in this
            %   application.
            inputCell = load(path);
        end
        
        
    end
end

