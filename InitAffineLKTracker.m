function [affineLKContext] = InitAffineLKTracker(template)
[h,w]=size(template);
a_I=sum(sum(template))/numel(template);
[Gx,Gy]=gradient(template);
dW_dp=jacobian_a(w,h);
VT_dW_dp=sd_images(dW_dp,Gx,Gy,6,h,w);
H=hessian(VT_dW_dp,6,w);
H_inv=inv(H);

figure(2)
imagesc(VT_dW_dp)

field1='Jacobian'; value1=VT_dW_dp;
field2='Inverse_Hessian';value2=H_inv;
field3='average_illumination';value3=a_I;
affineLKContext=struct(field1,value1,field2,value2,field3,value3);
end

