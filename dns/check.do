exec >&2

. ./config.sh

res=0
set +e

for zone in $master $slave; do
  redo-ifchange zones/$zone
  named-checkzone $zone zones/$zone
  res=$(($res+$?))
done

exit $res
