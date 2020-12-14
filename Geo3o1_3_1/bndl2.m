% Bundle adjustment for GeoPleiades

function bndl

%% ===== D E F I N A T I O N S =====
% ===== Number of iteration =====
nj = 1;

if nj == 1
    display(' Attention! Total iteration: 1')
end

if Sp == 0
    lsp =  0;
else
    lsp = length(Sp);
end

gcp1 = evalin('base', 'gcp1');
gcp2 = evalin('base', 'gcp2');

%% ===== I T E R A T I O N =====
for j = 1 : nj
    
    fprintf(' Bundle Adj. Iteration: %5d \n',j)
    display(' ============================= ')

    for i = 1 : length(gcp(: , 1))
        %% Jacobian matrix of EOPs for stereo images
        AEOP = Jacobian_EOP(unknown1, gcp1(i , :));
        AEOP_1(2 * i - 1 , :) = AEOP(1 , :);
        AEOP_1(2 * i     , :) = AEOP(2 , :);

        AEOP = Jacobian_EOP(unknown2, gcp2(i , :));
        AEOP_2(2 * i - 1 , :) = AEOP(1 , :);
        AEOP_2(2 * i     , :) = AEOP(2 , :);

        if exist('Sc','var') == 1
            %% Jacobian matrix of XYZ for stereo images
            AXYZ = Jacobian_XYZ(unknown1, gcp1(i , :));
            AXYZ_1(2 * i - 1, 3 * i - 2) = AXYZ(1 , 1);
            AXYZ_1(2 * i - 1, 3 * i - 1) = AXYZ(1 , 2);
            AXYZ_1(2 * i - 1, 3 * i    ) = AXYZ(1 , 3);

            AXYZ = Jacobian_XYZ(unknown2, gcp2(i , :));
            AXYZ_2(2 * i    , 3 * i - 2) = AXYZ(1 , 1);
            AXYZ_2(2 * i    , 3 * i - 1) = AXYZ(1 , 2);
            AXYZ_2(2 * i    , 3 * i    ) = AXYZ(1 , 3);
        end

        %% Jacobian matrix of Look angles
        B_LA = Jacobian_LA(unknown1, gcp1(i , :));
        B_1(2 * i - 1 , :) = B_LA(1 , :);
        B_1(2 * i     , :) = B_LA(2 , :);

        B_LA = Jacobian_LA(unknown2, gcp2(i , :));
        B_2(2 * i - 1 , :) = B_LA(1 , :);
        B_2(2 * i     , :) = B_LA(2 , :);
    end

    A = [AXYZ