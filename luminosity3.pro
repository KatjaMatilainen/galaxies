;-------------------------------------------------------------------------;
; Function for luminosity profile fitting
;-------------------------------------------------------------------------;
;input=x,a
;output=f,pder

pro luminosity3,sec,const2,lum_fit,pder
alpha=0.5d0/1
beta=const2[0]
gamma=const2[1]
sec_b=const2[2]
;I0=17.249416
;I0=4084.d0
I0=const2[3]
;help=1.d0/alpha*(1.d0/gamma-1.d0/beta)
;ss=(1+exp(-alpha*sec_b))^(-help)

;lum_fit=ss*I0*exp(-sec/gamma)*(1+exp(alpha*(sec-sec_b)))^help

lum_fit=(1+exp(-alpha*sec_b))^(-1.d0/alpha*(1.d0/gamma-1.d0/beta))*I0*exp(-sec/gamma)*(1+exp(alpha*(sec-sec_b)))^(1.d0/alpha*(1.d0/gamma-1.d0/beta))

;Partial derivatives
;dI/dalpha=
;dI/dbeta
;dI/dgamma
;dI/dsec_b
;dI/I0

;     if n_params() GE 4  then begin
       ; Create derivative and compute derivative array
;       pder = make_array(n_elements(sec), n_elements(const), value=sec[0]*0)
;
       ; Compute derivative if requested by caller
;       for i = 0, n_elements(const)-1 do pder(*,i) = FGRAD(sec, const, i)
;     endif

end
