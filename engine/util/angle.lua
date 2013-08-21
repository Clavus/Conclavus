
angle = {}

function angle.forward( r )

	return Vector( math.cos(r), math.sin(r) )
	
end

function angle.rotate( self, r )

	return math.normalizeAngle(self + r)
	
end
