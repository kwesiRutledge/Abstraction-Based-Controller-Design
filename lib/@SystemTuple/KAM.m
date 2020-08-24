function [S_hat] = KAM( varargin )
	%Description:
	%	Implementation of the Knowledge Abstraction and Minimization algorithm (Algorithm 2 from Majumdar, Ozay and Schmuck 2020)
	%	
	%Usage:
	%	[S_hat] = st.KAM()
	%	[S_hat] = st.KAM( ... , 'MaximumIterations' , MaximumIterations )
	%	[S_hat] = st.KAM( ... , 'Debug' , tf )
	%
	%Inputs:
	%


	%% Input Processing %%

	st = varargin{1};

	if isa(st.X,'Polyhedron') && isa(st.X0,'Polyhedron') && isa(st.HInverse(1),'Polyhedron')
		S_hat = KAM_Polyhedron( varargin{:} );
	elseif isa(st.HInverse(1),'PolyUnion')
		S_hat = KAM_PolyUnion( varargin{:} );
	else
		error('Expected Hinv(1) to be a Polyhedron or PolyUnion object. When in doubt, choose PolyUnion.')
	end

end 

function [S_hat] = KAM_PolyUnion( varargin )
	%Description:
	%	Implementation of the Knowledge Abstraction and Minimization algorithm (Algorithm 2 from Majumdar, Ozay and Schmuck 2020)
	%	Assumes that all sets are defined as PolyUnion objects.
	%	Uses the type of Hinv to detect this.
	%	
	%Usage:
	%	[S_hat] = st.KAM()
	%	[S_hat] = st.KAM( ... , 'MaximumIterations' , MaximumIterations )
	%	[S_hat] = st.KAM( ... , 'Debug' , tf )
	%
	%Inputs:
	%


	%% Input Processing %%

	st = varargin{1};

	argidx = 2;
	while argidx <= nargin
		switch varargin{argidx}
			case 'MaximumIterations'
				MaximumIterations = varargin{argidx + 1};
				argidx = argidx + 2;
			case 'CheckCoverConvergence'
				CheckCoverConvergence = varargin{argidx + 1};
				argidx = argidx + 2;
			case 'Debug'
				Debug = varargin{argidx+1};
				argidx = argidx + 2;
			otherwise
				error(['Unexpected input to KAM: ' varargin{argidx} ])
		end
	end

	if ~isa(st.HInverse(1),'PolyUnion')
		error(['This function is currently designed to support Hinv which are an array of PolyUnion objects. Received an array of ' class(Hinv) 'objects.'])
	end

	%% Constants

	if ~exist('Debug')
		Debug = false;
	end

	%% Algorithm %%

	%%%%%%%%%%%%%%%%%%%%
	%% Initialization %%
	%%%%%%%%%%%%%%%%%%%%

	Cover0 = st.HInverse;
	ExpGamma0 = [];

	ExpX0 = [];
	for cover_elt_idx = 1:length(Cover0)
		%Check if Cover0(cover_elt_idx) intersected with X0 is nonempty
		cover_elt = Cover0(cover_elt_idx);
		intersected = IntersectPolyUnion(cover_elt,st.X0);
		intersected.reduce();
		intersection_is_empty = (length(intersected.Set) == 0);

		if intersection_is_empty
			continue;
		end

		temp_tuple = ExpXElement( cover_elt_idx , Cover0(cover_elt_idx) , Cover0(cover_elt_idx) );

		%Add to ExpX0;
		ExpX0 = [ExpX0,temp_tuple];
	end

	ExpF0 = [];

	%%%%%%%%%%%%%%%
	%% Main Loop %%
	%%%%%%%%%%%%%%%

	ExpX = ExpX0;
	ExpF = ExpF0;
	CoverSequence{1} = Cover0;
	Cover = Cover0;
	ExpGamma = ExpGamma0;

	curr_iter = 0;
	loop_condition = true;

	while loop_condition
		ExpGamma = EXPX_to_EXP_Gamma( ExpX );
		maximal_subset_ExpX = get_expx_elts_with_maximal_cardv( ExpX );
		for maximal_elt_idx = 1:length(maximal_subset_ExpX)
			temp_maximal_elt = maximal_subset_ExpX(maximal_elt_idx);

			for u = 1:st.nu()
				for y = 1:st.ny()
					v_prime = [ temp_maximal_elt.v , u , y ];
					c_prime = IntersectPolyUnion(st.F( temp_maximal_elt.c , u ), st.HInverse(y) );
					Q_prime = get_minimal_covering_subsets_for( c_prime , Cover );

					for q_prime_idx = 1:length(Q_prime)
						q_prime = Q_prime(q_prime_idx);
						temp_expx_elt = ExpXElement( v_prime , q_prime , c_prime );
						
						%Update ExpX
						ExpX = temp_expx_elt.union_with_set( ExpX );

						%Update EXPF
						temp_expf_elt = ExpFElement( temp_maximal_elt , u , temp_expx_elt );
						ExpF = temp_expf_elt.union_with_set( ExpF );
					end

				end
			end

			%possibly refine.
			if PolyUnion_strictsubset(temp_maximal_elt.c , temp_maximal_elt.q)
				[ Cover , ExpF , ExpGamma , ExpX ] = temp_maximal_elt.refine( st , Cover , ExpF , ExpGamma , ExpX );
			end

		end

		%Update loop condition.
		curr_iter = curr_iter + 1;
		if exist('MaximumIterations')
			loop_condition = loop_condition && (curr_iter < MaximumIterations);
		end

		%Update CoverSequence
		CoverSequence{curr_iter+1} = Cover;
		if CheckCoverConvergence && (curr_iter > 1)
			loop_condition = loop_condition && ...
				(~PolyUnionarrays_equal( CoverSequence{curr_iter} , CoverSequence{curr_iter+1} ));
		end

		%Debugging Info
		if Debug
			disp(['- Iteration #' num2str(curr_iter) ])
			disp(['  + length(Cover) = ' num2str(length(Cover)) ])
			disp(['  + length(ExpX) = ' num2str(length(ExpX)) ])
			disp(['  + length(ExpF) = ' num2str(length(ExpF)) ])
			disp(['  + length(ExpGamma) = ' num2str(length(ExpGamma)) ])
		end

	end

	S_hat = extract_ets( ExpX , ExpF , st );


