;-------------------------------------------------------------------------;
; Function for luminosity profile fitting
;-------------------------------------------------------------------------;
;input=x,a
;output=f,pder

pro luminosity2,sec,const,lum_fit,pder
alpha=0.5d0/const[0]
beta=const[1]
gamma=const[2]
sec_b=const[3]
I0=const[4]

help=1.d0/alpha*(1.d0/gamma-1.d0/beta)
ss=(1+exp(-alpha*sec_b))^(-help)
lum_fit=ss*I0*exp(-sec/gamma)*(1+exp(alpha*(sec-sec_b)))^help

;lum_fit=(1+exp(-alpha*sec_b))^(-1.d0/alpha*(1.d0/gamma-1.d0/beta))*I0*exp(-sec/gamma)*(1+exp(alpha*(sec-sec_b)))^(1.d0/alpha*(1.d0/gamma-1.d0/beta))

end
