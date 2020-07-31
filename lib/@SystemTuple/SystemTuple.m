classdef SystemTuple
	%Description:
	%	This object is meant to be a container for the 'System' object defined in
	%	'On Abstraction-Based Controller Design With Output Feedback'

	properties
		X;
		X0;
		DynList;
		numY;
		H;
		YLabels;
	end

	methods
		function st = SystemTuple( varargin )
			%Description:
			%
			%Usage:
			%	S = SystemTuple(X,X0,DynList,numY,H)
			%	S = SystemTuple(X,X0,DynList,numY,H,'Don''t Check Inputs')
			%	S = SystemTuple(X,X0,DynList,numY,H,'YLabels',labels_cell_arr)

			%% Input Processing

			if nargin < 5
				error(['Not enough input arguments! Received ' num2str(nargin) '!' ])
			end

			X = varargin{1};
			X0 = varargin{2};
			DynList = varargin{3};
			numY = varargin{4};
			H = varargin{5};

			arg_idx = 6;
			while arg_idx <= nargin
				switch varargin{arg_idx}
					case 'Don''t Check Inputs'
						st.X = X;
						st.X0 = X0;
						st.numU = numU;
						st.F = F;
						st.numY = numY;
						st.H = H;
						return
					case 'YLabels'
						ylabels_cell_arr = varargin{arg_idx+1};
						arg_idx = arg_idx + 2;
					otherwise
						error(['Unexpected input to the SystemTuple constructor: ' varargin{arg_idx} '!'])
				end
			end

			if ~(X0 <= X)
				error('Initial state set X0 is not a subset of X!')
			end

			if ~isa(DynList,'Dyn')
				error('The input DynList must be a list of Dyn() objects.')
			end

			%% Constants

			%% Algorithm

			st.X = X;
			st.X0 = X0;
			st.DynList = DynList;
			st.numY = numY;
			st.H = H;

			if exist('ylabels_cell_arr')
				st.YLabels = ylabels_cell_arr;
			else
				st.YLabels = {};
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

			%% Algorithm

			X_next = dyn_u.A * x + dyn_u.F;

		end

	end

end