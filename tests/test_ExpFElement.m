%test_ExpFElement.m
%Description:
%	Tests the ExpFElement class defined in this repository.

function tests = test_ExpFElement
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function three_expx_elts = give_me_three_expx_please()
	%Description:
	%	Returns three simple ExpXElements like the ones used in the one dimensional
	%	example.

	%% Algorithm

	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];

	three_expx_elts = [];
	for cover_elt_idx = 1:length(Cover1)

		% temp_tuple.Hc = cover_elt_idx;
		% temp_tuple.q = Cover0(cover_elt_idx);
		% temp_tuple.c = temp_tuple.q;
		temp_tuple = ExpXElement( cover_elt_idx , Cover1(cover_elt_idx) , Cover1(cover_elt_idx) );

		%Add to ExpX0;
		three_expx_elts = [three_expx_elts,temp_tuple];
	end

end

function test1_construction(testCase)
	%Description:
	%	Practices constructing a basic ExpFElement object.

	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	three_expxs = give_me_three_expx_please();
	
	%% Algorithm
	efe1 = ExpFElement( three_expxs(1) , 1 , three_expxs(2) );

	%% 
	assert( (efe1.ExpXElt == three_expxs(1)) && ...
			(efe1.u == 1) && ...
			(efe1.ExpXEltPrime == three_expxs(2)) )


end

function test1_equal(testCase)
	%Description:
	%	Practices comparing two different ExpFElement objects.

	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	three_expxs = give_me_three_expx_please();
	
	%% Algorithm
	efe1 = ExpFElement( three_expxs(1) , 1 , three_expxs(2) );
	efe2 = ExpFElement( three_expxs(1) , 1 , three_expxs(3) );
	efe3 = ExpFElement( three_expxs(1) , 1 , three_expxs(3) );

	%% 
	assert( (efe1 ~= efe2) && (efe2 == efe3) )

end

function test1_find(testCase)
	%Description:
	%	Practices ExpFElement object's method find_in_list().

	%% Include Libraries 
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	three_expxs = give_me_three_expx_please();

	efe1 = ExpFElement( three_expxs(1) , 1 , three_expxs(2) );
	efe2 = ExpFElement( three_expxs(1) , 1 , three_expxs(3) );
	efe3 = ExpFElement( three_expxs(1) , 1 , three_expxs(3) );
	efe4 = ExpFElement( three_expxs(2) , 1 , three_expxs(3) );

	temp_list1 = [ efe1 , efe2 , efe3 ];
	temp_list2 = [ efe1 , efe2 , efe4 ];

	%% Algorithm

	%% 
	assert( (efe4.find_in_list(temp_list1) == -1) && ...
			(efe4.find_in_list(temp_list2) == 3) )

end