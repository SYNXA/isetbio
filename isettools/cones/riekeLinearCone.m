function adaptedData = riekeLinearCone(pRate,p)

%%
if ~exist('pRate','var') || isempty(pRate), error('Photon absorption rate required.'); end
if ~exist('p','var') || isempty(p), error('Initial state required.'); end
    
% One millisecond time step, as in s_fredConeModel.m
if isfield(p, 'timeInterval'), dt = p.timeInterval; else dt = 0.001; end

if isfield(p, 'Ib'), Ib = p.Ib; else Ib = mean(pRate(:)); end

%% cone IRF

% move these to riekeInit
TimeAxis = [1:size(pRate, 3)]*dt;
TauR = 0.0216;   % Rising Phase Time Constant
TauD = 0.0299;   % Damping Time Constant
TauP = 0.5311;   % Period

Io = 2250;                     % half-desensitizing background (in R*/cone/sec, from Juan's paper - corrected)if (i
gain_dark = 0.22; %0.32;              % from Juan's paper (approximate peak of the IRF measured in darkness, and in units of pA/R*) - corrected
gainRatio = 1 ./ (1+(Ib./Io)); % the right side of the equation above, and the gain ratio implied by the bkgnd adapting field

Phi = 34.1814;   % Phase

Filter = (((TimeAxis./TauR).^3)./(1+((TimeAxis./TauR).^3))) .* exp(-((TimeAxis./TauD))).*cos(((2.*pi.*TimeAxis)./TauP)+(2*pi*Phi/360));

newGain = gainRatio .* gain_dark;
oldGain = max(Filter);
Filter = Filter * dt * newGain / oldGain;
maxCur = p.k * p.gdark^p.h/2;
meanCur = maxCur * (1 - 1 / (1 + 45000 / mean(pRate(:))));
FilterFFT = fft(Filter');
for x = 1:size(pRate, 1)
    for y = 1:size(pRate, 2)
        tempData = conv(squeeze(pRate(x, y, :)), Filter);
%        tempData = real(ifft(conj(fft(squeeze(pRate(x, y, :))) .* FilterFFT)));
        if (p.Compress)
            tempData = tempData / maxCur;
            tempData = meanCur * (tempData ./ (1 + 1 ./ tempData)-1);
        else
            tempData = tempData - meanCur;
        end
        adaptedData(x, y, :) = tempData(1:length(Filter)); 
    end
end

end
