clear all
close all
clc

pname_SPF   = '/home/jspark/Documents/work/prjResidualStress/3D.MultiscaleCode3.Ti811/Final_SPF';
angle_pos   = [0 90]';
radial_pos  = 1:1:21;

na  = length(angle_pos);
nr  = length(radial_pos);

LSRange = [0 0];
for i = 1:1:na
    for j = 1:1:nr
        fname_SPF   = ['Alp', num2str(angle_pos(i)), ...
            '_pos', num2str(radial_pos(j)), ...
            'LP2smooth.res.mat'];
        pfname  = fullfile(pname_SPF, fname_SPF);
        SPFData = load(pfname);
        
        %%%%%%%%%%%%%%%%%%%%%%
        %%% 110
        q   = SPFData.r110(:,1:3);
        LS  = SPFData.r110(:,4);
        
        if angle_pos(i) == 0
            idx = find(q(:,2) == 0);
        elseif angle_pos(i) == 90
            idx = find(q(:,2) == 0);
        else
            disp('omg angle not considered')
        end
        LS110{i,j}  = [q(idx,:) LS(idx,:)];
        
        if min(LS(idx,:)) < LSRange(1)
            LSRange(1) = min(LS(idx,:));
        end
        if max(LS(idx,:)) > LSRange(2)
            LSRange(2)  = max(LS(idx,:));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%
        %%% 112
        q   = SPFData.r112(:,1:3);
        LS  = SPFData.r112(:,4);
        
        if angle_pos(i) == 0
            idx = find(q(:,2) == 0);
        elseif angle_pos(i) == 90
            idx = find(q(:,2) == 0);
        else
            disp('omg angle not considered')
        end
        LS112{i,j}  = [q(idx,:) LS(idx,:)];
        
        if min(LS(idx,:)) < LSRange(1)
            LSRange(1) = min(LS(idx,:));
        end
        if max(LS(idx,:)) > LSRange(2)
            LSRange(2)  = max(LS(idx,:));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMPUTE SIGMAXX, SIGMAYY FROM SIN2PSI
ndiv    = 1000;
qsym    = HexSymmetries;

E_hkl   = 120e3;    % MPa (BULK)
nu_hkl  = 0.32;

S1  = -nu_hkl/E_hkl;
S2  = 2*(1 + nu_hkl)/E_hkl;

p   = [ ...
    1 0 0; ...
    ]';
for j = 1:1:nr
    for i = 1:1:na
        %%%%%%%%%%%%%%%%%%%%%%
        %%% 110
        q   = LS110{i,j}(:,1:3);
        LS  = LS110{i,j}(:,4);
        sin2psi = 1 - q(:,3).^2;
        
        p110{i,j}   = polyfit(sin2psi, LS, 1);
        p110ft{i,j} = polyfit(sin2psi(1:4:end), LS(1:4:end), 1);
        
        idx = sin2psi < 0.6;
        p110ft2{i,j}    = polyfit(sin2psi(idx), LS(idx), 1);
        
        sx110(i,j)      = p110{i,j}(1)*E_hkl/(1 + nu_hkl);
        sy110(i,j)      = -p110{i,j}(2)*E_hkl/nu_hkl-sx110(i,j);
        sxft110(i,j)    = p110ft{i,j}(1)*E_hkl/(1 + nu_hkl);
        syft110(i,j)    = -p110ft{i,j}(2)*E_hkl/nu_hkl-sxft110(i,j);
        sx110ft2(i,j)   = p110ft2{i,j}(1)*E_hkl/(1 + nu_hkl);
        sy110ft2(i,j)   = -p110ft2{i,j}(2)*E_hkl/nu_hkl-sx110ft2(i,j);
        
        %%%%%%%%%%%%%%%%%%%%%%
        %%% 112
        q   = LS112{i,j}(:,1:3);
        LS  = LS112{i,j}(:,4);
        sin2psi = 1 - q(:,3).^2;
        
        p112{i,j}   = polyfit(sin2psi, LS, 1);
        p112ft{i,j} = polyfit(sin2psi(1:4:end), LS(1:4:end), 1);
        
        idx = sin2psi < 0.6;
        p112ft2{i,j}    = polyfit(sin2psi(idx), LS(idx), 1);
        
        sx112(i,j)      = p112{i,j}(1)*E_hkl/(1 + nu_hkl);
        sy112(i,j)      = -p112{i,j}(2)*E_hkl/nu_hkl-sx112(i,j);
        sxft112(i,j)    = p112ft{i,j}(1)*E_hkl/(1 + nu_hkl);
        syft112(i,j)    = -p112ft{i,j}(2)*E_hkl/nu_hkl-sxft112(i,j);
        sx112ft2(i,j)   = p112ft2{i,j}(1)*E_hkl/(1 + nu_hkl);
        sy112ft2(i,j)   = -p112ft2{i,j}(2)*E_hkl/nu_hkl-sx112ft2(i,j);
    end
