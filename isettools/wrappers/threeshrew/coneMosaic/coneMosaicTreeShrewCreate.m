function theConeMosaic = coneMosaicTreeShrewCreate(micronsPerDegree,varargin)
% Create a coneMosaic object for the TreeShrew retina
%
% Syntax:
%   theConeMosaic = CONEMOSAICTREESHREWCREATE(varargin)
%
p = inputParser;
p.addParameter('fovDegs', [2 2], @isnumeric);
p.addParameter('spatialDensity', [0 0.5 0 0.5], @isnumeric);
p.addParameter('customLambda', 7.5, @isnumeric);
p.addParameter('customInnerSegmentDiameter', 7, @isnumeric);
p.addParameter('integrationTimeSeconds', 5/1000, @isnumeric);
p.addParameter('sConeMinDistanceFactor', 2, @isnumeric);
p.addParameter('resamplingFactor', 2, @isnumeric);
% Parse input
p.parse(varargin{:});

spatialDensity = p.Results.spatialDensity;
fovDegs = p.Results.fovDegs;
customLambda = p.Results.customLambda;
customInnerSegmentDiameter = p.Results.customInnerSegmentDiameter;
integrationTimeSeconds = p.Results.integrationTimeSeconds;
sConeMinDistanceFactor = p.Results.sConeMinDistanceFactor;
resamplingFactor = p.Results.resamplingFactor;

% Treeshrew-specific scaling
treeShrewScaling = 300/micronsPerDegree;

if (spatialDensity(1) ~= 0)
    error('The first element in spatialDensity vector must be 0.');
end
if (spatialDensity(3) ~= 0)
    error('The third element in spatialDensity (M-cone density) vector must be 0.');
end

thePhotopigment = treeShrewPhotopigment();

theConeMosaic = coneMosaicHex(resamplingFactor, ...
    'fovDegs', fovDegs/(treeShrewScaling^2), ...
    'micronsPerDegree',micronsPerDegree, ...
    'integrationTime', integrationTimeSeconds, ...
    'pigment', thePhotopigment ,...
    'macular', treeShrewMacularPigment(thePhotopigment.wave), ...
    'customLambda', customLambda, ...
    'customInnerSegmentDiameter', customInnerSegmentDiameter, ...
    'spatialDensity', spatialDensity, ...
    'sConeMinDistanceFactor', sConeMinDistanceFactor, ...
    'sConeFreeRadiusMicrons', 0 ...
    );
end

function theMacularPigment = treeShrewMacularPigment(wavelength)
% Generate threeshrew-specific macular pigment  (absent, so zero density)
theMacularPigment = Macular(...
    'wave', wavelength, ...
    'density', 0);
end

