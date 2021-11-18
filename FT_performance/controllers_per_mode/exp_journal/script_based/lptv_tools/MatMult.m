function Y = MatMult(X,n,m)
%return matrix multiplication of matrices in cell structure B
Y = eye(size(X{1}));

for i = n:m
    Y = X{i}*Y;
end
end