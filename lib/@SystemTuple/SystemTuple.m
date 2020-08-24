classdef SystemTuple
	%Description:
	%	This object is meant to be a container for the 'System' object defined in
	%	'On Abstraction-Based Controller Design With Output Feedback'
	%
	%Properties
	%	X
	%	X0
	%	DynList
	%	H
	%	YLabels
	%
	%Methods
	%	SystemTuple
	%	nu
	%	ny
	%	pre
	%	pre_input_dependent
	%	F
	%	H
	%	KAM

	properties
		X;
		X0;
		HInverse;
		YLabels;
		%Define Continuous Linear Dynamics, if specified.
		DynList;
		%Define Discrete Transitions in a sparse way, if specified.
		x0;
		u0;
		x1;
	end

	properties(SetAccess=protected)
		hasDiscreteDynamics = false;
		hasLinearDynamics = false;
	end

	methods
		function st = SystemTuple( varargin )
			%Description:
			%
			%Usage:
			%	S = SystemTuple(X,X0,HInverse)
			%	S = SystemTuple(X,X0,HInverse,'Don''t Check Inputs')
			%	S = SystemTuple(X,X0,HInverse,'YLabels',labels_cell_arr)
			%	S = SystemTuple(X,X0,HInverse,'DiscreteDynamics',x,u,x_prime)

			%% Input Processing

			if nargin < 5
				error(['Not enough input arguments! Received ' num2str(nargin) '!' ])
			end

			X = varargin{1};
			X0 = varargin{2};
			HInverse = varargin{3};

			arg_idx = 4;
			while arg_idx <= nargin
				switch varargin{arg_idx}
					case 'Don''t Check Inputs'
						PerformInputChecking = false;
						arg_idx = arg_idx + 1;
					case 'YLabels'
						ylabels_cell_arr = varargin{arg_idx+1};
						arg_idx = arg_idx + 2;
					case 'LinearDynamics'
						DynList = varargin{arg_idx+1};
						st.hasLinearDynamics = true;
						arg_idx = arg_idx + 2;
					case {'DiscreteDynamics','DiscreteTransitions'}
						x0 = varargin{arg_idx+1};
						u0 = varargin{arg_idx+2};
						x1 = varargin{arg_idx+3};
						st.hasDiscreteDynamics = true;
						arg_idx = arg_idx + 4;
					otherwise
						error(['Unexpected input to the SystemTuple constructor: ' varargin{arg_idx} '!'])
				end
			end

			if ~exist('PerformInputChecking')
				PerformInputChecking = true;
			end


			if PerformInputChecking

				if ~st.X0_is_subset_of_X( X0 , X )
					error('Initial state set X0 is not a subset of X!')
				end

				if st.hasLinearDynamics
					if ~isa(DynList,'Dyn')
						error('The input DynList must be a list of Dyn() objects.')
					end
				end

			end

			%% Constants

			%% Algorithm

			st.X = X;
			st.X0 = X0;
			st.HInverse = HInverse;

			if exist('ylabels_cell_arr')
				st.YLabels = ylabels_cell_arr;
			else
				st.YLabels = {};
			end

			if st.hasLinearDynamics
				st.DynList = DynList;
			end

			if st.hasDiscreteDynamics
				st.x0 = x0;
				st.u0 = u0;
				st.x1 = x1;
			end

			%% Warnings

			if isa(X,'PolyUnion')
				warning('The SystemTuple object was designed to have a Polyhedron as the domain. Results may vary in quality with PolyUnion input.')
			end

		end

		function tf = X0_is_subset_of_X(obj, X0_candidate , X )
			%Description:
			%	Determines if the set X0 is a subset of the set X.
			%	Sets may be defined as lists of numbers, or PolyUnion objects or Polyhedron object.

			%% Input Processing
			class_x0 = class(X0_candidate);
			class_x = class(X);

			if ~strcmp(class_x,class_x0)
				error(['The two sets are not of the same class! X0 is a ' class_x0 ' object while X is a ' class_x ' object.' ])
			end

			%% Algorithm

			switch class_x
				case {'Polyhedron','PolyUnion'}
					if (length(X0_candidate) == 1) && (length(X) == 1)
						tf = X0_candidate <= X;
					else
						%If X0_candidate and X are arrays, then make sure
						%that each element of X0_candidate is an element
						%of X.
						tf = true;
						for X0_idx = 1:length(X0_candidate)
							X0_elt = X0_candidate(X0_idx);

							X0_elt_in_X = false;
							%Search for a match in X
							for X_idx = 1:length(X)
								X0_elt_in_X = X0_elt_in_X || ( X0_elt <= X(X_idx) );
							end
							tf = X0_elt_in_X & tf;

							%If you find that one element of X0 is not in X
							%then break out of this function and return false.
							if ~tf
								return;
							end

						end
					end
					1;
				case 'double'
					tf = isempty( setdiff(X0_candidate , X) );
				otherwise
					error(['Unexpected class of sets: ' class_x ])
			end


		end

		function num_inputs = nu(obj)
			%Description:
			%	Returns the number of discrete inputs available to the system.
			%
			%Usage:
			%	num_inputs = st.nu()

			%% Constants

			%% Algorithm

			num_inputs = length(obj.DynList);

		end

		function X_pre = pre( obj , X , rho )
			%Description:
			%	Computes the pre of a set X with a "shrinkage" factor rho.
			%	In math, this should find the set of states X such that
			%		X = { x(t+1) + B_0(rho) \in X \forall u }
			%		  = { A x(t) + F + B_0(rho) \in X \forall u }, assuming that only A and F are defined for Dyn
			%
			%Usage:
			%	X_pre = obj.pre( X )
			%	X_pre = obj.pre( X , rho )

			%% Input Processing

			if ~exist('rho')
				rho = 0;
			end

			%% Algorithm

			X_pre_u = [];
			for u = 1:obj.nu()
				X_pre_u = [X_pre_u , obj.DynList(u).pre( X , rho)];
			end

			X_pre = X_pre_u(1);
			for u_idx = 2:obj.nu()
				X_pre = X_pre.intersect( X_pre_u( u_idx ) );
			end

		end

		function X_pre = pre_input_dependent( obj , X_list , rho )
			%Description:
			%	Computes the set of states that can be guaranteed to reach set
			%	X_list(i) for discrete input i with a "shrinkage" factor rho.
			%	In math, this should find the set of states X such that
			%		X = { x(t+1) + B_0(rho) \in X_list(i) }
			%		  = { A_i x(t) + F_i + B_0(rho) \in X_list(i) }, assuming that only A and F are defined for Dyn
			%
			%Assumtions:
			%	- X_list is a cell array.

			%% Input Processing

			if ~exist('rho')
				rho = 0;
			end

			if length(X_list) ~= obj.nu()
				error(['The number of elements in X_list (' num2str(length(X_list)) ...
						') is not equal to the number of inputs to the system (' num2str(obj.nu()) ').'  ])
			end

			if ~iscell(X_list)
				error('The input X_list must be a cell array.')
			end

			for x_list_idx = 1:length(X_list)
				if isempty(X_list{x_list_idx})
					%If anything is empty, then X_pre is an emptyset.
					%Return NaN? or []?
					X_pre = [];
					return
                end
                
                if strcmp(class(X_list{x_list_idx}),'Polyhedron')
                    if X_list{x_list_idx}.isEmptySet
                        X_pre = [];
                        return
                    end
                end
                
			end

			%% Algorithm

			X_pre_u = [];
			for u = 1:obj.nu()
				X_pre_u = [X_pre_u , obj.DynList(u).pre( X_list{u} , rho)];
			end

			X_pre = X_pre_u(1);
			for u_idx = 2:obj.nu()
				if isa(X_pre,'Polyhedron')
					X_pre = X_pre.intersect( X_pre_u( u_idx ) );
				elseif isa(X_pre,'PolyUnion')
					X_pre = IntersectPolyUnion( X_pre , X_pre_u( u_idx ) );
					X_pre.reduce();
				else
					error(['Unexpected class of X_pre: ' class(X_pre)])
				end
			end



		end

		function X_next = F( obj , x , u )
			%Description:
			%	The transition function of the SystemTuple.
			%	Should work equally well for set or numeric inputs.

			%% Input Processing
			if (1 > u) || (obj.nu() < u)
				error(['The input u = ' num2str(u) ' is outside of the allowable range {1,' num2str(obj.nu()) '}.'])
			end

			%% Constants

			dyn_u = obj.DynList(u);

			if ~isempty(dyn_u.Ap) || ~isempty(dyn_u.Ad) || ~isempty(dyn_u.Ev) || ~isempty(dyn_u.Ew)
				error('This function does not currently support dynamics with : ''Ap'',''Ad'',''Ev'',''Ew'' ')
			end

			x_class = class(x);

			%% Algorithm
			switch x_class
				case 'Polyhedron'
					X_next = obj.F_polyhedron( x , u );
					return
				case 'PolyUnion'
					output_sets = [];
					for set_idx = 1:x.Num
						set_i = x.Set(set_idx);
						output_sets = [ output_sets , obj.F( set_i , u ) ];
					end
					X_next = PolyUnion(output_sets);
					X_next.reduce();
				otherwise
					error(['x is of an unexpected type:' x_class])
            end
            
            %Now, intersect output with the domain
            domain_class = class(obj.X);
            if strcmp(domain_class,'Polyhedron') && strcmp(x_class,'Polyhedron')
            	X_next = X_next.intersect( obj.X ); %Make sure that the result is contained in the domain.
            elseif strcmp(domain_class,'PolyUnion' ) && strcmp(x_class,'Polyhedron')
            	temp_Xnext = PolyUnion( X_next );
            	clear X_next
            	X_next = IntersectPolyUnion( temp_Xnext , obj.X );
            elseif strcmp(domain_class,'Polyhedron' ) && strcmp(x_class,'PolyUnion')
                temp_X = PolyUnion(obj.X);
                X_next = IntersectPolyUnion( temp_X , X_next );
            elseif strcmp(domain_class,'PolyUnion') && strcmp(x_class,'PolyUnion')
            	X_next = IntersectPolyUnion( obj.X , X_next );
			else
				error(['The combination of domain with class ' class(obj.X) ' and X_next of class ' class(X_next) ' is not recognized.' ])
			end
		end

		function X_next = F_polyhedron( obj , x , u )
			%Description:
			%	The transition function for the SystemTuple, when:
			%	- the system has linear dynamics and
			%	- x is a polyhedron.
			%	Returns a polyhedron or array of polyhedra.

			%% Input Processing

			%Assume that this was already done.

			%% Constants

			x_class = 'Polyhedron';
			dyn_u = obj.DynList(u);

			%% Algorithm

			X_next = dyn_u.A * x + dyn_u.F;

			%Intersect with the domain.
			domain_class = class(obj.X);
			switch domain_class
				case 'Polyhedron'
					X_next = X_next.intersect( obj.X );
				case 'PolyUnion'
					temp_X = PolyUnion(obj.X);
                	temp_Xnext = IntersectPolyUnion( temp_X , X_next );
                	X_next = temp_Xnext.Set;
				otherwise
					error(['Unexpected type for domain: ' domain_class ])
			end

		end

		function numY = ny(obj)
			%Description:
			%	Returns the number of outputs for the system.
			%	This is implicitly written in the size of the Hinverse field.
			%
			%Usage:
			%	numY = obj.ny()

			numY = length(obj.HInverse);
		end

	end

end