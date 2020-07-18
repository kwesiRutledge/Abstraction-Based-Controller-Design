function [tf] = check_for_pcis()
    %Description:
    %   This function:
    %   (0) Checks to see if the PCIS toolbox is currently on the path.
    %   (1) If not, it
    %       (1a) Searches through the MATLAB path for a directory called
    %       'arcs' (assumes that arcs is saved in the main directory)
    %       (1b) Adds the path to arcs and all the items it contains.
    
    %% Constants %%
    
    search_levels = 5;
    
    %% Try to Instantiate a TransSyst object
    if exist('Dyn') == 2
        tf = true;
        return
    else
        warning('pcis is not currently on the MATLAB Path.')
    end
    
    %% Search For the MATLAB Directory
    if strcmp(getenv('USER'),'kwesirutledge')
        addpath(genpath('/Users/kwesirutledge/Documents/MATLAB/Research/pcis/'))
        addpath(genpath('/Users/kwesirutledge/Documents/MATLAB/toolboxes/tbxmanager/'))
    end
    
    %% Check again for arcs and return a final answer
    if exist('Dyn') == 2
        tf = true;
    else
        tf = false;
    end