end 

function [S_hat] = KAM_Polyhedron( varargin )
	%Description:
	%	Implementation of the Knowledge Abstraction and Minimization algorithm (Algorithm 2 from Majumdar, Ozay and Schmuck 2020)
	%	
	%Usage:
	%	[S_hat] = st.KAM( )
	%	[S_hat] = st.KAM( ... , 'MaximumIterations' , MaximumIterations )
	%	[S_hat] = st.KAM( ... , 'Debug' , tf )
	%
	%Inputs:
	%	Hinv: A st.numY x 1 array of PolyUnion or Polyhedra objects.
	%		  Defines the mapping from measurements to the set of states that correspond to it.
	%		  Recall that observarions are finite and should be represented by a number in the
	%		  range {1,...,st.numY}.
	%		  Therefore, Hinv{1} = PolyUnion( ... ) = H^{-1}(observation_1)
	%


	%% Input Processing %%

	st = varargin{1};

	argidx = 2;
	while argidx <= nargin
		switch varargin{argidx}
			case 'MaximumIterations'
				MaximumIterations = varargin{argidx + 1};
				argidx = argidx + 2;
			case 'CheckCoverConvergence'
				CheckCoverConvergence = varargin{argidx + 1};
				argidx = argidx + 2;
			case 'Debug'
				Debug = varargin{argidx+1};
				argidx = argidx + 2;
			otherwise
				error(['Unexpected input to KAM: ' varargin{argidx} ])
		end
	end

	%This check is no longer necessary because it is tested in the main,
	%KAM function.

	% if ~isa(Hinv(1),'Polyhedron')
	% 	error(['This function is currently designed to support Hinv which are an array of Polyhedron objects. Received an array of ' class(Hinv) 'objects.'])
	% end

	%% Constants

	if ~exist('Debug')
		Debug = false;
	end

	if ~exist('CheckCoverConvergence')
		CheckCoverConvergence = true;
	end

	%% Algorithm %%

	%%%%%%%%%%%%%%%%%%%%
	%% Initialization %%
	%%%%%%%%%%%%%%%%%%%%

	Cover0 = st.HInverse;
	ExpGamma0 = [];

	ExpX0 = [];
	for cover_elt_idx = 1:length(Cover0)
		%Check if Cover0(cover_elt_idx) intersected with X0 is nonempty
		cover_elt = Cover0(cover_elt_idx);
		intersected = cover_elt.intersect(st.X0);

		if intersected.isEmptySet || (intersected.volume == 0)
			continue;
		end

		temp_tuple = ExpXElement( cover_elt_idx , Cover0(cover_elt_idx) , Cover0(cover_elt_idx) );

		%Add to ExpX0;
		ExpX0 = [ExpX0,temp_tuple];
	end

	ExpF0 = [];
    
    curr_iter = 0;
    
    %Debugging Info
    if Debug
        disp(['- Iteration #' num2str(curr_iter) ])
        disp(['  + length(Cover) = ' num2str(length(Cover0)) ])
        disp(['  + length(ExpX) = ' num2str(length(ExpX0)) ])
        disp(['  + length(ExpF) = ' num2str(length(ExpF0)) ])
        disp(['  + length(ExpGamma) = ' num2str(length(ExpGamma0)) ])
    end
    
	%%%%%%%%%%%%%%%
	%% Main Loop %%
	%%%%%%%%%%%%%%%

	ExpX = ExpX0;
	ExpF = ExpF0;
	CoverSequence{1} = Cover0;
	Cover = Cover0;
	ExpGamma = ExpGamma0;

	loop_condition = true;

	while loop_condition
		ExpGamma = EXPX_to_EXP_Gamma( ExpX );
		maximal_subset_ExpX = get_expx_elts_with_maximal_cardv( ExpX );
		for maximal_elt_idx = 1:length(maximal_subset_ExpX)
			temp_maximal_elt = maximal_subset_ExpX(maximal_elt_idx);

			for u = 1:st.nu()
				for y = 1:st.ny()
					v_prime = [ temp_maximal_elt.v , u , y ];
					c_prime = st.F( temp_maximal_elt.c , u );
					c_prime = c_prime.intersect( st.HInverse(y) );

					%Skip this loop if c_prime is empty?
					if (c_prime.isEmptySet) || (c_prime.volume == 0)
						continue;
					end

					Q_prime = get_minimal_covering_subsets_for( c_prime , Cover );

					for q_prime_idx = 1:length(Q_prime)
						q_prime = Q_prime(q_prime_idx);
						temp_expx_elt = ExpXElement( v_prime , q_prime , c_prime );
						
						%Update ExpX
						ExpX = temp_expx_elt.union_with_set( ExpX );

						%Update EXPF
						temp_expf_elt = ExpFElement( temp_maximal_elt , u , temp_expx_elt );
						ExpF = temp_expf_elt.union_with_set( ExpF );
					end

				end
            end
            
            %possibly refine.
			if (temp_maximal_elt.c <= temp_maximal_elt.q) && (temp_maximal_elt.c ~= temp_maximal_elt.q)
				[ Cover , ExpF , ExpGamma , ExpX ] = temp_maximal_elt.refine( st , Cover , ExpF , ExpGamma , ExpX );
			end
            
        end

		%Update loop condition.
		curr_iter = curr_iter + 1;
		if exist('MaximumIterations')
			loop_condition = loop_condition && (curr_iter < MaximumIterations);
		end

		%Update CoverSequene
		CoverSequence{curr_iter+1} = Cover;
		if CheckCoverConvergence && (curr_iter > 1)
			loop_condition = loop_condition && ...
				(~PolyUnionarrays_equal( CoverSequence{curr_iter} , CoverSequence{curr_iter+1} ));
		end

		%Debugging Info
		if Debug
			disp(['- Iteration #' num2str(curr_iter) ])
			disp(['  + length(Cover) = ' num2str(length(Cover)) ])
			disp(['  + length(ExpX) = ' num2str(length(ExpX)) ])
			disp(['  + length(ExpF) = ' num2str(length(ExpF)) ])
			disp(['  + length(ExpGamma) = ' num2str(length(ExpGamma)) ])
		end

	end

	S_hat = st.extract_ets( ExpX , ExpF );


end 