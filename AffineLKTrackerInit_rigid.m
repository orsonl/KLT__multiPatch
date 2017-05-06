function [ affineLKContext ] = AffineLKTrackerInit_rigid(template)
[h,w]=size(template);
a_I=sum(sum(template))/numel(template);
[X,Y]=meshgrid(1:w,1:h);
[Gx,Gy]=gradient(template);
%% Jocobian 
j1=Gy.*X-Gx.*Y;
j2=Gx;
j3=Gy;
J=[j1 j2 j3];
%J=reshape(J,h,numel(J)/h);
% figure;
% imagesc(J);
%% Hessian
%inv_H=hessianBuilder(J);
H=hessian(J,3,w);
inv_H=inv(H);
%% build struct 
field1='Jacobian'; value1=J;
field2='Inverse_Hessian';value2=inv_H;
field3='average_illumination';value3=a_I;
affineLKContext=struct(field1,value1,field2,value2,field3,value3);
end


