exec >&2
ssh-keygen -t rsa -f $3 -N ""
mv $3.pub $1.pub
