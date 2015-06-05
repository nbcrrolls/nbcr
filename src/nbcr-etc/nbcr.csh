# add /opt/modulefiles/* to module search path
foreach F (`find /opt/modulefiles -maxdepth 1 -mindepth 1 -type d`)
  if (! $?MODULEPATH ) then
    setenv MODULEPATH ${F}
  else if ( "$MODULEPATH" !~ *${F}* ) then
    setenv MODULEPATH ${F}:${MODULEPATH}
  endif
end

# add path to scripts 
if (! $?path ) then
  set path = ( /opt/nbcr/bin /opt/nbcr/sbin )
else
  if ( "$path" !~ */opt/nbcr/bin* ) then
    set path = ( /opt/nbcr/bin $path )
  endif
  if ( "$path" !~ */opt/nbcr/sbin* ) then
    set path = ( /opt/nbcr/sbin $path )
  endif
endif

# create vars for resources
setenv NBCRHOME /opt/nbcr
setenv NBCRDEVEL /opt/nbcr/devel