end

DataRange(1)    = min([ ...
    sx110(:); sxft110(:); sx110ft2(:); ...
    sx112(:); sxft112(:); sx112ft2(:); ...
    sy110(:); syft110(:); sy110ft2(:); ...
    sy112(:); syft112(:); sy112ft2(:); ...
    ]);
DataRange(2)    = max([ ...
    sx110(:); sxft110(:); sx110ft2(:); ...
    sx112(:); sxft112(:); sx112ft2(:); ...
    sy110(:); syft110(:); sy110ft2(:); ...
    sy112(:); syft112(:); sy112ft2(:); ...
    ]);

r_dvc   = [6.5000 6.6350 6.7770 6.9300 7.0950 7.2700 7.4600 7.6650 7.8900 8.1300 ...
    8.4100 8.7100 9.0500 9.4200 9.8500 10.3500 10.9500 11.6500 12.5500 ...
    13.6000 15.0500];

%%% LOAD MLS SOLUTION
load('../Ti811.SH.MLS.1,0.01,0.01,6.mat');  %% VARIABLE NAME IS SH
load ../meshdata.mat
load('../SOLUTION/Ti811.N.mat')
load('../SOLUTION/Ti811.DV.GRID.mat')

%%% EVALUATE S AT DVC
S   = SH(1:numnp*6,1);
S   = reshape(S,6,numnp); % 11, 22, 33, 23, 13, 12
Sxx = S(1,:);
Syy = S(2,:);
sx	= zeros(2,length(r_dvc));
sy  = zeros(2,length(r_dvc));

x   = x(:);
y   = y(:);
z   = z(:);
xyz     = [x y z];
el_dvc  = zeros(ndv,1); 
for i = 1:1:ndv
    for j = 1:1:numel
        max_x   = max(x(np(j,:)));
        min_x   = min(x(np(j,:)));
        
        max_y   = max(y(np(j,:)));
        min_y   = min(y(np(j,:)));
        
        max_z   = max(z(np(j,:)));
        min_z   = min(z(np(j,:)));
        
        xflag   = dvc_x(i) <= max_x && dvc_x(i) >= min_x;
        yflag   = dvc_y(i) <= max_y && dvc_y(i) >= min_y;
        zflag   = dvc_z(i) <= max_z && dvc_z(i) >= min_z;
        
        if xflag && yflag && zflag
            el_dvc(i)	= j;
            break
        end
    end
end
plot3(x,y,z, 'k.')
hold on

idx = 1:1:21;
for i = 1:1:21
    np_dvc  = np(el_dvc(idx(i)),:);
    plot3(dvc_x(idx(i)), dvc_y(idx(i)), dvc_z(idx(i)), 'r.')
    plot3(x(np_dvc([5,8])), y(np_dvc([5,8])), z(np_dvc([5,8])), 'bo')
    
    r   = x(np_dvc([5,8])).*x(np_dvc([5,8])) + y(np_dvc([5,8])).*y(np_dvc([5,8]));
    r   = sqrt(r);
    dr  = r(2) - r(1);
    dr1 = (r_dvc(i) - r(1))/dr;
    dr2 = (r(2) - r_dvc(i))/dr;
    
    sx(1,i) = Sxx(1,np_dvc(5))*dr2 + Sxx(1,np_dvc(8))*dr1;
    sy(1,i) = Syy(1,np_dvc(5))*dr2 + Syy(1,np_dvc(8))*dr1;
