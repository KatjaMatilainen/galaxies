# doellipse -- IRAF task to do ellipse fits to an image, with
# several standard options set.  This task does free-ellipse fits.
#
#   The default is to do logarithmic semi-major axis spacing,
# with a default inner sma = 3 pixels and a default logarithmic
# spacing of delta=0.03 in sma.  If linear_sma=yes, then 
# delta = spacing in pixels.

procedure doellipse( image, table, xc, yc, a_0, pa_0, ell_0, max )

string  image  {prompt = 'input image name '}
string  table  {prompt = 'output table name '}
real  xc  {prompt = 'initial isophote center X'}
real  yc  {prompt = 'initial isophote center Y'}
real  a_0  {prompt = 'initial semi-major axis'}
real  pa_0  {prompt = 'initial position angle'}
real  ell_0  {prompt = 'initial ellipticity'}
real  max  {prompt = 'maximum semi-major axis'}
real  a_min = 3.0      {prompt = 'minimum semi-major axis '}
real  delta = 0.03     {prompt = 'spacing in semi-major axis '}
bool  linear_sma = no  {prompt = 'do linear spacing in semi-major axis? '}
bool  fix_center = no  {prompt = 'hold center fixed to (x0,y0)? '}


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

  # Specify free ellipses:
  geompar.recenter = yes
  geompar.xylearn = yes
  controlpar.hcenter = fix_center
  controlpar.hellip = no
  controlpar.hpa = no

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

