%test_hscc_output.m
%Description:
%	Tests the function hscc_output.

function tests = test_hscc_output
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_behavior(testCase)
	%Description:
	%	PRovides a state in the region that defines the first region of the hscc
	%	example's partition.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();


	%% Constants

	expected_output = 1;
	x = 0.5*ones(2,1);

	%% Algoritm
	assert( expected_output == hscc_output(x) )

end

function test2_behavior(testCase)
	%Description:
	%	Provides a state that is not contained in ANY region.


	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();


	%% Constants

	expected_output = 1;
	x = -0.5*ones(2,1);

	%% Algoritm
	assert( isempty(hscc_output(x)) )

end