end

idx = 85:1:105;
for i = 1:1:21
    np_dvc  = np(el_dvc(idx(i)),:);
    plot3(dvc_x(idx(i)), dvc_y(idx(i)), dvc_z(idx(i)), 'r.')
    plot3(x(np_dvc([6,7])), y(np_dvc([6,7])), z(np_dvc([6,7])), 'bo')
    
    r   = x(np_dvc([6,7])).*x(np_dvc([6,7])) + y(np_dvc([6,7])).*y(np_dvc([6,7]));
    r   = sqrt(r);
    dr  = r(2) - r(1);
    dr1 = (r_dvc(i) - r(1))/dr;
    dr2 = (r(2) - r_dvc(i))/dr;
    
    sx(2,i) = Sxx(1,np_dvc(5))*dr2 + Sxx(1,np_dvc(8))*dr1;
    sy(2,i) = Syy(1,np_dvc(5))*dr2 + Syy(1,np_dvc(8))*dr1;
end

for i = 1:1:2
    fig = figure(1);
    orient rotated
    % set(fig, 'position', [1681 27 1280 940], ...
    %     'PaperOrientation', 'portrait')
    
    subplot(2,2,1+2*(i-1))
%     plot(r_dvc,sx110(i,:), 'v', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'b', ...
%         'MarkerFaceColor', 'b')
    hold on
%     plot(r_dvc,sxft110(i,:), '^', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'r', ...
%         'MarkerFaceColor', 'r')
    plot(r_dvc,sx110ft2(i,:), 'o', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'k')
%     plot(r_dvc,sy110(i,:), 'v', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'b', ...
%         'MarkerFaceColor', 'none')
%     plot(r_dvc,syft110(i,:), '^', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'r', ...
%         'MarkerFaceColor', 'none')
    plot(r_dvc,sy110ft2(i,:), 'o', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'none')
    plot(r_dvc,sx(i,:), 's', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'k')
    plot(r_dvc,sy(i,:), 's', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'none')
    axis([min(r_dvc) max(r_dvc) DataRange])
    title(['\{11.0\}'])
    xlabel('radial position (mm)')
    ylabel('stress (MPa)')
    grid on
    legend({'xx-sin^2\psi'; 'yy-sin^2\psi'; 'xx-BSOS'; 'yy-BSOS'}, ...
        'Location', 'southeast')
    
    subplot(2,2,2+2*(i-1))
%     plot(r_dvc,sx112(i,:), 'v', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'b', ...
%         'MarkerFaceColor', 'b')
    hold on
%     plot(r_dvc,sxft112(i,:), '^', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'r', ...
%         'MarkerFaceColor', 'r')
    plot(r_dvc,sx112ft2(i,:), 'o', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'k')
%     plot(r_dvc,sy112(i,:), 'v', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'b', ...
%         'MarkerFaceColor', 'none')
%     plot(r_dvc,syft112(i,:), '^', ...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor', 'r', ...
%         'MarkerFaceColor', 'none')
    plot(r_dvc,sy112ft2(i,:), 'o', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'none')
    plot(r_dvc,sx(i,:), 's', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'k')
    plot(r_dvc,sy(i,:), 's', ...
        'MarkerSize', 8, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'none')
    axis([min(r_dvc) max(r_dvc) DataRange])
    title(['\{11.2\}'])
    xlabel('radial position (mm)')
    ylabel('stress (MPa)')
    grid on
    legend({'xx-sin^2\psi'; 'yy-sin^2\psi'; 'xx-BSOS'; 'yy-BSOS'}, ...
        'Location', 'southeast')
end

save('MLS.Stress.mat', 'sx', 'sy', 'r_dvc')