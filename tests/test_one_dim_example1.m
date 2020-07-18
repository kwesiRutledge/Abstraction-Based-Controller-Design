%test_one_dim_example1.m
%Description:
%	A test suite that verifies the properties of the 1-D system defined as an example for ABCD.

function tests = test_one_dim_example1
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_output(testCase)
	%Description:
	%	The output function for the simple one dim system is being checked
	%	for multiple inputs in the domain [-2,2]

	%% Constants %%

    addpath(genpath('../lib/'))
    
    tf = check_for_pcis();

    s1 = 1;
    s2 = -1;
    s3 = -1.5;
    s4 = 1.6;

	%% Algorithm %%
	assert( (one_dim_example_output(s1) == 2) && ...
			(one_dim_example_output(s2) == 2) && ...
			(one_dim_example_output(s3) == 1) && ...
			(one_dim_example_output(s4) == 3) )

    
end

function test2_output(testCase)
	%Description:
	%	The output function for the simple one dim system is being checked
	%	for an input outside of the domain [-2,2]

	%% Constants %%

    addpath(genpath('../lib/'))
    
    tf = check_for_pcis();

    s1 = 3;

	%% Algorithm %%
	try
		one_dim_example_output(s1)
		assert(false);
	catch e 
		%disp(e)
		%Verify that the correct error was thrown
		if strcmp(e.message,['The value of the state x must satisfy |x|<= 2. Received ' num2str(s1) '.'])
			assert(true)
		else
			assert(false);
		end
	end
    
end