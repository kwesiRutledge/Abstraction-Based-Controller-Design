%test_change_tuples_in_list.m
%Description:
%	Tests change_tuples_in_list for different types of lists.

function tests = test_change_tuples_in_list
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function [Cover1,ExpX1] = get_expx_list1()
	%Description:
	%	Creates a simple list of ExpXElement objects.

	%% Constants

	Cover1 = [ 	Polyhedron('lb',-2,'ub',-1) , ...
				Polyhedron('lb',-1,'ub',1) , ...
				Polyhedron('lb',1,'ub',2) ];

	expx1 = ExpXElement( 1 , Cover1(1) , Cover1(1) );
	expx2 = ExpXElement( 1 , Cover1(1) , Cover1(2) );
	expx3 = ExpXElement( 1 , Cover1(1) , Cover1(3) );
	expx4 = ExpXElement( 1 , Cover1(2) , Cover1(2) );

	ExpX1 = [ expx1 , expx2 , expx3 , expx4 ];
end

function [Cover1,ExpX1,ExpF1] = get_expf_list1()
	%Description:
	%	Creates a simple list of ExpFElements

	%% Constants

	[Cover1,ExpX1] = get_expx_list1();

	%Create expf elements with those
	expf1 = ExpFElement( ExpX1(1) , 1 , ExpX1(2) );
	expf2 = ExpFElement( ExpX1(2) , 1 , ExpX1(3) );
	expf3 = ExpFElement( ExpX1(3) , 1 , ExpX1(4) );
	expf4 = ExpFElement( ExpX1(4) , 1 , ExpX1(1) );
	expf5 = ExpFElement( ExpX1(1) , 2 , ExpX1(1) );

	%% Algorithm

	ExpF1 = [ expf1 , expf2 , expf3 , expf4 , expf5 ];

end

function [Cover1,ExpX1,ExpG1] = get_expg_list1()
	%Description:
	%	Creates a simple list of ExpFElements

	%% Constants

	[Cover1,ExpX1] = get_expx_list1();

	%% Algorithm

	ExpG1 = [];
	for expx_idx = 1:length(ExpX1)
		%Get ExpX element
		expx_elt = ExpX1(expx_idx);

		%Append to list
		ExpG1 = [ExpG1, ExpGammaElement( expx_elt )];
	end

end

function test1_expx_list(testCase)
	%Description:
	%	Applies the function to a simple ExpX list.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants 
	[~,ExpX1] = get_expx_list1();
	expx_target  = ExpXElement( 1 , ...
								Polyhedron('lb',-2,'ub',-1) , ...
								Polyhedron('lb',-2,'ub',-1) );

	s = Polyhedron('lb',-3,'ub',3);

	expx_expected_change = ExpXElement( 1 , s , ...
										Polyhedron('lb',-2,'ub',-1) );

	%% Algorithm
	ExpX1_prime = change_tuples_in_list( ExpX1 , expx_target , s );

	assert( (ExpX1_prime(1) == expx_expected_change) && ...
			(ExpX1_prime(2) == ExpX1(2)) && ...
			(ExpX1_prime(3) == ExpX1(3)) && ...
			(ExpX1_prime(4) == ExpX1(4)) )

end

function test2_expx_list(testCase)
	%Description:
	%	Applies the function to an ExpX list that does not contain the target.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants 
	[~,ExpX2] = get_expx_list1();
	expx_target  = ExpXElement( 2 , ...
								Polyhedron('lb',-2,'ub',-1) , ...
								Polyhedron('lb',-2,'ub',-1) );

	s = Polyhedron('lb',-3,'ub',3);

	expx_expected_change = ExpXElement( 1 , s , ...
										Polyhedron('lb',-2,'ub',-1) );

	%% Algorithm
	ExpX2_prime = change_tuples_in_list( ExpX2 , expx_target , s );

	assert( (ExpX2_prime(1) == ExpX2(1)) && ...
			(ExpX2_prime(2) == ExpX2(2)) && ...
			(ExpX2_prime(3) == ExpX2(3)) && ...
			(ExpX2_prime(4) == ExpX2(4)) )

end

function test1_expf_list(testCase)
	%Description:
	%	Applies the function to an ExpFElement list that does not contain the target.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants 
	[Cover1,ExpX1,ExpF1] = get_expf_list1();

	expx_target  = ExpXElement( 1 , ...
								Polyhedron('lb',-2,'ub',-1) , ...
								Polyhedron('lb',-2,'ub',-1) );

	s = Polyhedron('lb',-3,'ub',3);

	expx_expected_change = ExpXElement( 1 , s , ...
										Polyhedron('lb',-2,'ub',-1) );

	%% Algorithm
	ExpF1_prime = change_tuples_in_list( ExpF1 , expx_target , s );

	%The elements that we expect to change are:
	%	- ExpF1_prime(1).ExpXElt
	%	- ExpF1_prime(4).ExpXEltPrime
	%	- ExpF1_prime(5).ExpXElt
	%	- ExpF1_prime(5).ExpXEltPrime

	assert( (ExpF1_prime(1).ExpXElt == expx_expected_change) && ...
			(ExpF1_prime(1).ExpXEltPrime == ExpF1(1).ExpXEltPrime) && ...
			(ExpF1_prime(2).ExpXElt == ExpF1(2).ExpXElt) && ...
			(ExpF1_prime(2).ExpXEltPrime == ExpF1(2).ExpXEltPrime) && ...
			(ExpF1_prime(3).ExpXElt == ExpF1(3).ExpXElt) && ...
			(ExpF1_prime(3).ExpXEltPrime == ExpF1(3).ExpXEltPrime) && ...
			(ExpF1_prime(4).ExpXElt == ExpF1(4).ExpXElt) && ...
			(ExpF1_prime(4).ExpXEltPrime == expx_expected_change) && ...
			(ExpF1_prime(5).ExpXElt == expx_expected_change) && ...
			(ExpF1_prime(5).ExpXEltPrime == expx_expected_change) )

end

function test1_expg_list(testCase)
	%Description:
	%	Applies the function to an ExpGammaElement
	%	list that does not contain the target.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants 
	[Cover1,ExpX1,ExpG1] = get_expg_list1();

	expx_target  = ExpXElement( 1 , ...
								Polyhedron('lb',-2,'ub',-1) , ...
								Polyhedron('lb',-2,'ub',-1) );

	s = Polyhedron('lb',-3,'ub',3);

	expx_expected_change = ExpGammaElement( s , Polyhedron('lb',-2,'ub',-1) );

	%% Algorithm
	ExpG1_prime = change_tuples_in_list( ExpG1 , expx_target , s );

	assert( (ExpG1_prime(1) == expx_expected_change) && ...
			(ExpG1_prime(2) == ExpG1(2)) && ...
			(ExpG1_prime(3) == ExpG1(3)) && ...
			(ExpG1_prime(4) == ExpG1(4)))

end