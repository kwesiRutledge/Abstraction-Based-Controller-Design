%one_dim_example.m
%Description:
%

disp('one_dim_example.m')

%% Setup 

path_to_repo_top = '../';
addpath(genpath([path_to_repo_top 'lib/' ]))

pcis_enabled = check_for_pcis();

if ~pcis_enabled
	error('PCIS and Polyhedron are not currently included in the path. Make sure to include them before running this example.')
end

%% Constants

X = Polyhedron('lb',-2,'ub',2);
X0 = X;

num_U = 2; %There are only two inputs allowed
F = @one_dim_example_transition;

num_y = 3; %There are only three outputs.
H = @one_dim_example_output;

Y_labels{1} = 'A';
Y_labels{2} = 'B';
Y_labels{3} = 'C';

disp('- Defined Constants')

%%%%%%%%%%%%%%%
%% Algorithm %%
%%%%%%%%%%%%%%%

%% Initialization

Cover0 = [ Polyhedron('lb',-2,'ub',-1) , Polyhedron('lb',-1,'ub',1) , Polyhedron('lb',1,'ub',2) ];
ExpGamma0 = [];

ExpX0 = [];
for cover_elt_idx = 1:length(Cover0)
	temp_tuple.Hc = cover_elt_idx;
	temp_tuple.q = Cover0(cover_elt_idx);
	temp_tuple.c = temp_tuple.q;

	%Add to ExpX0;
	ExpX0 = [ExpX0,temp_tuple];
end

ExpF0 = [];

%% Loop

function [next_states] = one_dim_example_transition(x,u)
	%Description:
	%	Implement a simple dynamics map for the two inputs available to the one dimensional example.

	%% Input Processing %%
	if (abs(x) > 2)
		error(['The value of the state x must satisfy |x|<= 2. Received ' num2str(x) '.' ])
	end

	%% Algorithm

	switch u
		case 1
			next_states = Polyhedron('lb',x+1,'ub',x+1);
		case 2
			next_states = Polyhedron('lb',x-1,'ub',x-1);
		otherwise
			error(['There should only be two inputs for the system. Received u =' num2str(u) '.' ])
	end

	out = 1;
end