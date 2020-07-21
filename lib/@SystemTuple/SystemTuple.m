classdef SystemTuple
	%Description:
	%	This object is meant to be a container for the 'System' object defined in
	%	'On Abstraction-Based Controller Design With Output Feedback'

	properties
		X;
		X0;
		numU;
		F;
		numY;
		H;
		YLabels;
	end

	methods
		function st = SystemTuple( varargin )
			%Description:
			%
			%Usage:
			%	S = SystemTuple(X,X0,U,F,Y,H)
			%	S = SystemTuple(X,X0,U,F,Y,H,'Don''t Check Inputs')
			%	S = SystemTuple(X,X0,U,F,Y,H,'YLabels',labels_cell_arr)

			%% Input Processing

			if nargin <6
				error(['Not enough input arguments! Received ' num2str(nargin) '!' ])
			end

			X = varargin{1};
			X0 = varargin{2};
			numU = varargin{3};
			F = varargin{4};
			numY = varargin{5};
			H = varargin{6};

			arg_idx = 7;
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

			%% Constants

			%% Algorithm

			st.X = X;
			st.X0 = X0;
			st.numU = numU;
			st.F = F;
			st.numY = numY;
			st.H = H;

			if exist('ylabels_cell_arr')
				st.YLabels = ylabels_cell_arr;
			else
				st.YLabels = {};
			end

		end

	end

end