#!/bin/bash

. /home/lemp.conf

if [ -f /etc/cron.d/servertut.downtime.cron ]; then
read -r -p "Downtime Statics hien dang bat, ban co muon tat khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
	rm -f /etc/cron.d/servertut.downtime.cron
	service crond restart

    cat > "/tmp/sendmail.sh" <<END
#!/bin/bash

echo -e 'Subject: LEMP - Tat Downtime Statics thanh cong!\nChao ban!\n\nEmail thong bao cho ban biet rang yeu cau tat Downtime Statics cua ban da thuc hien thanh cong. Neu ban khong he yeu cau lam dieu nay, vui long doi lai toan bo thong tin lien quan den VPS va thuc hien bao mat cho VPS\n\n !' | exim  $email
END
chmod +x /tmp/sendmail.sh
/tmp/sendmail.sh
rm -f /tmp/sendmail.sh
	echo "Downtime Statics da duoc tat thanh cong !"
        ;;
    *)
        echo "Chao tam biet....!"
        ;;
esac
else
read -r -p "Downtime Statics hien dang tat, ban co muon bat len khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
	    cat > "/etc/cron.d/servertut.downtime.cron" <<END
SHELL=/bin/sh
* * * * * /bin/servertut-check-downtime >/dev/null 2>&1
END
	service crond restart

    cat > "/tmp/sendmail.sh" <<END
#!/bin/bash

echo -e 'Subject: LEMP - Bat Downtime Statics thanh cong!\nChao ban!\n\nEmail thong bao cho ban biet rang yeu cau bat Downtime Statics cua ban da thuc hien thanh cong. Neu ban khong he yeu cau lam dieu nay, vui long doi lai toan bo thong tin lien quan den VPS va thuc hien bao mat cho VPS\n\n !' | exim  $email
END
chmod +x /tmp/sendmail.sh
/tmp/sendmail.sh
rm -f /tmp/sendmail.sh
	echo "Downtime Statics da duoc bat thanh cong !"
        ;;
    *)
        echo "Chao tam biet....!"
        ;;
esac
exit
fi
