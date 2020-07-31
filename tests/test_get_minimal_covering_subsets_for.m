%test_get_minimal_covering_subsets_for.m
%Description:
%	Tests the funciton get_minimal_covering_subsets_for.m.

function tests = test_get_minimal_covering_subsets_for
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_behavior(testCase)
	%Description:
	%	Tests the function with the sets used in the one-dimensional example.


	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];
	q1 = Polyhedron('lb',-0.5,'ub',0.5);

	expected_output = Polyhedron('lb',-1,'ub',1);

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for( q1 , Cover1 );

	assert( (length(Q_prime) == 1) && ...
			(Q_prime <= expected_output) && (expected_output <= Q_prime) )


end

function test2_behavior(testCase)
	%Description:
	%	Tests the function with a slightly overlapping set of 
	%	covering sets.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover2 = [ 	Polyhedron('lb',-2,'ub',-1) , ...
				Polyhedron('lb',-1,'ub',1) , ...
				Polyhedron('lb',1,'ub',2) , ...
				Polyhedron('lb',-1,'ub',2) ];

	q2 = Polyhedron('lb',-0.5,'ub',0.5);

	expected_output = Polyhedron('lb',-1,'ub',1);

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for(q2,Cover2);

	assert( (length(Q_prime) == 1) && ...
			(Q_prime <= expected_output) && (expected_output <= Q_prime) )

end

function test3_behavior(testCase)
	%Description:
	%	Tests the function with more overlapping set of 
	%	covering sets.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover3 = [ 	Polyhedron('lb',-2,'ub',-1) , ...
				Polyhedron('lb',-1,'ub',1) , ...
				Polyhedron('lb',1,'ub',2) , ...
				Polyhedron('lb',-1,'ub',2) , ...
				Polyhedron('lb',-0.5,'ub',1.5) ];

	q3 = Polyhedron('lb',-0.5,'ub',0.5);

	expected_output = [Polyhedron('lb',-1,'ub',1),Polyhedron('lb',-0.5,'ub',1.5)];

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for(q3,Cover3);
	%disp(length(Q_prime))

	assert( (length(Q_prime) == 2) && ...
			(Q_prime(1) <= expected_output(1)) && (expected_output(1) <= Q_prime(1)) && ...
			(Q_prime(2) <= expected_output(2)) && (expected_output(2) <= Q_prime(2)) )

end