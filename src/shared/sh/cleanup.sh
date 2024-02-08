#!/bin/bash
ls -1 /usr/share/locale | while IFS= read -r entry; do
	if [[ "$entry" == *".alias" ]]; then
		echo "Skipped $entry ."
	else
		echo "Removing $entry ..."
		rm -rf "/usr/share/locale/$entry"
	fi
done
ls -1 /usr/share/man | while IFS= read -r entry; do
	if [[ "$entry" == "man"* ]]; then
		echo "Skipped $entry ."
	else
		echo "Removing $entry ..."
		rm -rf "/usr/share/man/$entry"
	fi
done
exit