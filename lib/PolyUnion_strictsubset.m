function tf = PolyUnion_strictsubset( pu1 , pu2 )
	%Description:
	%	Returns true if PolyUnion pu1 is a strict subset of PolyUnion pu2

	%% Input Processing 

	if ~isa(pu1,'PolyUnion')
		error(['First input must be a PolyUnion object. Detected class: ' class(pu1) ])
	end

	if ~isa(pu2,'PolyUnion')
		error(['Second input must be a PolyUnion object! Detected class: ' class(pu2) ])
	end

	%% Algorithm

	tf = (pu1 <= pu2) && ~(pu1 == pu2);

end
