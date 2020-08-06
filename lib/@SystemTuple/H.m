function [output_set] = H( obj , x )
	%Description:
	%	Determines the output when given an input point or set (Polyhedron,PolyUnion).

	%% Constants

	%% Algorithm
	output_set = [];

	for hi_idx = 1:length(obj.HInverse)
		%Check for containment of each of the elements.
		switch class(obj.HInverse)
			case {'Polyhedron','PolyUnion'}
				if obj.HInverse(hi_idx).contains( x )
					output_set = [ output_set , hi_idx ];
				end
			case 'cell'
				if any(x == obj.HInverse(hi_idx))
					output_set = [output_set , hi_idx ];
				end
			otherwise
				error(['Unexpected type for HInverse field: ' class(obj.HInverse)])
		end

	end

end