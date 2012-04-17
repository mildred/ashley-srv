if [ -e config ]; then
  redo-ifchange config
  . ./config
else
  redo-ifcreate config
fi

: ${slave:=}
: ${master:=}

