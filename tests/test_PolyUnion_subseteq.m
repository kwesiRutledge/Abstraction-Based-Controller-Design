%test_PolyUnion_subseteq.m
%Description:
%	Testing the PolyUnion_subseteq function.

function tests = test_PolyUnion_subseteq
	%disp(localfunctions)
	tests = functiontests(localfunctions);
end

function test1_disjoint(testCase)
	%Description:
	%	Should create a set of PolyUnions which are disjoint.
	%	The function should detect this.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	pu1 = PolyUnion( [Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',1.5,'ub',2.5)] );
	pu2 = PolyUnion( [Polyhedron('lb',0,'ub',1)] );

	%% Algorithm
	assert(~PolyUnion_subseteq(pu1,pu2))

end

function test1_contained(testCase)
	%Description:
	%	Should create a set of PolyUnions which are disjoint.
	%	The function should detect this.

	%% Including Libraries
	addpath(genpath('../lib/'))
	tf = check_for_pcis();

	%% Constants
	pu1 = PolyUnion( [Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',1.5,'ub',2.5)] );
	pu2 = PolyUnion( [Polyhedron('lb',2,'ub',2.5)] );

	%% Algorithm

	assert(PolyUnion_subseteq(pu2,pu1))

end