function [spectraS, XYZ, XYZ0, sBasis] = ...
    ieSpectraSphere(wave, spectrumE, N, sBasis, sFactor)
% Calculate spectra that produce XYZ in a sphere around spectrumE 
%
% Syntax:
%   [spectraS, XYZ, XYZ0, sBasis] = ...
%       ieSpectraSphere([wave], [spectrumE], [N], [sBasis], [sFactor])
%
% Description:
%     Calculate spectra that produce XYZ in a sphere around spectrumE.
%
%    The spectraS, which are also in energy units, are about 5% modulations
%    of the spectrumE.
%
%    Use Energy2Quanta and Quanta2Energy to convert between energy and
%    photons. Scenes always store their data in photons.
%
% Inputs:
%    wave      - Wavelengths (default 400:10:700).
%    spectrumE - The spectral radiance (E) of the center of the sphere, in
%                energy units.  This should be a column vector (default
%                spectrum of zeros).
%    N         - Number of samples (default 8)
%    sBasis    - Spectral basis used for generating the differences.
%                Basis functions should be in the columns of this matrix,
%                and there should be 3 of them (default CIE daylight
%                basis).
%    sFactor   - Fractional difference between spectrumE and others
%               (default 0.05)
%
% Outputs:
%    spectraS  - The spectral radiance of the functions
%    XYZ       - CIE XYZ of the spectra
%    XYZ0      - CIE XYZ of spectrumE
%    sBasis    - Matrix defining the spectral basis for generating the
%                differences
%
% See Also:
%   cielab, scielab, s_scielabPatches
%

% History:
%    xx/xx/12       Copyright Imageval
%    11/01/17  jnm  Comments & formatting
%    11/16/17  jnm  Formatting
%

% Examples: 
%{
   N = 10;
   wave = 400:10:700;
   spectrumE = blackbody(wave, 6500, 'energy');
   sBasis = ieReadSpectra('cieDaylightBasis', wave);
   [spectraS, XYZ] = ieSpectraSphere(wave, spectrumE, N, sBasis)
   vcNewGraphWin;
   plot(wave, spectraS);
   plot3(XYZ(:, 1), XYZ(:, 2), XYZ(:, 3), 'o');
   axis equal
%}

%% Set up parameters
if notDefined('wave'), wave = 400:10:700; end
if notDefined('spectrumE'), spectrumE = zeros(size(wave)); end
if notDefined('N'), N = 8; end   % Matches default on sphere
if notDefined('sBasis')
    sBasis = ieReadSpectra('cieDaylightBasis', wave); 
elseif ischar(sBasis)
    % If it is a file name, read it. Otherwise, the user sent in the matrix
    % with columns as basis functions
    sBasis = ieReadSpectra(sBasis, wave);
end
if notDefined('sFactor'), sFactor = 0.05; end

cieXYZ = ieReadSpectra('XYZ', wave');

% Force to column vector.
spectrumE = spectrumE(:);

%% Make a sphere with sample points are (N + 1) * (N + 1)
[X, Y, Z] = sphere(N);
% surf(X, Y, Z); colormap(hot)

% These will be the change in XYZ around the center
dXYZ = [X(:), Y(:), Z(:)];

%% Calculate the spectra

% Now, we the find spectral weights on sBasis such that 
%  dXYZ = cieXYZ' * sBasis * w
%  w = inv(cieXYZ' * sBasis) * dXYZ'; 
% Or really, the spectra that produce these dXYZ. These spectra will have
% negative values. But we will add in the spectrumE (after scaling
% for about a 5% change).
spectraS = sBasis * ((cieXYZ' * sBasis) \ dXYZ'); 
spectraS = spectraS * sFactor * norm(spectrumE) / norm(spectraS(:, 1));
spectraS = spectraS + repmat(spectrumE, 1, size(spectraS, 2));
% vcNewGraphWin; plot(wave, spectraS);

if nargout > 1
    XYZ = ieXYZFromEnergy(spectraS', wave);
    XYZ0 = ieXYZFromEnergy(spectrumE', wave);
end

% vcNewGraphWin; 
% XYZ = ieXYZFromEnergy(spectraS', wave)
% plot3(XYZ(:, 1), XYZ(:, 2), XYZ(:, 3), 'o'); axis equal
end
