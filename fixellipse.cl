# fixellipse -- IRAF task to do ellipse fits to an image, with
# several standard options set.  This task does fixed-ellipse fits.
#
#    Note that (xc,yc) is intended to be the center of all the
# isophotes; however, the ellipse program will automatically attempt
# to determine a center anyway, even if we tell it (geompar.recenter=no)
# that we won't use such a center.  If it can't find a center, it will
# quit.  By setting geompar.xylearn = yes,  we can circumvent this problem;
# the program will then ask the user for (x0,y0), and use those values. 
procedure fixellipse( image, table, xc, yc, a_0, pa_0, ell_0, max )

string  image  {prompt = 'input image name '}
string  table  {prompt = 'output table name '}
real  xc  {prompt = 'isophote center X'}
real  yc  {prompt = 'isophote center Y'}
real  a_0  {prompt = 'initial semi-major axis'}
real  pa_0  {prompt = 'position angle'}
real  ell_0  {prompt = 'ellipticity'}
real  max  {prompt = 'maximum semi-major axis'}
real  a_min = 3.0
real  delta = 0.03
bool  linear_sma = no
bool  relearnxy = no
  

begin

  string table_tab, table_txt
  string  script_string

  table_tab = table // ".tab"
  table_txt = table // ".txt"

  # Define starting ellipse:
  geompar.x0 = xc
  geompar.y0 = yc
  geompar.ellip0 = ell_0
  geompar.pa0 = pa_0
  geompar.sma0 = a_0

  # Define iteration parameters
  geompar.minsma = a_min
  geompar.maxsma = max
  geompar.step = delta
  geompar.linear = linear_sma

  # Specify fixed ellipses:
  geompar.recenter = no
  controlpar.hcenter = yes
  controlpar.hellip = yes
  controlpar.hpa = yes

  # Option: force the program to ask us for (x0,y0) if it can't find
  # find a center automatically (even though we tell it to ignore
  # any such center it might find).
  geompar.xylearn = relearnxy

  # Do the fits:
  ellipse( input=image, output=table_tab )

  # Make text-file version:
  tprint( table=table_tab, >table_txt )

  # Clean up text-file version (convert INDEF to 0.0)
  script_string = "/home/matilainen/matilkat/python/indef.py " // table_txt // "\n"
  printf(script_string, > "indefscript1")
  !source indefscript1
  delete("indefscript1", >>& "dev$null")

end

