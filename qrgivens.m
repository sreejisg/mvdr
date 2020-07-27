%  qrgivens.m

%function [Q,R] = qrgivens(A)
clear
A=[1 2 8; 3 5 6; 4 3 9; 3 4 7];
  [m,n] = size(A);
  
  R = A;
  Q = eye(m);
  for j = 1:n
    for i = m:-1:(j+1)
      G = eye(m);
      [c,s] = givensrotation( R(i-1,j),R(i,j) );
      G([i-1, i],[i-1, i]) = [c -s; s c];
      R = G'*R;
      Q = Q*G;
    end
  end
% end


% givensrotation.m

function [c,s] = givensrotation(a,b)
  if b == 0
    c = 1;
    s = 0;
  else
    if abs(b) > abs(a)
      r = a / b;
      s = 1 / sqrt(1 + r^2);
      c = s*r;
    else
      r = b / a;
      c = 1 / sqrt(1 + r^2);
      s = c*r;
    end
  end
end

