function x=sr(a,b,h,x0)
x=zeros(1,length(x0));
% for i=1:length(x0)-1
%     k1=h*(a*x(i)-b*x(i).^3+x0(i));
%     k2=h*(a*(x(i)+k1/2)-b*(x(i)+k1/2).^3+x0(i));
%     k3=h*(a*(x(i)+k2/2)-b*(x(i)+k1*(sqrt(2)-1)/2+k2*(2-sqrt(2))/2).^3+x0(i+1));
%     k4=h*(a*(x(i)+k3)-b*(x(i)-k2*sqrt(2)/2+k3*(2+sqrt(2))/2).^3+x0(i+1));
%     x(i+1)=x(i)+(1/6)*(k1+(2-sqrt(2))*k2+(2+sqrt(2))*k3+k4);
% end
for i=1:length(x0)-1
    k1=h*(a*x(i)-b*x(i).^3+x0(i));
    k2=h*(a*(x(i)+k1/2)-b*(x(i)+k1/2).^3+x0(i));
    k3=h*(a*(x(i)+k2/2)-b*(x(i)+k2/2).^3+x0(i+1));
    k4=h*(a*(x(i)+k3)-b*(x(i)+k3).^3+x0(i+1));
    x(i+1)=x(i)+(1/6)*(k1+2*k2+2*k3+k4);
end