%test_get_expx_elts_with_maximal_cardv.m
%Description:
%	Tests the function get_expx_elts_with_maximal_cardv.

function tests = test_get_expx_elts_with_maximal_cardv
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1(testCase)
	%Description:
	%	In this test case, all expx elements have the same length.

	%% Include Libraries
	addpath(genpath('../lib/'));
	tf = check_for_pcis();

	%% Constants

	Cover0 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];
	ExpGamma0 = [];

	ExpX0 = [];
	for cover_elt_idx = 1:length(Cover0)

		% temp_tuple.Hc = cover_elt_idx;
		% temp_tuple.q = Cover0(cover_elt_idx);
		% temp_tuple.c = temp_tuple.q;
		temp_tuple = ExpXElement( cover_elt_idx , Cover0(cover_elt_idx) , Cover0(cover_elt_idx) );

		%Add to ExpX0;
		ExpX0 = [ExpX0,temp_tuple];
	end

	%% Algorithm

	temp_output = get_expx_elts_with_maximal_cardv( ExpX0 );

	%Verify that the output contains each element in ExpX0

	contains_all_expx0_elts = true;
	for expx0_idx = 1:length(ExpX0)
		expx0_elt = ExpX0(expx0_idx);

		if expx0_elt.find_in_list( temp_output ) == -1
			%IF the element is not found, then set contains_all_expx0_elts to false.
			contains_all_expx0_elts = false;
		end
	end

	assert(contains_all_expx0_elts)

end

function test2(testCase)
	%Description:
	%	In this test case, all expx elements have different lengths.

	%% Include Libraries
	addpath(genpath('../lib/'));
	tf = check_for_pcis();

	%% Constants

	ExpX2 = [ 	ExpXElement([1],2,3), ...
				ExpXElement([1,1,3],2,3), ...
				ExpXElement([1,1,3,2,4,5,3],2,3), ...
				ExpXElement([1,1,3,2,4],2,3) ];

	%% Algorithm

	temp_output = get_expx_elts_with_maximal_cardv( ExpX2 );

	%Verify that the output contains each element in ExpX0

	assert( (ExpX2(3).find_in_list(temp_output) == 1) && (length(temp_output) == 1) )

end