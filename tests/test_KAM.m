%test_KAM.m
%Description:
%	Tests the KAM function of the class SystemTuple.

function tests = test_KAM
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function st1 = get_simple_SystemTuple1()
	%Description:
	%	Returns a very simple SystemTuple object.

	tf = check_for_gurobi();

	%% Constants

	X = Polyhedron('lb',-2,'ub',2);
	X0 = X;

	%num_U = 2; %There are only two inputs allowed
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,0.5,0,X*Polyhedron('lb',0,'ub',0)) ];

	
	HInverse = [Polyhedron('lb',-2,'ub',0), ...
				Polyhedron('lb',0,'ub',2) ];

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';

	%% Algorithm

	st1 = SystemTuple(X,X0,HInverse,'LinearDynamics',DynList);

end

function test1_oneIteration(testCase)
	%Description:
	%	Checking what happens after one iteration of the KAM algorithm.
	%	Hoping that Cover is updated.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();
	tf = check_for_gurobi();

	%% Constants

	st1 = get_simple_SystemTuple1();

	%% Algorithm

	shat1 = st1.KAM('MaximumIterations',1,'Debug',false);

	% disp(length(shat1.X))

	% for x_idx = 1:length(shat1.X)
	% 	figure;
	% 	plot(shat1.X(x_idx))
	% end

	assert( (length(shat1.X) == (2+6)) && ... 	%There should be two states coming form the original HInverse, plus 3 more coming from the
			...									%refine steps of three different types.
			(length(shat1.X0) == length(st1.HInverse) ) && ...
			(length(shat1.x0) == 6) )

end

function test1_twoIteration(testCase)
	%Description:
	%	Checking what happens after one iteration of the KAM algorithm.
	%	Hoping that Cover is updated.

	error('Kwesi. You should understand this test more before finalizing it.')

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();
	tf = check_for_gurobi();

	%% Constants

	st1 = get_simple_SystemTuple1();

	%% Algorithm

	shat1 = st1.KAM('MaximumIterations',2,'Debug',true);

	disp(length(shat1.X))

	for x_idx = 1:length(shat1.X)
		figure;
		plot(shat1.X(x_idx))
	end

	assert( (length(shat1.X) == (2+6)) && ... 	%There should be two states coming form the original HInverse, plus 3 more coming from the
			...									%refine steps of three different types.
			(length(shat1.X0) == length(st1.HInverse) ) && ...
			(length(shat1.x0) == 6) )

end