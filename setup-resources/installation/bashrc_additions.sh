
# Added to .bashrc by EC2 desktop setup script

function getrepo {
  user=$1
  repo=$2
  pushd ~/git
  echo "yes" | git clone git@github.com:$user/$repo.git
  popd
}
