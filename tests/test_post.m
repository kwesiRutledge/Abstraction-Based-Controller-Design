%test_post.m
%Description:
%This script tests the brand new post() member function of the Dyn() object.

function tests = test_post
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test_post1(testCase)
	%Description:
	%Tests post by giving a post operator for a simple Dyn object with singleton input.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	A1 = eye(2);
	B1 = [0;1];
	F1 = zeros(2,1);
	XU = Polyhedron('lb',-[2,2,1],'ub',[2,2,1]);

	d1 = Dyn(A1,F1,B1,XU);

	X0 = Polyhedron('lb',-ones( 1, d1.nx() ),'ub',ones( 1 , d1.nx() ));

	%% Algorithm

	post1 = d1.post( X0 , 'U' , 0.5 );

	assert( post1 == Polyhedron('lb',[-1,-0.5],'ub',[1,1.5]) )

end

function test_post2(testCase)
	%Description:
	%Tests post by giving a post operator for a simple Dyn object with full-dimensional
	%input sets.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants

	A1 = eye(2);
	B1 = [0;1];
	F1 = zeros(2,1);
	XU = Polyhedron('lb',-[2,2,1],'ub',[2,2,1]);

	d1 = Dyn(A1,F1,B1,XU);

	X0 = Polyhedron('lb',-ones( 1, d1.nx() ),'ub',ones( 1 , d1.nx() ));

	%% Algorithm

	post1 = d1.post( X0 );

	assert( post1 == Polyhedron('lb',[-1,-2],'ub',[1,2]) )

end