%test_get_minimal_covering_subsets_for.m
%Description:
%	Tests the funciton get_minimal_covering_subsets_for.m.

function tests = test_get_minimal_covering_subsets_for
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_input_handling(testCase)
	%Description:
	%	Checks that the function correctly identifies when two inputs are given which are of different types.

	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];
	q1 = PolyUnion(Polyhedron('lb',-0.5,'ub',0.5));

	%% Algorithm
	try
		Q_prime = get_minimal_covering_subsets_for( q1 , Cover1 );
		assert(false) %The algorithm shouldn't have reached here yet.
	catch e
		disp(e.message)
		assert(strcmp(e.message,'Set class is "PolyUnion" while the cover class is "Polyhedron".'))
	end

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

function test1_polyunion_input(testCase)
	%Description:
	%	Checks that the function correctly identifies when the two arrays are arrays of PolyUnions.

	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover1 = [ PolyUnion(Polyhedron('lb',-2,'ub',-1)) , PolyUnion(Polyhedron('lb',-1,'ub',1)) , PolyUnion(Polyhedron('lb',1,'ub',2)) ];
	q1 = PolyUnion(Polyhedron('lb',-0.5,'ub',0.5));

	expected_output = PolyUnion(Polyhedron('lb',-1,'ub',1));

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for( q1 , Cover1 );

	assert( (length(Q_prime) == 1) && ...
			PolyUnion_subseteq(Q_prime , expected_output) && PolyUnion_subseteq( expected_output , Q_prime ) )

end

function test2_polyunion_input(testCase)
	%Description:
	%	Tests the function with a slightly overlapping set of 
	%	covering sets.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover2 = [ 	PolyUnion(Polyhedron('lb',-2,'ub',-1)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',1)) , ...
				PolyUnion(Polyhedron('lb',1,'ub',2)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',2)) ];

	q2 = PolyUnion(Polyhedron('lb',-0.5,'ub',0.5));

	expected_output = PolyUnion(Polyhedron('lb',-1,'ub',1));

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for(q2,Cover2);

	assert( (length(Q_prime) == 1) && ...
			(Q_prime <= expected_output) && (expected_output <= Q_prime) )

end

function test3_polyunion_input(testCase)
	%Description:
	%	Tests the function with a slightly overlapping set of 
	%	covering sets and unions with multiple sets inside.

	%% Include Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	Cover3 = [ 	PolyUnion(Polyhedron('lb',-2,'ub',-1)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',1)) , ...
				PolyUnion(Polyhedron('lb',1,'ub',2)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',2)) , ...
				PolyUnion([Polyhedron('lb',-1.25,'ub',-0.25),Polyhedron('lb',-0.25,'ub',1.75)]) ];

	q3 = PolyUnion(Polyhedron('lb',-0.5,'ub',0.5));

	expected_output = PolyUnion(Polyhedron('lb',-1,'ub',1));

	%% Algorithm
	Q_prime = get_minimal_covering_subsets_for(q3,Cover3);

	assert( (length(Q_prime) == 1) && ...
			(Q_prime <= expected_output) && (expected_output <= Q_prime) )

end