#!/bin/sh

config=".my.cnf.$$"
command=".mysql.$$"

trap "interrupt" 1 2 3 6 15

rootpass=""
echo_n=
echo_c=
basedir=
bindir=

parse_arg()
{
  echo "$1" | sed -e 's/^[^=]*=//'
}

parse_arguments()
{
  pick_args=
  if test "$1" = PICK-ARGS-FROM-ARGV
  then
    pick_args=1
    shift
  fi

  for arg
  do
    case "$arg" in
      --basedir=*) basedir=`parse_arg "$arg"` ;;
      --no-defaults|--defaults-file=*|--defaults-extra-file=*)
        defaults="$arg" ;;
      *)
        if test -n "$pick_args"
        then
          args="$args $arg"
        fi
        ;;
    esac
  done
}

find_in_basedir()
{
  return_dir=0
  found=0
  case "$1" in
    --dir)
      return_dir=1; shift
      ;;
  esac

  file=$1; shift

  for dir in "$@"
  do
    if test -f "$basedir/$dir/$file"
    then
      found=1
      if test $return_dir -eq 1
      then
        echo "$basedir/$dir"
      else
        echo "$basedir/$dir/$file"
      fi
      break
    fi
  done

  if test $found -eq 0
  then
      $file --no-defaults --version > /dev/null 2>&1
      status=$?
      if test $status -eq 0
      then
        echo $file
      fi
  fi
}

cannot_find_file()
{
  echo
  echo "FATAL ERROR: Could not find $1"

  shift
  if test $# -ne 0
  then
    echo
    echo "The following directories were searched:"
    echo
    for dir in "$@"
    do
      echo "    $dir"
    done
  fi

  echo
  echo "If you compiled from source, you need to run 'make install' to"
  echo "copy the software into the correct location ready for operation."
  echo
  echo "If you are using a binary release, you must either be at the top"
  echo "level of the extracted archive, or pass the --basedir option"
  echo "pointing to that location."
  echo
}

parse_arguments PICK-ARGS-FROM-ARGV "$@"

if test -n "$basedir"
then
  print_defaults=`find_in_basedir my_print_defaults bin extra`
  if test -z "$print_defaults"
  then
    cannot_find_file my_print_defaults $basedir/bin $basedir/extra
    exit 1
  fi
else
  print_defaults="/usr/bin/my_print_defaults"
fi

if test ! -x "$print_defaults"
then
  cannot_find_file "$print_defaults"
  exit 1
fi

parse_arguments `$print_defaults $defaults client client-server client-mariadb`
parse_arguments PICK-ARGS-FROM-ARGV "$@"

if test -n "$basedir"
then
  bindir="$basedir/bin"
elif test -f "./bin/mariadb"
  then
  bindir="./bin"
else
  bindir="/usr/bin"
fi

mysql_command=`find_in_basedir mariadb $bindir`
if test -z "$mysql_command"
then
  cannot_find_file mariadb $bindir
  exit 1
fi

set_echo_compat() {
    case `echo "testing\c"`,`echo -n testing` in
	*c*,-n*) echo_n=   echo_c=     ;;
	*c*,*)   echo_n=-n echo_c=     ;;
	*)       echo_n=   echo_c='\c' ;;
    esac
}

prepare() {
    touch $config $command
    chmod 600 $config $command
}

do_query() {
    echo "$1" >$command
    $bindir/mariadb --defaults-file=$config <$command
    return $?
}

basic_single_escape () {
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

make_config() {
    echo "# mariadb_secure_installation config file" >$config
    echo "[mariadb]" >>$config
    echo "user=root" >>$config
    esc_pass=`basic_single_escape "$rootpass"`
    echo "password='$esc_pass'" >>$config
}

get_root_password() {
    status=1
    while [ $status -eq 1 ]; do
	stty -echo
	echo $echo_n "Go phim [ENTER] de tiep tuc qua trinh cai dat $echo_c"
	read password
	echo
	stty echo
	if [ "x$password" = "x" ]; then
	    hadpass=0
	else
	    hadpass=1
	fi
	rootpass=$password
	make_config
	do_query ""
	status=$?
    done
    echo
}

set_root_password() {
    stty -echo
    echo $echo_n "Nhap mat khau: $echo_c"
    read password1
    echo
    echo $echo_n "Nhap lai lan nua: $echo_c"
    read password2
    echo
    stty echo

    if [ "$password1" != "$password2" ]; then
	echo "Xin loi, ban go 2 lan khong giong nhau."
	echo
	return 1
    fi

    if [ "$password1" = "" ]; then
	echo "Xin loi, ban khong the dat mat khau trang."
	echo
	return 1
    fi

    esc_pass=`basic_single_escape "$password1"`
    #do_query "UPDATE mysql.user SET authentication_string=PASSWORD('$esc_pass') WHERE User='root';"
    do_query "ALTER USER 'root'@'localhost' IDENTIFIED BY '$esc_pass';"

cat >> "/home/lemp.conf" <<END
mariadbpass="$password1"
END

#if grep -q "mariadbpass=" "/home/lemp.conf"; then
#    sed -i "s/^mariadbpass=.*/mariadbpass=\"$password1\"/" "/home/lemp.conf"
#else
#    echo "mariadbpass=\"$password1\"" >> "/home/lemp.conf"
#fi


    if [ $? -eq 0 ]; then
	reload_privilege_tables
	rootpass=$password1
	make_config
    else
	clean_and_exit
    fi

    return 0
}

remove_anonymous_users() {
    do_query "DELETE FROM mysql.user WHERE User='';"
    return $?
}

remove_remote_root() {
    do_query "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
}

remove_test_database() {
    do_query "DROP DATABASE IF EXISTS test;"
    do_query "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
}

reload_privilege_tables() {
    do_query "FLUSH PRIVILEGES;"
}

interrupt() {
    cleanup
    stty echo
    exit 1
}

cleanup() {
    rm -f $config $command
}

clean_and_exit() {
	cleanup
	exit 1
}

prepare
set_echo_compat

get_root_password

if [ $hadpass -eq 0 ]; then
    echo $echo_n "Go [ENTER] de dat mat khau cho tai khoan root cua MariaDB $echo_c"
else
    echo "You already have a root password set, so you can safely answer 'n'."
    echo $echo_n "Change the root password? [Y/n] $echo_c"
fi

read reply
if [ "$reply" != "n" ]; then
    status=1
    while [ $status -eq 1 ]; do
	set_root_password
	status=$?
    done
    remove_anonymous_users
    remove_remote_root
    remove_test_database
    reload_privilege_tables
fi

cleanup
