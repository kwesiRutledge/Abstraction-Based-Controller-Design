%test_EXPX_to_EXP_Gamma.m
%Description:
%	Tests the function EXPX_to_EXP_Gamma().

function tests = test_EXPX_to_EXP_Gamma
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function expg_list1 = get_EXP_Gamma1()
	%Description:
	%	Create a sample EXP_Gamma set (or array)
	%	by creating an array of ExpGammaElement objects.

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

end

function expx_list1 = get_EXP_X1()
	%Description:
	%	Create a sample EXP_X set (or rather array) by creating an
	%	array of ExpXElement objects.

	%% Constants

	v1 = 2;
	q1 = 1;
	c1 = 3; 
	expx_elt1 = ExpXElement(v1,q1,c1);

	v2 = 3;
	q2 = 1;
	c2 = 2;
	expx_elt2 = ExpXElement(v2,q2,c2);

	v3 = 2;
	q3 = q1+1;
	c3 = c2;
	expx_elt3 = ExpXElement(v3,q3,c3);

	v4 = 1;
	q4 = 3;
	c4 = 3;
	expx_elt4 = ExpXElement(v4,q4,c4);

	expx_list1 = [ expx_elt1 , expx_elt2 , expx_elt3 , expx_elt4 ];

end

function test_EXPX_to_EXP_Gamma1(testCase)
	%Description:
	%	Tests the conversion of the list EXPX to the list EXP_Gamma.

	%% Include Libraries

	addpath(genpath('../lib/'))

	%% Constants

	expg_cand1 = get_EXP_Gamma1();
	expx_cand1 = get_EXP_X1();

	%% Algorithm

	expg_temp = EXPX_to_EXP_Gamma( expx_cand1 );

	%Loop through all elements of expg_temp and verify that they are the same
	all_elts_are_identical = true;
	for expg_temp_idx = 1:length(expg_temp)
		all_elts_are_identical = ( expg_temp( expg_temp_idx ) == expg_cand1(expg_temp_idx) );
	end

	assert( all_elts_are_identical )

end