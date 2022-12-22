#!/bin/sh

cd po

xgettext --language=Perl --default-domain=pppconfig --directory=.. \
	 --add-comments --keyword=_ --keyword=N_ \
	 --files-from=POTFILES.in && test ! -f pppconfig.po \
	 || ( rm -f templates.pot && mv pppconfig.po templates.pot )

# Moving along..

ls *.po | sed 's/\.po$//' > LINGUAS
for lang in `cat LINGUAS`; do
  mv $lang.po $lang.old.po
  echo "$lang:"
  if msgmerge --previous $lang.old.po templates.pot -o $lang.po; then
    rm -f $lang.old.po
  else
    echo "msgmerge for $lang.po failed!"
    if cmp --quiet $lang.po $lang.old.po ; then
      rm -f $lang.old.po
    else
      mv -f $lang.old.po $lang.po
    fi
  fi
done
