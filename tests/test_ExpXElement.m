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
	tf = check_for_pcis();

	%% Constants
	Cover1 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];

	%% Algorithm 
	temp_ExpXElement = ExpXElement( 1 , Cover1(1) , Cover1(2) );

	assert( (temp_ExpXElement.v == 1) && ...
			(temp_ExpXElement.q == Cover1(1)) && ...
			(temp_ExpXElement.c == Cover1(2)) )

end

function [ExpF1 , ExpX1 , num_U] = get_simple_ExpF1()
	%Description:
	%	Creates a dummy ExpF1 set.

	%% Constants

	num_U = 2;

	%Create some ExpXElements
	Cover1 = [ 	Polyhedron('lb',-2,'ub',-1) , ...
				Polyhedron('lb',-1,'ub',1) , ...
				Polyhedron('lb',1,'ub',2) ];

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
	tf = check_for_pcis();

	%% Constants

	%Create an example ExpF set
	[example_ExpF1, example_ExpX1, num_U] = get_simple_ExpF1();

	%Create a temporary expx1
	temp_ExpXElement = example_ExpX1(1);

	%% Algorithm
	temp_PostQ = temp_ExpXElement.get_PostQ_u( example_ExpF1 , num_U );

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
	tf = check_for_pcis();

	%% Constants

	%Create an example ExpF set
	[example_ExpF1, example_ExpX1, num_U] = get_simple_ExpF1();

	%Create a temporary expx1
	temp_ExpXElement = example_ExpX1(3);

	%% Algorithm
	temp_PostQ = temp_ExpXElement.get_PostQ_u( example_ExpF1 , num_U )

	assert(	(length(temp_PostQ) == 2) && ...
			(temp_PostQ{1} == example_ExpX1(4).q ) && ...
			isempty(temp_PostQ{2}) )

end