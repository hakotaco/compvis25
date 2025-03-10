function [D] = windowing(Ia, Ib, r)
	[h w ~] = size(Ia);

	D = zeros(h, w);

	idxs = -r:r;

	for ay = (r+1):(h-r)
		ay
		for ax =(r+1):(w-r)
			Wa = Ia(idxs+ay, idxs+ax, :);
			bwd = Inf; bwx = ax; bwy = ay;

			by = ay;
			for bx = (r+1):ax
				Wb = Ib(idxs+by, idxs+bx, :);
				d = sum((Wa - Wb).^2, "all");
				if d < bwd 
					bwd = d;
					bwx = bx;
					bwy = by;
				end
			end

			sx = bwx - ax;
			sy = bwy - ay;
			D(ay,ax) = sqrt(sx^2 + sy^2); 
		end
	end
	
