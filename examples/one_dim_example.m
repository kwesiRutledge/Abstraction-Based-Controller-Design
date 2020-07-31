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

st_oneD = SystemTuple(X,X0,DynList,num_y,H);

disp('- Defined Constants')

%%%%%%%%%%%%%%%
%% Algorithm %%
%%%%%%%%%%%%%%%

%% Initialization

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

ExpF0 = [];

%% Loop

loop_condition = (length(ExpX0) == 0);
ExpX = ExpX0;
ExpF = ExpF0;
Cover = Cover0;
ExpGamma = ExpGamma0;

%while loop_condition
ExpGamma_i = EXPX_to_EXP_Gamma( ExpX );
maximal_subset_ExpX = get_expx_elts_with_maximal_cardv( ExpX );
for maximal_elt_idx = 1:length(maximal_subset_ExpX)
	temp_maximal_elt = maximal_subset_ExpX(maximal_elt_idx);

	for u = 1:num_U
		for y = 1:num_y
			v_prime = [ temp_maximal_elt.v , u , y ];
			c_prime = intersect(st_oneD.F( temp_maximal_elt.c , u ), Hinv(y) );
			Q_prime = get_minimal_covering_subsets_for( c_prime , Cover0 );

			for q_prime_idx = 1:length(Q_prime)
				q_prime = Q_prime(q_prime_idx);
				temp_expx_elt = ExpXElement( v_prime , c_prime , q_prime );
				
				%Update ExpX
				ExpX = temp_expx_elt.union_with_set( ExpX );

				%Update EXPF
				temp_expf_elt = ExpFElement( temp_maximal_elt , u , temp_expx_elt );
				ExpF = temp_expf_elt.union_with_set( ExpF );
			end

		end
	end

	%possibly refine.
	if temp_maximal_elt.c <= temp_maximal_elt.q
		[ Cover , ExpF , ExpGamma , ExpX ] = temp_maximal_elt.refine( st_oneD , Cover , ExpF , ExpGamma , ExpX )
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Function Definitions %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [next_states] = one_dim_example_transition(x,u)
% 	%Description:
% 	%	For the simple one dimensional example:
% 	%	- increments the state x by 1 if the input is 1 and
% 	%	- decrements the state x by 1 if the input is 2.
% 	%	Implement a simple dynamics map for the two inputs available to the one dimensional example.
% 	%

% 	%% Input Processing %%
	
% 	if isscalar(x)
% 		if (abs(x) > 2)
% 			error(['The value of the state x must satisfy |x|<= 2. Received ' num2str(x) '.' ])
% 		end
% 	elseif isa(x,'Polyhedron')
% 		if x.Dim ~= 1
% 			error('Expected one-dimensional polyhedron as input.')
% 		end
% 	else
% 		error('Unexpected input type')
% 	end

% 	%% Algorithm %%

% 	%For scalars
% 	if isscalar(x)
% 		switch u
% 			case 1
% 				next_states = Polyhedron('lb',x+1,'ub',x+1);
% 			case 2
% 				next_states = Polyhedron('lb',x-1,'ub',x-1);
% 			otherwise
% 				error(['There should only be two inputs for the system. Received u =' num2str(u) '.' ])
% 		end
% 	end

% 	if isa(x,'Polyhedron')
% 		switch u
% 			case 1
% 				next_states = x + 1;
% 			case 2
% 				next_states = x - 1;
% 			otherwise
% 				error(['Unexpected input: ' num2str(u) ])
% 		end
% 	end


% end