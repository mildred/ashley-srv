exec >&2
: >"$3"

mkdir -p zones

. ./config.sh

for domain in $master; do
  redo-ifchange zones/$domain
  cat >>"$3" <<EOF

zone "$domain" {
  type master;
  file "$(pwd)/zones/$domain";
};

EOF
done

for domain in $slave; do
  redo-ifchange zones/$domain
  cat >>"$3" <<EOF

zone "$domain" {
  type slave;
  file "$(pwd)/zones/$domain";
};

EOF
done

named-checkconf $3

