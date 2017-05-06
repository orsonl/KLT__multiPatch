function [ affineLKContext ] = AffineLKTrackerInit(template)
[h,w]=size(template);
a_I=sum(sum(template))/numel(template);
[X,Y]=meshgrid(1:w,1:h);
[Gx,Gy]=gradient(template);
%% build jacobian for visualization. All of this part can be commented out in the real run.
% jacobian=zeros(h,w,6);
% jacobian(:,:,1)=Gx.*X;
% jacobian(:,:,2)=Gy.*X;
% jacobian(:,:,3)=Gx.*Y;
% jacobian(:,:,4)=Gy.*Y;
% jacobian(:,:,5)=Gx;
% jacobian(:,:,6)=Gy;
% 
% figure(2)
% subplot(1,6,1);
% imagesc(jacobian(:,:,1));
% subplot(1,6,2);
% imagesc(jacobian(:,:,2));
% subplot(1,6,3);
% imagesc(jacobian(:,:,3));
% subplot(1,6,4);
% imagesc(jacobian(:,:,4));
% subplot(1,6,5);
% imagesc(jacobian(:,:,5));
% subplot(1,6,6);
% imagesc(jacobian(:,:,6));
%% Jocobian 
j1=Gx.*X;
j2=Gy.*X;
j3=Gx.*Y;
j4=Gy.*Y;
j5=Gx;
j6=Gy;
J=[j1(:) j2(:) j3(:) j4(:) j5(:) j6(:)];
J=reshape(J,h,numel(J)/h);
%% Hessian
%inv_H=hessianBuilder(J);
H=hessian(J,6,w);
inv_H=inv(H);
%% build struct 
field1='Jacobian'; value1=J;
field2='Inverse_Hessian';value2=inv_H;
field3='average_illumination';value3=a_I;
affineLKContext=struct(field1,value1,field2,value2,field3,value3);
end
%% helper functions
% function [jacobian]=jacobianBuilder(Gx,Gy,X,Y) %#ok<*FNDEF>
% jacobian=[Gx*X,Gy*X,Gx*Y,Gy*Y,Gx,Gy];
% end
% function[inv_H]=hessianBuilder(j)
% j=cell2mat(j);
% hessian=j'*j;
% inv_H = inv(hessian);
% end

