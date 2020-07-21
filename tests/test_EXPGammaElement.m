%test_EXPGammaElement.m
%Description:
%	A test suite that verifies the properties of pair defined by
%	the class EXPGammaElement
function tests = test_EXPGammaElement
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_construct(testCase)
	%Description:
	%	Tests the simple construction of the tuple using integer inputs.

	%% Include Libraries

	addpath(genpath('../lib/'))

	%% Constants

	q1 = randi(10);
	c1 = randi(3); 

	expg_elt = ExpGammaElement(q1,c1);

	%% Algorithm

	assert((expg_elt.q == q1) && (expg_elt.c == c1))

end

function test1_eq(testCase)
	%Description:
	%	Tests the == operator with a simple example.

	%% Include Libraries

	addpath(genpath('../lib/'))

	%% Constants

	q1 = 1;
	c1 = 3; 
	expg_elt1 = ExpGammaElement(q1,c1);

	q2 = q1;
	c2 = c1;
	expg_elt2 = ExpGammaElement(q2,c2);

	q3 = q1+1;
	c3 = c2;
	expg_elt3 = ExpGammaElement(q3,c3);

	%% Algorithm

	assert( (expg_elt1 == expg_elt2) && (expg_elt1 ~= expg_elt3) )

end

function test1_find_in_list(testCase)
	%Description:
	%	Tests the find_in_list function.

	%% Include Libraries

	addpath(genpath('../lib/'))

	%% Constants

	q1 = 1;
	c1 = 3; 
	expg_elt1 = ExpGammaElement(q1,c1);

	q2 = 1;
	c2 = 2;
	expg_elt2 = ExpGammaElement(q2,c2);

	q3 = q1+1;
	c3 = c2;
	expg_elt3 = ExpGammaElement(q3,c3);

	q4 = 3;
	c4 = 3;
	expg_elt4 = ExpGammaElement(q4,c4);

	expg_list1 = [ expg_elt1 , expg_elt2 , expg_elt3 , expg_elt4 ];
	expg_list2 = [ expg_elt1 , expg_elt2 , expg_elt4 ];

	%% Algorithm

	assert( ( expg_elt2.find_in_list( expg_list1 ) == 2 ) && ...
			( expg_elt3.find_in_list( expg_list2 ) == -1 ) )

end