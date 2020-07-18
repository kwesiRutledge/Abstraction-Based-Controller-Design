function [tf] = check_for_arcs()
    %Description:
    %   This function:
    %   (0) Checks to see if the arcs toolbox is currently on the path.
    %   (1) If not, it
    %       (1a) Searches through the MATLAB path for a directory called
    %       'arcs' (assumes that arcs is saved in the main directory)
    %       (1b) Adds the path to arcs and all the items it contains.
    
    %% Constants %%
    
    search_levels = 5;
    
    %% Try to Instantiate a TransSyst object
    if exist('TransSyst') == 2
        tf = true;
        return
    else
        warning('arcs is not currently on the MATLAB Path.')
    end
    
    %% Search For the MATLAB Directory
    if strcmp(getenv('USER'),'kwesirutledge')
        addpath(genpath('/Users/kwesirutledge/Documents/MATLAB/Research/arcs/'))
    end
    
    %% Check again for arcs and return a final answer
    if exist('TransSyst') == 2
        tf = true;
    else
        tf = false;
    end