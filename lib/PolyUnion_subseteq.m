function tf = PolyUnion_subseteq( pu1 , pu2 )
	%Description:
	%	Returns true if PolyUnion pu1 is a subset of PolyUnion pu2
	%
	%Notes to self:
	%	It turns out that a subset operator is implemented for PolyUnion objects.
	%	Please use pu1 <= pu2 which is built into MPT3

	%% Input Processing 

	if ~isa(pu1,'PolyUnion')
		error(['First input must be a PolyUnion object. Detected class: ' class(pu1) ])
	end

	if ~isa(pu2,'PolyUnion')
		error(['Second input must be a PolyUnion object! Detected class: ' class(pu2) ])
	end

	%% Algorithm

	temp_union = PolyUnion([pu1.Set,pu2.Set]);

	reduce_out = temp_union.reduce();
	reduce_out_segment1 = reduce_out([1:pu1.Num]);
	reduce_out_segment2 = reduce_out([pu1.Num+1:end]);

	tf = ~any( reduce_out_segment1 );

end
