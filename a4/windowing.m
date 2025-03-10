function [D] = windowing(Ia, Ib, r)
  if size(Ia, 3) == 3
    Ia = double(rgb2gray(Ia));
    Ib = double(rgb2gray(Ib));
  else
    Ia = double(Ia);
    Ib = double(Ib);
  end

  [h, w, ~] = size(Ia);

  D = zeros(h, w);

  idxs = -r:r;

  for ay = (r+1):(h-r)
    for ax =(r+1):(w-r)
      Wa = Ia(idxs+ay, idxs+ax, :);
      bwd = Inf; bwx = ax; bwy = ay;

            by = ay;
      for bx = ax:-1:max(r+1, ax-30)
        Wb = Ib(idxs+ay, idxs+bx, :);
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
  

