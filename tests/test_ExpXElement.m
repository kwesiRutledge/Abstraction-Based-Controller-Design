%test_ExpXElement.m
%Description:
%	Testing the methods of the ExpXElement() object.


function tests = test_ExpXElement
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_constructor(testCase)
	%Description:
	%	Tests the simple construction of an ExpXElement();

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants
	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];

	%% Algorithm 
	temp_ExpXElement = ExpXElement( 1 , Cover1(1) , Cover1(2) );

	assert( (temp_ExpXElement.v == 1) && ...
			(temp_ExpXElement.q == Cover1(1)) && ...
			(temp_ExpXElement.c == Cover1(2)) )

end

function test1_eq(testCase)
	%Description:
	%	Tests a simple comparison of two equal ExpXElements.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants
	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];

	%% Algorithm 
	temp_ExpXElement1 = ExpXElement( 1 , Cover1(1) , Cover1(2) );
	temp_ExpXElement2 = ExpXElement( 1 , Cover1(1) , Cover1(2) );

	assert( temp_ExpXElement1 == temp_ExpXElement2 )

end

function test2_eq(testCase)
	%Description:
	%	Tests the comparison of two ExpXElements with different length v
	%	elements.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants
	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];

	%% Algorithm 
	temp_ExpXElement1 = ExpXElement( 1 , Cover1(1) , Cover1(2) );
	temp_ExpXElement2 = ExpXElement( [1,2,3] , Cover1(1) , Cover1(2) );

	assert(temp_ExpXElement1 ~= temp_ExpXElement2)

end

