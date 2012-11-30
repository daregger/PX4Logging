function out = GPS_noiseGen(in,sigma)
    out = in + sigma*randn;
end