# add /opt/modulefiles/* to module search path
for F in `find /opt/modulefiles -maxdepth 1 -mindepth 1 -type d`; do
  if test -z "$MODULEPATH"; then
    export MODULEPATH=${F}
  elif ! [[ "${MODULEPATH}" =~ "${F}" ]]; then
    export MODULEPATH=${F}:${MODULEPATH}
  fi
done

# add path to scripts 
if test -z "${PATH}"; then
  export PATH=/opt/nbcr/bin:/opt/nbcr/sbin
else
  if ! [[ "${PATH}" =~ "/opt/nbcr/bin" ]]; then
    export PATH=/opt/nbcr/bin:$PATH
  fi
  if ! [[ "${PATH}" =~ "/opt/nbcr/sbin" ]]; then
    export PATH=/opt/nbcr/sbin:$PATH
  fi
fi

# create vars for resources
export NBCRHOME=/opt/nbcr
export NBCRDEVEL=/opt/nbcr/devel
