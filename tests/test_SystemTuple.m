%test_SystemTuple.m
%Description:
%	Tests the system object SystemTuple.

function tests = test_SystemTuple
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_constructor(testCase)
	%Description:
	%	Builds the simple system that Necmiye gave me.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-2,'ub',2);
	X0 = X;

	num_U = 2; %There are only two inputs allowed
	F = @one_dim_example_transition;

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	s1 = SystemTuple(X,X0,num_U,F,num_Y,H);

	assert(	(s1.X == X) && ...
			(s1.X0 == X0) && ...
			(s1.numU == num_U) && ...
			(s1.numY == num_Y) )

end

function test2_constructor(testCase)
	%Description:
	%	Builds the simple system that Necmiye gave me.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-2,'ub',2);
	X0 = X;

	num_U = 2; %There are only two inputs allowed
	F = @one_dim_example_transition;

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	s2 = SystemTuple(X,X0,num_U,F,num_Y,H,'YLabels',Y_labels);

	assert(	(s2.X == X) && ...
			(s2.X0 == X0) && ...
			(s2.numU == num_U) && ...
			(s2.numY == num_Y) && ...
			(s2.YLabels{1} == Y_labels{1}) && ...
			(s2.YLabels{2} == Y_labels{2}) && ...
			(s2.YLabels{3} == Y_labels{3}) )

end

function test3_constructor(testCase)
	%Description:
	%	Testing one condition where the systemtuple constructor should generate an error.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-2,'ub',2);
	X0 = Polyhedron('lb',-3,'ub',3);

	num_U = 2; %There are only two inputs allowed
	F = @one_dim_example_transition;

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	try
		s3 = SystemTuple(X,X0,num_U,F,num_Y,H,'YLabels',Y_labels);
		assert(false)
	catch e
		disp(e.message)
		assert(strcmp(e.message,'Initial state set X0 is not a subset of X!'))
	end

end