function [ExpF1 , ExpX1 , num_U] = get_simple_ExpF1()
	%Description:
	%	Creates a dummy ExpF1 set.

	%% Constants

	num_U = 2;

	%Create some ExpXElements
	Cover1 = [ 	PolyUnion(Polyhedron('lb',-2,'ub',-1)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',1)) , ...
				PolyUnion(Polyhedron('lb',1,'ub',2)) ];

	expx1 = ExpXElement( 1 , Cover1(1) , Cover1(1) );
	expx2 = ExpXElement( 1 , Cover1(1) , Cover1(2) );
	expx3 = ExpXElement( 1 , Cover1(1) , Cover1(3) );
	expx4 = ExpXElement( 1 , Cover1(2) , Cover1(2) );

	ExpX1 = [ expx1 , expx2 , expx3 , expx4 ];

	%Create expf elements with those
	expf1 = ExpFElement( expx1 , 1 , expx2 );
	expf2 = ExpFElement( expx2 , 1 , expx3 );
	expf3 = ExpFElement( expx3 , 1 , expx4 );
	expf4 = ExpFElement( expx4 , 1 , expx1 );
	expf5 = ExpFElement( expx1 , 2 , expx1 );

	%% Algorithm

	ExpF1 = [ expf1 , expf2 , expf3 , expf4 , expf5 ];

end

function test1_get_PostQ_u(testCase)
	%Description:
	%	Tests the member method get_PostQ_u which is quite complex.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants

	%Create an example ExpF set
	[example_ExpF1, example_ExpX1, num_U] = get_simple_ExpF1();

	%Create a temporary expx1
	temp_ExpXElement = example_ExpX1(1);

	%% Algorithm
	temp_PostQ = temp_ExpXElement.get_PostQ_u( example_ExpF1 , num_U );
	% temp_PostQ{1}

	assert((length(temp_PostQ) == 2) && ...
			( temp_PostQ{1} == example_ExpX1(2).q ) && ...
			( temp_PostQ{2} == example_ExpX1(1).q ) )

end

function test2_get_PostQ_u(testCase)
	%Description:
	%	Tests the member method get_PostQ_u which is quite complex.
	%	Trying to see what happens when one of the PostQ sets is empty.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants

	%Create an example ExpF set
	[example_ExpF1, example_ExpX1, num_U] = get_simple_ExpF1();

	example_ExpF1 = [ example_ExpF1 , ExpFElement( example_ExpX1(1) , 2 , example_ExpX1(2) ) ];

	%Create a temporary expx1
	temp_ExpXElement = example_ExpX1(3);

	%% Algorithm
	temp_PostQ = temp_ExpXElement.get_PostQ_u( example_ExpF1 , num_U );

	assert(	(length(temp_PostQ) == 2) && ...
			(temp_PostQ{1} == example_ExpX1(4).q ) && ...
			isempty(temp_PostQ{2}) )

end

function [ExpF2 , ExpX2 , num_U] = get_simple_ExpF2()
	%Description:
	%	Creates a dummy ExpF1 set.

	%% Constants

	num_U = 2;

	%Create some ExpXElements
	Cover2 = [ 	PolyUnion(Polyhedron('lb',-2,'ub',-1)) , ...
				PolyUnion(Polyhedron('lb',-1,'ub',1)) , ...
				PolyUnion(Polyhedron('lb',1,'ub',2)) ];

	expx1 = ExpXElement( 1 , Cover2(1) , Cover2(1) );
	expx2 = ExpXElement( 1 , Cover2(1) , Cover2(2) );
	expx3 = ExpXElement( 1 , Cover2(1) , Cover2(3) );
	expx4 = ExpXElement( 1 , Cover2(2) , Cover2(2) );
	expx5 = ExpXElement( 1 , Cover2(3) , Cover2(3) );

	ExpX2 = [ expx1 , expx2 , expx3 , expx4 , expx5 ];

	%Create expf elements with those
	expf1 = ExpFElement( expx1 , 1 , expx2 );
	expf2 = ExpFElement( expx2 , 1 , expx3 );
	expf3 = ExpFElement( expx3 , 1 , expx4 );
	expf4 = ExpFElement( expx4 , 1 , expx1 );
	expf5 = ExpFElement( expx1 , 2 , expx1 );
	expf6 = ExpFElement( expx1 , 2 , expx5 );

	%% Algorithm

	ExpF2 = [ expf1 , expf2 , expf3 , expf4 , expf5 , expf6 ];

end

function test3_get_PostQ_u(testCase)
	%Description:
	%	Tests the member method get_PostQ_u which is quite complex.
	%	Trying to see what happens when PostQ is supposed to create a disjoint
	%	set (as a polyunion).

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants

	%Create an example ExpF set
	[example_ExpF3, example_ExpX3, num_U] = get_simple_ExpF2();

	%Create a temporary expx1
	temp_ExpXElement = example_ExpX3(1);

	%% Algorithm
	temp_PostQ = temp_ExpXElement.get_PostQ_u( example_ExpF3 , num_U );

	assert(	(length(temp_PostQ) == 2) && ...
			(temp_PostQ{1} == example_ExpX3(2).q ) && ...
			(temp_PostQ{2} == PolyUnion([example_ExpX3(1).q.Set,example_ExpX3(5).q.Set ]) ) )

end

function [st_out, expx_out , expf_out, num_U , cover_out ] = get_test_system1()
	%Description:
	%	Create a system with a PostQ_u that we can represent.

	%% Create System

	X = PolyUnion(Polyhedron('lb',-2,'ub',2));
	X0 = X;

	num_U = 2; %There are only two inputs allowed
	%F = @one_dim_example_transition;
	DynList = [ Dyn(1,1,0,X.Set(1)*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X.Set(1)*Polyhedron('lb',0,'ub',0)) ];

	num_y = 3; %There are only three outputs.
	H = @one_dim_example_output;
	Hinv = [ Polyhedron('lb',-2,'ub',-1) , ...
			 Polyhedron('lb',-1,'ub',1) ,
			 Polyhedron('lb',1,'ub',2) ];

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st_out = SystemTuple(X,X0,Hinv,'LinearDynamics',DynList);

	%% Create ExpFElement set

	%Create expx_out
	cover_out = [ 	PolyUnion( Polyhedron('lb',-2,'ub',-0.5) ) , ...
					PolyUnion( Polyhedron('lb',-1.5,'ub',1.5) ) , ...
					PolyUnion( Polyhedron('lb',1,'ub',3) ) , ...
					PolyUnion( Polyhedron('lb',0,'ub',2 ) ) , ... %resultant "s" for refine( [ 1,cover1(1),cover1(1) ])
					PolyUnion( Polyhedron('lb',max([0,-0.5])-0.5,'ub',min([2,2.5])+0.5) ), ... %This should CONTAIN the resultant "s" for refine( [ 1,cover1(1),cover1(1) ])
					PolyUnion( Polyhedron('lb',0.5,'ub',1.5 ) ) ];

	expx1 = ExpXElement( 1 , cover_out(1) , cover_out(1) );
	expx2 = ExpXElement( 1 , cover_out(4) , cover_out(2) );
	expx3 = ExpXElement( 1 , cover_out(1) , cover_out(3) );
	expx4 = ExpXElement( 1 , cover_out(2) , cover_out(2) );
	expx5 = ExpXElement( 1 , cover_out(3) , cover_out(3) );

	expx6 = ExpXElement( 1 , cover_out(5) , cover_out(3) );
	expx7 = ExpXElement( 1 , cover_out(5) , cover_out(6) ); %this is the entry that will be changed in test3_refine

	expx_out = [ expx1 , expx2 , expx3 , expx4 , expx5 , expx6 , expx7 ];

	% Create expf_out
	expf1 = ExpFElement( expx1 , 1 , expx5 );
	expf5 = ExpFElement( expx1 , 2 , expx4 );

	expf2 = ExpFElement( expx2 , 1 , expx5 );
	expf6 = ExpFElement( expx2 , 2 , expx4 );

	expf3 = ExpFElement( expx3 , 1 , expx4 );
	expf4 = ExpFElement( expx4 , 1 , expx1 );

	expf7 = ExpFElement( expx7 , 1 , expx5 );
	expf8 = ExpFElement( expx7 , 2 , expx4 );

	expf_out = [ expf1 , expf2 , expf3 , expf4 , expf5 , ...
				 expf6 , expf7 , expf8 ];

end

function test1_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to identify when things are not 

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = (check_for_pcis()) && (check_for_gurobi()) ;

	%% Constants
	[st_out, ExpX1 , ExpF1 , num_U , cover1 ] = get_test_system1();
	ExpG1 = [];
	for expx_idx = 1:length(ExpX1)
		temp_ExpXElement = ExpX1(expx_idx);

		ExpG1 = [ ExpG1 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX1(1);

	%% Algorithm
	[ cover1_prime , ExpF1_out , ExpG1_out , ExpX1_prime ] = target_tuple.refine( st_out , cover1 , ExpF1 , ExpG1 , ExpX1 );

	post_Q = target_tuple.get_PostQ_u( ExpF1 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	s_subset_q = PolyUnion_subseteq(s,target_tuple.q);

	%s should be [0,2], technically PolyUnion([Polyhedron('lb',0,'ub',2)])
	%target_tuple.q should be [-2,-0.5], technically PolyUnion([Polyhedron('')])
	%Therefore, s_subset_q should be false
	%And:
	%	- cover1_out == cover1
	%	- ExpF1_out == ExpF1
	%	- ExpG1_out == ExpG1
	%	- ExpX1_out == ExpX1

	cover1_equals_cover1_out = true;
	for c1_idx = 1:length(cover1)
		c1_elt = cover1(c1_idx);
		c1p_elt = cover1_prime(c1_idx);

		cover1_equals_cover1_out = cover1_equals_cover1_out && (c1_elt == c1p_elt);

	end

	expf1_equals_expf1_out = true;
	for ef1_idx = 1:length(ExpF1)
		expf_elt = ExpF1(ef1_idx);
		expfo_elt = ExpF1_out(ef1_idx);

		expf1_equals_expf1_out = expf1_equals_expf1_out && ( expf_elt == expfo_elt );
	end

	expg1_equals_expg1_out = true;
	for eg1_idx = 1:length(ExpG1)
		expg_elt = ExpG1(eg1_idx);
		expgo_elt = ExpG1_out(eg1_idx);

		expg1_equals_expg1_out = expg1_equals_expg1_out && ( expg_elt == expgo_elt );
	end

	expx1_equals_expx1_prime = true;
	for ex1_idx = 1:length(ExpX1)
		expx_elt = ExpX1(ex1_idx);
		expxp_elt = ExpX1_prime(ex1_idx);

		expx1_equals_expx1_prime = expx1_equals_expx1_prime && ( expx_elt == expxp_elt );
	end

	assert( (~s_subset_q) && cover1_equals_cover1_out && ...
		expf1_equals_expf1_out && expg1_equals_expg1_out && expx1_equals_expx1_prime )

end

function test2_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to identify when:
	%	- the s <= q condition is true 
	%	- there are no elements where line 31 of algorithm is satisfied
	%	- there are no transitions that satisfy line 34 of the algorithm

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	[st_out, ExpX2 , ExpF2 , num_U , cover2 ] = get_test_system1();
	ExpG2 = [];
	for expx_idx = 1:length(ExpX2)
		temp_ExpXElement = ExpX2(expx_idx);

		ExpG2 = [ ExpG2 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX2(2);

	%% Algorithm
	[ cover2_prime , ExpF2_out , ExpG2_out , ExpX2_prime ] = ...
		target_tuple.refine( st_out , cover2 , ExpF2 , ExpG2 , ExpX2 );

	post_Q = target_tuple.get_PostQ_u( ExpF2 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	s_subset_q = PolyUnion_subseteq(s,target_tuple.q);
	s_strictsubset_q = PolyUnion_strictsubset(s,target_tuple.q);

	%s should be [0,2], technically PolyUnion([Polyhedron('lb',0,'ub',2)])
	%target_tuple.q should be [0,2], technically PolyUnion([Polyhedron('')])
	%Therefore, s_subset_q should be TRUE
	%And:
	%	- cover2_prime == cover2, %Because of a technicality. s is not a strict subset of q
	%	- ExpF2_out == ExpF2
	%	- ExpG2_out == ExpG2
	%	- ExpX2_out == ExpX2

	cover2_is_subset_of_cover2_prime = true;
	for c2_idx = 1:length(cover2)
		c2_elt = cover2(c2_idx);
		c2p_elt = cover2_prime(c2_idx);

		cover2_is_subset_of_cover2_prime = cover2_is_subset_of_cover2_prime && (c2_elt == c2p_elt);
	end

	expf2_equals_expf2_out = true;
	for ef2_idx = 1:length(ExpF2)
		expf_elt = ExpF2(ef2_idx);
		expfo_elt = ExpF2_out(ef2_idx);

		expf2_equals_expf2_out = expf2_equals_expf2_out && ( expf_elt == expfo_elt );
	end

	expg2_equals_expg2_out = true;
	for eg2_idx = 1:length(ExpG2)
		expg_elt = ExpG2(eg2_idx);
		expgo_elt = ExpG2_out(eg2_idx);

		expg2_equals_expg2_out = expg2_equals_expg2_out && ( expg_elt == expgo_elt );
	end

	expx2_equals_expx2_prime = true;
	for ex2_idx = 1:length(ExpX2)
		expx_elt = ExpX2(ex2_idx);
		expxp_elt = ExpX2_prime(ex2_idx);

		expx2_equals_expx2_prime = expx2_equals_expx2_prime && ( expx_elt == expxp_elt );
	end

	% disp(expf2_equals_expf2_out)
	% disp(expg2_equals_expg2_out)
	% disp(expx2_equals_expx2_prime)

	assert( s_subset_q && (~s_strictsubset_q) && ...
			cover2_is_subset_of_cover2_prime && (length(cover2) == length(cover2_prime)) && ...
			expf2_equals_expf2_out && expg2_equals_expg2_out && expx2_equals_expx2_prime )

end

function [st_out, expx_out , expf_out, num_U , cover_out ] = get_test_system2()
	%Description:
	%	Create a system with a PostQ_u that we can represent.
	%	This one is meant specifically for test3_refine.

	%% Create System

	X = PolyUnion(Polyhedron('lb',-2,'ub',2));
	X0 = X;

	num_U = 2; %There are only two inputs allowed
	%F = @one_dim_example_transition;
	DynList = [ Dyn(1,1,0,X.Set(1)*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X.Set(1)*Polyhedron('lb',0,'ub',0)) ];

	num_y = 3; %There are only three outputs.
	H = @one_dim_example_output;
	Hinv = [ Polyhedron('lb',-2,'ub',-1) , ...
			 Polyhedron('lb',-1,'ub',1) ,
			 Polyhedron('lb',1,'ub',2) ];

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st_out = SystemTuple(X,X0,Hinv,'LinearDynamics',DynList);

	%% Create ExpFElement set

	%Create expx_out
	cover_out = [ 	PolyUnion( Polyhedron('lb',-2,'ub',-0.5) ) , ...
					PolyUnion( Polyhedron('lb',-1.5,'ub',1.5) ) , ...
					PolyUnion( Polyhedron('lb',1,'ub',3) ) , ...
					%PolyUnion( Polyhedron('lb',0,'ub',2 ) ) , ... %resultant "s" for refine( [ 1,cover1(1),cover1(1) ])
					PolyUnion( Polyhedron('lb',-1,'ub',3) ) ];

	expx1 = ExpXElement( 1 , cover_out(1) , cover_out(1) );
	expx2 = ExpXElement( 1 , cover_out(2) , cover_out(2) );
	expx3 = ExpXElement( 1 , cover_out(3) , cover_out(3) ); %Will not be changed.
	expx4 = ExpXElement( 1 , cover_out(4) , cover_out(2) );

	expx_out = [ expx1 , expx2 , expx3 , expx4 ];

	% Create expf_out
	expf1 = ExpFElement( expx4 , 1 , expx3 );
	expf2 = ExpFElement( expx4 , 2 , expx2 );

	expf_out = [ expf1 , expf2 ];

end

function test3_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to identify when:
	%	- the s <= q condition is true 
	%	- there are no elements where line 31 of algorithm is satisfied
	%	- there are no transitions that satisfy line 34 of the algorithm

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	[st_out, ExpX3 , ExpF3 , num_U , cover3 ] = get_test_system2();
	ExpG3 = [];
	for expx_idx = 1:length(ExpX3)
		temp_ExpXElement = ExpX3(expx_idx);

		ExpG3 = [ ExpG3 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX3(end);

	%% Algorithm
	[ cover3_prime , ExpF3_out , ExpG3_out , ExpX3_prime ] = ...
		target_tuple.refine( st_out , cover3 , ExpF3 , ExpG3 , ExpX3 );

	post_Q = target_tuple.get_PostQ_u( ExpF3 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	s_strictsubset_q = PolyUnion_strictsubset(s,target_tuple.q);

	c_tilde = target_tuple.c;
	c_strictsubset_s = PolyUnion_strictsubset(c_tilde,s);

	%s should be [0,2], technically PolyUnion([Polyhedron('lb',0,'ub',2)])
	%target_tuple.q should be [0,2], technically PolyUnion([Polyhedron('')])
	%Therefore, s_subset_q and c_strictsubset_s should be TRUE
	%And:
	%	- cover3_prime == cover3 U s
	%	- ExpF3_out == ExpF3
	%	- ExpG3_out == ExpG3
	%	- ExpX3_out == ExpX3

	cover3_is_subset_of_cover3_prime = true;
	for c3_idx = 1:length(cover3)
		c3_elt = cover3(c3_idx);
		c3p_elt = cover3_prime(c3_idx);

		cover3_is_subset_of_cover3_prime = cover3_is_subset_of_cover3_prime && (c3_elt == c3p_elt);
	end

	expf3_equals_expf3_out = true;
	for ef3_idx = 1:length(ExpF3)
		expf_elt = ExpF3(ef3_idx);
		expfo_elt = ExpF3_out(ef3_idx);

		expf3_equals_expf3_out = expf3_equals_expf3_out && ( expf_elt == expfo_elt );
	end

	expg3_equals_expg3_out = true;
	for eg3_idx = 1:length(ExpG3)
		expg_elt = ExpG3(eg3_idx);
		expgo_elt = ExpG3_out(eg3_idx);

		expg3_equals_expg3_out = expg3_equals_expg3_out && ( expg_elt == expgo_elt );
	end

	expx3_equals_expx3_prime = true;
	for ex3_idx = 1:length(ExpX3)
		expx_elt = ExpX3(ex3_idx);
		expxp_elt = ExpX3_prime(ex3_idx);

		expx3_equals_expx3_prime = expx3_equals_expx3_prime && ( expx_elt == expxp_elt );
	end

	% disp(expf2_equals_expf2_out)
	% disp(expg2_equals_expg2_out)
	% disp(expx2_equals_expx2_prime)

	% disp(cover3_is_subset_of_cover3_prime && (length(cover3) == (length(cover3_prime) - 1)))
	% disp(cover3_is_subset_of_cover3_prime)
	% disp(length(cover3) == (length(cover3_prime) - 1))

	assert( s_strictsubset_q && (~c_strictsubset_s) && ...
			cover3_is_subset_of_cover3_prime && (length(cover3) == (length(cover3_prime) - 1)) && ...
			expf3_equals_expf3_out && expg3_equals_expg3_out && expx3_equals_expx3_prime )


end

function test4_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to identify when:
	%	- the s <= q condition is true 
	%	- there are some elements where line 31 of algorithm is satisfied
	%	- there are some transitions that satisfy line 34 of the algorithm 

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	[st_out, ExpX4 , ExpF4 , num_U , cover4 ] = get_test_system1();
	ExpG4 = [];
	for expx_idx = 1:length(ExpX4)
		temp_ExpXElement = ExpX4(expx_idx);

		ExpG4 = [ ExpG4 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX4(7);

	%% Algorithm
	[ cover4_prime , ExpF4_out , ExpG4_out , ExpX4_prime ] = ...
		target_tuple.refine( st_out , cover4 , ExpF4 , ExpG4 , ExpX4 );

	post_Q = target_tuple.get_PostQ_u( ExpF4 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	s_subset_q = PolyUnion_subseteq(s,target_tuple.q);

	%s should be [0,2], technically PolyUnion([Polyhedron('lb',0,'ub',2)])
	%target_tuple.q should be [0,2], technically PolyUnion([Polyhedron('')])
	%Therefore, s_subset_q should be TRUE
	%And:
	%	- cover2_prime == cover2 U s
	%	- ExpX2(2) == ExpXElement( 1 , PolyUnion( Polyhedron('lb',0,'ub',2 ) ) , cover_out(2) );
	%	- ExpX2(6) == ExpXElement( 1 , PolyUnion( Polyhedron('lb',0,'ub',2 ) ) , cover_out(3) );
	%	- ExpG1_out == ExpG1
	%	- ExpX1_out == ExpX1

	cover4_is_subset_of_cover4_prime = true;
	for c4_idx = 1:length(cover4)
		c4_elt = cover4(c4_idx);
		c4p_elt = cover4_prime(c4_idx);

		cover4_is_subset_of_cover4_prime = cover4_is_subset_of_cover4_prime && (c4_elt == c4p_elt);
	end

	% expf2_equals_expf2_out = true;
	% for ef1_idx = 1:length(ExpF1)
	% 	expf_elt = ExpF1(ef1_idx);
	% 	expfo_elt = ExpF1_out(ef1_idx);

	% 	expf1_equals_expf1_out = expf1_equals_expf1_out && ( expf_elt == expfo_elt );
	% end

	% expg1_equals_expg1_out = true;
	% for eg1_idx = 1:length(ExpG1)
	% 	expg_elt = ExpG1(eg1_idx);
	% 	expgo_elt = ExpG1_out(eg1_idx);

	% 	expg1_equals_expg1_out = expg1_equals_expg1_out && ( expg_elt == expgo_elt );
	% end

	% expx1_equals_expx1_prime = true;
	% for ex1_idx = 1:length(ExpX1)
	% 	expx_elt = ExpX1(ex1_idx);
	% 	expxp_elt = ExpX1_prime(ex1_idx);

	% 	expx1_equals_expx1_prime = expx1_equals_expx1_prime && ( expx_elt == expxp_elt );
	% end
	% disp( ExpG4_out(6) ~= ExpGammaElement( ExpXElement( 1 , s , cover4(3) )) )
	% disp( ExpG4_out(7) == ExpGammaElement( ExpXElement( 1 , s , cover4(6) )) )

	assert( s_subset_q && ...
			cover4_is_subset_of_cover4_prime && (length(cover4) == (length(cover4_prime) - 1)) && ...
			(cover4_prime(end) == s ) && ...
			( ExpX4_prime(6) ~= ExpXElement( 1 , s , cover4(3) )) && ... %This entry should not be changed in X3
			( ExpX4_prime(7) == ExpXElement( 1 , s , cover4(6) )) && ...
			( ExpF4_out(7).ExpXElt == ExpXElement( 1 , s , cover4(6) )) && ...
			( ExpF4_out(8).ExpXElt == ExpXElement( 1 , s , cover4(6) )) && ...
			( ExpG4_out(6) ~= ExpGammaElement( ExpXElement( 1 , s , cover4(3) )) ) && ...
			( ExpG4_out(7) == ExpGammaElement( ExpXElement( 1 , s , cover4(6) )) ) )

end

function [st_out, expx_out , expf_out, num_U , cover_out ] = get_test_system3()
	%Description:
	%	Create a system with a predictable value for PostQ_u.
	%	This system configuration is different in that:
	%		- Cover is an array of Polyhedron objects
	%
	%	This one is meant specifically for test3_refine.

	%% Create System

	X = Polyhedron('lb',-2,'ub',2);
	X0 = X;

	num_U = 2; %There are only two inputs allowed
	%F = @one_dim_example_transition;
	DynList = [ Dyn(1,1,0,X*Polyhedron('lb',0,'ub',0)) , ...
				Dyn(1,-1,0,X*Polyhedron('lb',0,'ub',0)) ];

	num_y = 3; %There are only three outputs.
	H = @one_dim_example_output;
	Hinv = [ Polyhedron('lb',-2,'ub',-1) , ...
			 Polyhedron('lb',-1,'ub',1) ,
			 Polyhedron('lb',1,'ub',2) ];

	Y_labels{1} = 'A';
	Y_labels{2} = 'B';
	Y_labels{3} = 'C';

	st_out = SystemTuple(X,X0,Hinv,'LinearDynamics',DynList);

	%% Create ExpFElement set

	%Create expx_out
	cover_out = [ 	Polyhedron('lb',-2,'ub',-0.5) , ...
					Polyhedron('lb',-1.5,'ub',1.5) , ...
					Polyhedron('lb',1,'ub',3) , ...
					%PolyUnion( Polyhedron('lb',0,'ub',2 ) ) , ... %resultant "s" for refine( [ 1,cover1(1),cover1(1) ])
					Polyhedron('lb',-1,'ub',3) ];

	expx1 = ExpXElement( 1 , cover_out(1) , cover_out(1) );
	expx2 = ExpXElement( 1 , cover_out(2) , cover_out(2) );
	expx3 = ExpXElement( 1 , cover_out(3) , cover_out(3) ); %Will not be changed.
	expx4 = ExpXElement( 1 , cover_out(4) , cover_out(2) );

	expx_out = [ expx1 , expx2 , expx3 , expx4 ];

	% Create expf_out
	expf1 = ExpFElement( expx4 , 1 , expx3 );
	expf2 = ExpFElement( expx4 , 2 , expx2 );

	expf_out = [ expf1 , expf2 ];

end

function test5_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to identify when:
	%	- the s <= q condition is true 
	%	- there are some elements where line 31 of algorithm is satisfied
	%	- there are some transitions that satisfy line 34 of the algorithm 

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	[st_out, ExpX5 , ExpF5 , num_U , cover5 ] = get_test_system3();
	ExpG5 = [];
	for expx_idx = 1:length(ExpX5)
		temp_ExpXElement = ExpX5(expx_idx);

		ExpG5 = [ ExpG5 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX5(end);

	%% Algorithm
	[ cover5_prime , ExpF5_out , ExpG5_out , ExpX5_prime ] = ...
		target_tuple.refine( st_out , cover5 , ExpF5 , ExpG5 , ExpX5 );

	post_Q = target_tuple.get_PostQ_u( ExpF5 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	s_subset_q = (s <= target_tuple.q);
	s_strictsubset_q = (s <= target_tuple.q) && (s ~= target_tuple.q);

	%s should be [0,2], technically PolyUnion([Polyhedron('lb',0,'ub',2)])
	%target_tuple.q should be [0,2], technically PolyUnion([Polyhedron('')])
	%Therefore, s_subset_q and c_strictsubset_s should be TRUE
	%And:
	%	- cover5_prime == cover5 U s
	%	- ExpF5_out == ExpF5
	%	- ExpG5_out == ExpG5
	%	- ExpX5_out == ExpX5

	cover5_is_subset_of_cover5_prime = true;
	for c5_idx = 1:length(cover5)
		c5_elt = cover5(c5_idx);
		c5p_elt = cover5_prime(c5_idx);

		cover5_is_subset_of_cover5_prime = cover5_is_subset_of_cover5_prime && (c5_elt == c5p_elt);
	end

	expf5_equals_expf5_out = true;
	for ef5_idx = 1:length(ExpF5)
		expf_elt = ExpF5(ef5_idx);
		expfo_elt = ExpF5_out(ef5_idx);

		expf5_equals_expf5_out = expf5_equals_expf5_out && ( expf_elt == expfo_elt );
	end

	expg5_equals_expg5_out = true;
	for eg5_idx = 1:length(ExpG5)
		expg_elt = ExpG5(eg5_idx);
		expgo_elt = ExpG5_out(eg5_idx);

		expg5_equals_expg5_out = expg5_equals_expg5_out && ( expg_elt == expgo_elt );
	end

	expx5_equals_expx5_prime = true;
	for ex5_idx = 1:length(ExpX5)
		expx_elt = ExpX5(ex5_idx);
		expxp_elt = ExpX5_prime(ex5_idx);

		expx5_equals_expx5_prime = expx5_equals_expx5_prime && ( expx_elt == expxp_elt );
	end

	assert( s_strictsubset_q && s_subset_q && ...
			cover5_is_subset_of_cover5_prime && (length(cover5) == (length(cover5_prime) - 1)) && ...
			expf5_equals_expf5_out && expg5_equals_expg5_out && expx5_equals_expx5_prime )

end

function test6_refine(testCase)
	%Description:
	%	Tests the ability of the refine object to return a Polyhedron when its key system components
	%	are defined as Polyhedron() objects.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	[st_out, ExpX5 , ExpF5 , num_U , cover5 ] = get_test_system3();
	ExpG5 = [];
	for expx_idx = 1:length(ExpX5)
		temp_ExpXElement = ExpX5(expx_idx);

		ExpG5 = [ ExpG5 , ExpGammaElement( temp_ExpXElement ) ];
	end

	target_tuple = ExpX5(end);

	%% Algorithm
	[ cover5_prime , ExpF5_out , ExpG5_out , ExpX5_prime ] = ...
		target_tuple.refine( st_out , cover5 , ExpF5 , ExpG5 , ExpX5 );

	post_Q = target_tuple.get_PostQ_u( ExpF5 , st_out.nu() );

	% post_Q

	% for postq_idx = 1:length(post_Q)
	% 	for set_idx = 1:post_Q{postq_idx}.Num 
	% 		post_Q{postq_idx}.Set(set_idx)
	% 	end
	% end

	s = st_out.pre_input_dependent( post_Q );

	assert( strcmp(class(s),'Polyhedron') )

end
