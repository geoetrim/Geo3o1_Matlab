function Qxx_cholesky_ters = cholesky_ters(A)

n = length(A(1 , :));

for i = 1 : n
    if i == 1
        c(i , i) = sqrt(A(i , i));
        c(i , 2 : n) = A(i , 2 : n) / c(i , i);
    elseif i > 1
        c(i , i) = sqrt(A(i , i) - sum(c(1 : i - 1 , i).* c(1 : i - 1 , i))); 
        for j = i + 1 : n   
            c(i , j) = (A(i , j) - sum(c(1 : i - 1 , i).* c(1 : i - 1 , j))) / c(i , i);  
        end
    end
end
Qxx_cholesky_ters = inv(c) * inv(c)';