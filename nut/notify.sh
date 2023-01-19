#! /bin/bash

/bin/mail -s "UPS '$UPSNAME': $NOTIFYTYPE" root <<END
$*
END
