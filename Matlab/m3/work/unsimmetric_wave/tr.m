a(1:10) = 1;
a = A(a);

function a = A(a)
a(2) = 2;
a = B(a);
end

function a = B(a)
a(3) = 3;
end

