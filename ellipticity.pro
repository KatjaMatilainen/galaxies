;--------------------------------------------------------------------;
; GALAXIES assignment
;--------------------------------------------------------------------;
; Use the subroutine PsPlot to save results in a postscript plot 
; (written by Heikki Salo)
;--------------------------------------------------------------------;
pro PsPlot,routine,filename
	thisdir=getenv('PWD')+'/'
	psopen,/color,dir=thisdir,filename
	call_procedure,routine
	psclose		
end

;--------------------------------------------------------------------;
;--------------------------------------------------------------------;
; MAIN PROGRAM
;--------------------------------------------------------------------;
pro ellipticity

;Read data from file and save to vectors
readcol,'ell.txt',data1,data2,data3,data4,data5,data6,$
  data7,data8,data9,skipline=5,numline=624

;Calculate the average ellipticity and position angle between r=[200,400]px
;Cut vectors
new_ell=!null
new_pa=!null
for t=0,n_elements(data2)-1 do begin
   if (data2(t) ge 200) and (data2(t) le 400) then begin
   new_ell=[new_ell,data7(t)]
   new_pa=[new_pa,data9(t)]
   endif
endfor
;Calculate averages
aver_ell=mean(new_ell)
aver_pa=mean(new_pa)

print,'aver_ell'
print,aver_ell
print,'aver_pa'
print,aver_pa

;Plot ellipticity
nwin
plot,data2,data7,xtitle='SMA (pixel)',ytitle='ELLIP',$
  title='Figure 1: Ellipticity as a function of radius',yrange=[0,1],xrange=[0,600]
oplot,[200,400],[0.602036,0.602036],linestyle=2,thick=2
xyouts,485,0.515,'e = 0.602036'
oplot,[475,560],[0.55,0.55]
oplot,[475,560],[0.5,0.5]
oplot,[475,475],[0.5,0.55]
oplot,[560,560],[0.5,0.55]

;Plot position angle
nwin
plot,data2,data9,xtitle='SMA (pixel)',ytitle='PA (degrees)',$
  title='Figure 2: Position angle as a function of radius',yrange=[-50,-20],xrange=[0,600]
oplot,[200,400],[-34.1896,-34.1896],linestyle=2,thick=2
xyouts,485,-36.65,'PA = -34.1896 deg'
oplot,[475,580],[-35.6,-35.6]
oplot,[475,580],[-37.3,-37.3]
oplot,[475,475],[-35.6,-37.3]
oplot,[580,580],[-35.6,-37.3]

;--------------------------------------------------------------------;
;--------------------------------------------------------------------;
; Read and plot luminosities from 'ell_fix.txt'
;--------------------------------------------------------------------;
readcol,'ell_fix.txt',fix1,fix2,fix3,fix4,fix5,fix6,$
  fix7,fix8,fix9,skipline=5,numline=624

;Plot luminosity
  nwin
  plot,fix2,fix3,xtitle='SMA (pixel)',ytitle='INTENS',$
    title='Figure 3: Intensity as a function of radius',$
    xrange=[0,500],yrange=[-10,4000]
  oplot,[0,500],[0,0],linestyle=2,thick=2

;Calculate magnitudes from luminosity profile
mag=-2.5d0*alog10(fix3)+26.27713d0
;Change radius to arcseconds (1 pixel = 0.396arcsec)
sec=fix2*0.396d0

;Plot magnitude
nwin
plot,sec,mag,xtitle='SMA (arcsec)',ytitle='MAG',$
  title='Figure 4: Magnitude as a function of radius in arcsec',$
  xrange=[0,200],yrange=[30,15]
  
;--------------------------------------------------------------------;
; BOOTSTRAPPING
;--------------------------------------------------------------------;

;Read values from background.txt
readcol,'new_bg.txt',bg1,bg2,bg3,bg4,bg5,bg6,bg7,$
format='A,F,F,F,F,F,F'

