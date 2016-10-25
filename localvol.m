function lv=localvol(S,t)
    %lv=min(0.2+5*log(S/100).^2+0.1*exp(-t), 0.6);
    lv = 0.4;