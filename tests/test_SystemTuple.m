%test_SystemTuple.m
%Description:
%	Tests the system object SystemTuple.

function tests = test_SystemTuple
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function st1 = get_simple_SystemTuple1()
	%Description:
	%	Returns a very simple SystemTuple object.

	%% Constants

	X = Polyhedron('lb',-2,'ub',2);
	X0 = X;

	%num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	st1 = SystemTuple(X,X0,DynList,num_Y,H);

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

	num_U = 2; %There are only two inputs allowed. Illustrated by DynList.
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	s1 = SystemTuple(X,X0,DynList,num_Y,H);

	assert(	(s1.X == X) && ...
			(s1.X0 == X0) && ...
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
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];


	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	s2 = SystemTuple(X,X0,DynList,num_Y,H,'YLabels',Y_labels);

	assert(	(s2.X == X) && ...
			(s2.X0 == X0) && ...
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
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	%% Algorithm

	try
		s3 = SystemTuple(X,X0,DynList,num_Y,H,'YLabels',Y_labels);
		assert(false)
	catch e
		%disp(e.message)
		assert(strcmp(e.message,'Initial state set X0 is not a subset of X!'))
	end

end

function test1_nu(testCase)
	%Description:
	%	Tests the method nu() so that it returns the right value (2) on the 
	%	SystemTuple provided in get_simple_SystemTuple1().

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	st1 = get_simple_SystemTuple1();

	%% Algorithm

	assert(st1.nu() == 2)

end

function test1_pre(testCase)
	%Description:
	%	Tests the pre() method for the system, but with a modified systemtuple.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-4,'ub',4);
	X0 = Polyhedron('lb',-2,'ub',2);

	num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st1 = SystemTuple(X,X0,DynList,num_Y,H);

	%% Algorithm

	Xpre = st1.pre(X0);

	assert( Xpre == Polyhedron('lb',-1,'ub',1) )

end

function test1_pre_input_dependent(testCase)
	%Description:
	%	Tests the pre_input_dependent() method for the system,
	%	but with a modified systemtuple.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-4,'ub',4);
	X0 = Polyhedron('lb',-2,'ub',2);

	num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st1 = SystemTuple(X,X0,DynList,num_Y,H);

	X_list = { X0 + 1 , X0 - 1 };

	%% Algorithm

	Xpre = st1.pre_input_dependent(X_list);

	assert( Xpre == X0 )

end

function test2_pre_input_dependent(testCase)
	%Description:
	%	Tests the pre_input_dependent() method for the system,
	%	but with a modified systemtuple. Should return the same
	%	result as the normal pre when the same set is copied 
	%	in the input to pre_input_dependent.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-4,'ub',4);
	X0 = Polyhedron('lb',-2,'ub',2);

	num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st1 = SystemTuple(X,X0,DynList,num_Y,H);

	X_list = [ X0 + 1 , X0 - 1 ];

	%% Algorithm

	Xpre = st1.pre_input_dependent({X0,X0});

	assert( Xpre == Polyhedron('lb',-1,'ub',1) )

end

function test3_pre_input_dependent(testCase)
	%Description:
	%	Tests the pre_input_dependent() method for the system.
	%	Verifies the error-catching behavior of the function.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	X = Polyhedron('lb',-4,'ub',4);
	X0 = Polyhedron('lb',-2,'ub',2);

	num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(-1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_Y = 3; %There are only three outputs.
	H = @one_dim_example_output;

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st1 = SystemTuple(X,X0,DynList,num_Y,H);

	X_list = [ X0 + 1 , X0 - 1 ];

	%% Algorithm

	try
		Xpre = st1.pre_input_dependent({X0,X0});
		assert(false) ; %an error should be thrown before the system reaches here
	catch e
		%disp(e.message)
		assert( ...
			strcmp(e.message, ...
				['The number of elements in X_list (' num2str(length([X0,X0])) ...
				') is not equal to the number of inputs to the system (' num2str(st1.nu()) ').']) ...
			)
	end

end

function test1_F(testCase)
	%Description:
	%	Tests the error handling of F() member function.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	st1 = get_simple_SystemTuple1();

	%% Algorithm

	try
		st1.F(1,3)
		assert(false); %The test case should not reach here. An error should be thrown above.
	catch e
		%disp(e.message)
		assert(strcmp(e.message,['The input u = 3 is outside of the allowable range {1,' num2str(st1.nu()) '}.']) )		
	end

end

function test2_F(testCase)
	%Description:
	%	Tests the correctness of output from F.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	st1 = get_simple_SystemTuple1();

	%% Algorithm

	assert( st1.F( st1.X0 , 1 ) == (st1.X0+1) )

end

