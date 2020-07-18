function tests = test_toolbox_checks
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function ts_out = get_simple_ts()
	%Description:

	%% Create a very simple LCSTS
	n_s = 5;
	n_a = 2; %2 actions: Go and Stay
	Trans_Syst_Array = [];

	%Create Transition System 1
	ts1 = TransSyst(n_s,2);
	ts1.add_transition(1,2,1);
	ts1.add_transition(2,3,1);
	ts1.add_transition(3,4,1);
	ts1.add_transition(4,5,1);
	ts1.add_transition(5,1,1);

	for state_num = 1:n_s
		ts1.add_transition(state_num,state_num,2);
    end
    
    ts_out = ts1;
end

function dyn_out = get_simple_dyn()
    %Description:
    
    %
    A = magic(2);
    B = [0;1];
    F = [11;7];
    XU = Polyhedron('lb',-[13,17,23], ...
                    'ub',[13,17,23]);
    
    dyn_out = Dyn(A, F, B, XU);
    
end
    
function test1_check(testCase)
	%Description:
	%	The observation function created via matrices.

	%% Constants %%

    addpath(genpath('../lib/'))
    
    tf = check_for_arcs();
	ts0 = get_simple_ts();

	%% Algorithm %%

    %This should be guaranteed to work on Kwesi's computer only.
    assert( (strcmp(getenv('USER'),'kwesirutledge') && tf ) || ( (~strcmp(getenv('USER'),'kwesirutledge')) && (~tf) ) )
end

function test2_check(testCase)
	%Description:
	%	The observation function created via matrices.

	%% Constants %%

    addpath(genpath('../lib/'))
    
    tf = check_for_pcis();
	d0 = get_simple_dyn();

	%% Algorithm %%

    assert( (strcmp(getenv('USER'),'kwesirutledge') && tf ) || ( (~strcmp(getenv('USER'),'kwesirutledge')) && (~tf) ) )
end