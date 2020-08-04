function [tf] = check_for_gurobi()
    %Description:
    %   This function:
    %   (0) Checks to see if gurobi is currently on the path.
    %   (1) If not, it returns false.

    %% Constants %%
    
    search_levels = 5;
    
    %% Try to Instantiate a TransSyst object
    if exist('gurobi.m') == 2
        tf = true;
        return
    else
        warning('gurobi is not currently on the MATLAB Path.')
    end
    
    %% Search For the MATLAB Directory
    if strcmp(getenv('USER'),'kwesirutledge')
        addpath(genpath('/Library/gurobi811/mac64/matlab/'))
    end
    
    %% Check again for arcs and return a final answer
    if exist('gurobi.m') == 2
        tf = true;
    else
        tf = false;
    end