;Use bbootstrap.pro to determine sigma
means=bbootstrap(bg5,30,funct='biweight_mean',/slow)

;Calculate the mean value of stddev (column 5)
stddev=stddev(means)
print,'stddev'
print,stddev

lum_min=fix3-5*stddev
lum_max=fix3+5*stddev


;Minimum and maximum magnitude profiles
mag_min=-2.5d0*alog10(lum_min)+26.27713d0
mag_max=-2.5d0*alog10(lum_max)+26.27713d0
;Plot the min and max limits
oplot,sec,mag_min,linestyle=2
oplot,sec,mag_max,linestyle=3

;Check when is the difference between mag_min and mag more than 0.2mag
diff=mag_max-mag
first=0
for i=0,n_elements(diff)-1 do begin
  if abs(diff(i)) ge 0.2d0 then break
endfor

print,'index'
print,i
print,'difference in magnitude'
print,diff(i)

print,'radius in arcsec'
print,sec(i)

oplot,[sec(i),sec(i)],[30,15]
xyouts,40,18,'dMag > 0.2 when'
xyouts,40,18.5,'SMA >' 
xyouts,45,18.5,sec(i)
xyouts,69,18.5,'" ' 
oplot,[37.5,75],[17.3,17.3]
oplot,[37.5,75],[18.8,18.8]
oplot,[37.5,37.5],[17.3,18.8]
oplot,[75,75],[17.3,18.8]

;-------------------------------------------------------------------;
; Fit luminosity profile
;-------------------------------------------------------------------;
; First, plot lines for n=1 and n=4 and find break radius Rb

;n=4
func_n1=sec*(1/40.d0)+19.8d0
;n=1
func_n2=sec*(1/20.2d0)+17.2d0

;Find out where the two lines cross
for l=0,n_elements(func_n1)-1 do begin
   if abs(func_n1(l)-func_n2(l)) le 0.01d0 then print,'index',l,'Rb',sec(l)
   ;endif
endfor

nwin
plot,sec,mag,xrange=[0,200],yrange=[30,15],title='Figure 5: First estimate of the break radius Rb',xtitle='SMA(arcsec)',ytitle='MAG'
oplot,sec,func_n1,linestyle=2
oplot,sec,func_n2,linestyle=2
oplot,[sec(451),sec(451)],[30,15]
xyouts,115,19,'Rb=106.48440'

; CURVEFIT -function
; const=initial estimates for parameters that need to be fitted
; sigma=standard deviations for luminosity?
; function_name=name of the separate function you created

;Cut the radius vector between [30,155.41416]
;No bulge and no noise!
new_radius=!null
new_luminosity=!null
for m=0,n_elements(sec)-1 do begin
   if (sec(m) ge 30) and (sec(m) le 155.41416) then begin
   new_radius=[new_radius,sec(m)]
   new_luminosity=[new_luminosity,fix3(m)]
   endif
endfor

print,'n_elements(new_radius)'
print,n_elements(new_radius)

print,'new_luminosity(0)'
print,new_luminosity(0)

;const=[n,beta,gamma,sec_b,I0] ;Here sec_b=Rb and alpha=0.5/n
const=[2.d0,80.d0,50.d0,100.d0,200.d0]
sigma=stddev
weights=replicate(1.d0,n_elements(new_radius))

result=mpcurvefit(new_radius,new_luminosity,weights,const,sigma,/double,/noderivative,$
function_name='luminosity2')

new_mag=-2.5d0*alog10(result)+26.27713d0

nwin
plot,sec,mag,title='Figure 6: Fitted model, magnitude',xrange=[0,200],yrange=[30,15],$
xtitle='SMA(arcsec)',ytitle='MAG'
oplot,new_radius,new_mag,linestyle=2,thick=3

;Final constants
print,'const'
print,const
end

;--------------------------------------------------------------------;
; Save the results to a PostScript file using PsPlot
;--------------------------------------------------------------------;
pro Plot_everything
PsPlot, 'ellipticity', 'ellipticity.ps'
end
